---
name: open-pr
description: >-
  Drafts a clear, well-structured pull request description from the current
  branch's commits and diff, then opens the PR via the GitHub CLI. Invoke when
  the user says "open a PR", "create a pull request", "ship this branch", or
  similar.
---

# Open PR

Help the user open a pull request for their current branch with a good
description, without them having to write it by hand.

## Step 1 — Gather context

1. Confirm the current branch is not `main`/`master`. If it is, tell the user
   they need to be on a feature branch first and stop.
2. Run `git log main..HEAD --oneline` (or the repo's actual default branch) to
   see the commits on this branch.
3. Run `git diff main...HEAD --stat` to see which files changed.

## Step 2 — Draft the description

Write a PR description with:

- A one-line summary as the title.
- A short "What changed" section (2-5 bullets, plain language, no commit-hash
  soup).
- A "How to test" section only if the change is user-facing or behavioral.

Show the draft to the user before opening anything — let them edit it.

## Step 3 — Open it

Once approved, run:

```bash
gh pr create --title "<title>" --body "<body>" --base main
```

Report the PR URL `gh` prints back to the user.

## Never do

- Never push commits the user hasn't reviewed.
- Never open a PR against a branch other than the one the user confirmed.
- Never fabricate "How to test" steps for changes you didn't actually verify.
