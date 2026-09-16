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

All four kinds ship inside the app as described above, the PDF included — so it opens on a plane like the rest.
It travels a little differently, because a PDF is bytes rather than text: the Reader puts its copy straight into the same on-device store a downloaded document would go to, instead of carrying it on the queue entry.
Nothing about that is visible while reading; it matters only if the copy is ever cleared, at which point the Reader fetches this one again from here.

### The two PDFs

There are two, and the difference between them is **size**, not subject.

| File | Pages | Size | For |
| --- | --- | --- | --- |
| [`docs/Incident-review.pdf`](docs/Incident-review.pdf) | 4 | ~200 KB | Reading. Long enough that scrolling, the progress figure and reopening where you left off are all visible. |
| [`docs/Handover-card.pdf`](docs/Handover-card.pdf) | 2 | ~73 KB | Travelling. Small enough to ride inside a link and a sync record, which the larger one is not. |

⚠️ **The small one is small on purpose and it is easy to undo by accident.** Almost all of a PDF's weight here is embedded fonts, and Chrome embeds a *separate subset per page, per face* — it does not share them. The four-page document uses a serif, its bold, its italic and a monospace face, which is fourteen embedded font programs; the card uses one family in regular and bold across two pages, which is six. Adding an italic or a snippet of code to the card is what would quietly push it back over the line.

### Regenerating them

Each `.pdf` is exported from the `.html` of the same name beside it, which is the source of truth — the same arrangement as the diagrams, where the `.svg` is the original and the `.png` is made from it.

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new \
  --print-to-pdf=docs/Handover-card.pdf --no-pdf-header-footer \
  file://"$PWD"/docs/Handover-card.html
```

## Using them yourself

Everything here is written for this purpose and free to read, copy and quote — see [LICENSE](LICENSE).

Nothing in this repository is a working project. Do not look for a build.
