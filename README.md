# Multirepo Reader — sample documents

The documents [Multirepo Reader](https://github.com/aharbavets/multirepo-reader-ios) offers on first run.

This repository is **public on purpose**, and it exists for one reason: somebody who has just installed the Reader should be able to tap one button and have real documents to open, instead of an empty list and an instruction to go and find a link.

## How the Reader uses it

Each sample is an ordinary queue entry — it keeps its real URL here, so *Open in Browser* works and the row says where it came from.

The text also ships **inside the app**, so the samples open on a plane, at a gate, or on a phone with no signal. That copy is a snapshot taken at build time: this repository is the original, and the two will drift apart, exactly as any other saved copy in the Reader does.

## What is here

Between them the samples show what the Reader can display:

- a Markdown document,
- a source file, so the syntax highlighting is visible,
- a diff,
- a PDF.

All four ship inside the app as described above, the PDF included — so it opens on a plane like the rest.
It travels a little differently, because a PDF is bytes rather than text: the Reader puts its copy straight into the same on-device store a downloaded document would go to, instead of carrying it on the queue entry.
Nothing about that is visible while reading; it matters only if the copy is ever cleared, at which point the Reader fetches this one again from here.

[`docs/Incident-review.pdf`](docs/Incident-review.pdf) is exported from [`docs/Incident-review.html`](docs/Incident-review.html) beside it, which is the source of truth — the same arrangement as the diagrams, where the `.svg` is the original and the `.png` is made from it.
To regenerate it after editing the HTML:

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new \
  --print-to-pdf=docs/Incident-review.pdf --no-pdf-header-footer \
  file://"$PWD"/docs/Incident-review.html
```

## Using them yourself

Everything here is written for this purpose and free to read, copy and quote — see [LICENSE](LICENSE).

Nothing in this repository is a working project. Do not look for a build.
