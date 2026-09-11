import Foundation

/// How often, and how patiently, an operation is retried before it is allowed
/// to fail for good.
///
/// The defaults are the ones `checkout-service` uses for outbound calls to a
/// payment processor: retry quickly at first, then back off hard, and give up
/// well inside the caller's own timeout.
struct RetryPolicy {
    /// The number of attempts, the first one included — so `1` means "do not
    /// retry", never "retry once".
    let attempts: Int
    /// How long to wait before the second attempt. Every later wait is this
    /// one multiplied by `factor` for each attempt already made.
    let initialDelay: TimeInterval
    /// The ceiling on a single wait. Without it, the fifth attempt on a slow
    /// day waits longer than anybody is prepared to sit and watch.
    let maximumDelay: TimeInterval
    let factor: Double

    static let standard = RetryPolicy(
        attempts: 4,
        initialDelay: 0.25,
        maximumDelay: 8,
        factor: 2
    )

    /// The wait before `attempt`, which is 1-based: attempt 1 never waits.
    func delay(before attempt: Int) -> TimeInterval {
        guard attempt > 1 else { return 0 }
        let exponent = Double(attempt - 2)
        return min(initialDelay * pow(factor, exponent), maximumDelay)
    }
}

/// The errors worth trying again. Anything else is the server telling us that
/// repeating ourselves will not help.
enum RetryDecision {
    case retry
    case giveUp

    static func forStatus(_ status: Int) -> RetryDecision {
        switch status {
        case 408, 429, 500...599: .retry
        default: .giveUp
        }
    }
}

extension RetryPolicy {
    /// Runs `work` until it succeeds, until the policy runs out of attempts, or
    /// until the task is cancelled — whichever comes first.
    func run<Value>(
        _ work: (_ attempt: Int) async throws -> Value
    ) async throws -> Value {
        var lastError: Error?

        for attempt in 1...attempts {
            if attempt > 1 {
                try await Task.sleep(for: .seconds(delay(before: attempt)))
            }

            do {
                return try await work(attempt)
            } catch let error as HTTPError where RetryDecision.forStatus(error.status) == .retry {
                lastError = error
                log("attempt \(attempt) of \(attempts) failed with \(error.status)")
            }
        }

        throw lastError ?? RetryError.exhausted(attempts: attempts)
    }
}
