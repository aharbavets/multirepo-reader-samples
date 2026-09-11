# Runbook: checkout-service is paging

**Service:** `checkout-service`
**Owner:** Payments
**Escalation:** `#payments-oncall`, then the Payments lead

This is the page you are most likely to get at 3 a.m., so it is written to be read at 3 a.m.
Work top to bottom and stop as soon as the symptom matches.

> The goal of the first ten minutes is to make the errors stop, not to understand them.
> Understanding is the write-up you do at 10 a.m. with coffee.

## Before anything else

- [ ] Say something in `#payments-oncall`, even if it is only *"I have it"*. Two people fixing the same incident separately is worse than one person fixing it slowly.
- [ ] Open the **Checkout** dashboard and look at three numbers: error rate, p99 latency, and orders per minute.
- [ ] Check whether a deploy went out in the last thirty minutes. It usually did.

## Match the symptom

| What you see | What it usually is | Go to |
| --- | --- | --- |
| Error rate up, latency flat | A bad release | [Roll back](#roll-back) |
| Latency up, error rate follows a few minutes later | The database is struggling | [Shed load](#shed-load) |
| Errors only on one card brand | The processor, not us | [Confirm upstream](#confirm-upstream) |
| Orders per minute at zero, everything else healthy | The front end, not us | Page Web |

## Roll back

Rolling back is cheap and almost never the wrong call.
Do it first and diagnose afterwards.

```bash
checkoutctl releases list --limit 5
checkoutctl rollback --to <previous release id> --reason "paging, error rate 4%"
```

The rollback takes about ninety seconds.
Watch the error rate rather than the deploy log — the log will say *succeeded* before the old version is actually taking traffic.

⚠️ **A rollback does not undo a database migration.**
If the release you are backing out of shipped one, check that the previous version still starts against the migrated schema before you send traffic to it.

## Shed load

When the database is the bottleneck, the fastest safe lever is to stop accepting new carts while letting existing ones finish paying.
A customer who cannot start checking out is annoyed; a customer whose payment is half-finished calls support.

```bash
checkoutctl flags set checkout.accept_new_carts false
```

Turn it back on as soon as p99 is under 400 ms for five straight minutes.

## Confirm upstream

Before escalating to the processor, get one failing request ID and its response body.
*"Visa is broken"* starts a long conversation; a request ID and a `502` ends it in ten minutes.

## When it is over

Write the timeline the same day, while you still remember the order things happened in.
Three lines are enough: what broke, what you did, and what would have caught it sooner.

---

*This document is a sample shipped with Multirepo Reader. The service it describes does not exist.*
