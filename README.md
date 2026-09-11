# Multirepo Reader — sample documents

The documents [Multirepo Reader](https://github.com/aharbavets/multirepo-reader-ios) offers on first run.

This repository is **public on purpose**, and it exists for one reason: somebody who has just installed the Reader should be able to tap one button and have real documents to open, instead of an empty list and an instruction to go and find a link.

## How the Reader uses it

Each sample is an ordinary queue entry — it keeps its real URL here, so *Open in Browser* works and the row says where it came from.

The text also ships **inside the app**, so the samples open on a plane, at a gate, or on a phone with no signal. That copy is a snapshot taken at build time: this repository is the original, and the two will drift apart, exactly as any other saved copy in the Reader does.

## What is here

Between them the samples show the three things the Reader can display:

- a Markdown document,
- a source file, so the syntax highlighting is visible,
- a diff.

## Using them yourself

Everything here is written for this purpose and free to read, copy and quote — see [LICENSE](LICENSE).

Nothing in this repository is a working project. Do not look for a build.
