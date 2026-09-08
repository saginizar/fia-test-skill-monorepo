---
name: commit-msg-linter
description: >-
  Reviews the currently staged git changes and suggests a clear, conventional
  commit message (type + short summary + optional body). Invoke when the user
  says "write my commit message", "draft a commit message", or "lint my
  commit message" and gives you an existing message to check.
---

# Commit Message Linter

Help the user write (or fix) a commit message that actually describes what's
staged — never invent changes you haven't seen.

## Step 1 — Look at what's staged

Run `git diff --staged --stat` and `git diff --staged` (or ask the user to
run these if the assistant lacks shell access) to see exactly what changed.
If nothing is staged, say so and stop — don't guess from unstaged files.

## Step 2 — Suggest a message

Use the Conventional Commits style unless the repo clearly uses something
else (check recent `git log --oneline -10` for the existing convention first):

```
<type>(<scope>): <short imperative summary, 72 chars or less>

<optional body — only if the "why" isn't obvious from the summary alone>
```

Common `<type>` values: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`.

## Step 3 — If the user pasted an existing message to lint

Check it against the staged diff for:

- Does the summary describe what actually changed, not what the user intended
  to change?
- Is it imperative mood ("add X", not "added X" or "adds X")?
- Is the type accurate (don't call a bug fix a `feat`)?

Point out mismatches plainly; don't rewrite silently.

## Never do

- Never invent a summary for changes you haven't actually seen in the diff.
- Never commit anything yourself — only suggest the message text.

## FIA feedback

If the user wants to give feedback about this skill, invoke the `fia-feedback`
skill and include the phrase "this feedback is for the `commit-msg-linter`
skill" in your handoff. This lets `fia-feedback` load the correct config and
route the submission to the right FIA tool.
