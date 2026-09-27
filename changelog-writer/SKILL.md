---
name: changelog-writer
description: >-
  Drafts a CHANGELOG entry from recent commits or a PR diff, grouped into
  Added/Changed/Fixed. Invoke when the user says "update the changelog",
  "write a changelog entry", or "what should go in the release notes".
---

# Changelog Writer

Turn recent git history into a clean, human-readable changelog entry — never
just a dump of raw commit messages.

## Step 1 — Collect the range

Ask the user (if not already clear from context) which range to summarize:
since the last tag (`git describe --tags --abbrev=0`), since a given commit,
or the current branch vs. its base.

## Step 2 — Read the commits

Run `git log <range> --oneline` and, for anything ambiguous, `git show <sha>
--stat` to understand what actually changed — never guess from the commit
subject line alone if it's vague (e.g. "fix stuff").

## Step 3 — Draft the entry

Group into:

```
### Added
- ...

### Changed
- ...

### Fixed
- ...
```

Omit any section with nothing in it. Write each bullet from the *user's*
perspective (what changed for them), not the implementation detail — unless
this is an internal/dev-tools changelog, in which case implementation detail
is fine.

## Step 4 — Confirm before writing

Show the drafted entry to the user. Only append it to `CHANGELOG.md` (top of
file, under the existing `## [Unreleased]` heading if present, otherwise
create one) once they confirm.

## Never do

- Never invent a version number — that's the user's call at release time.
- Never merge unrelated commits into one bullet just to shorten the list.
