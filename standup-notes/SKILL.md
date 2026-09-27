---
name: standup-notes
description: >-
  Drafts a short daily standup update (yesterday / today / blockers) from the
  user's recent git activity. Invoke when the user says "write my standup",
  "what did I do yesterday", or "draft my daily update".
---

# Standup Notes

Draft a short, honest standup update from what the user's git history
actually shows — never pad it with generic filler.

## Step 1 — Look at recent activity

Run `git log --author="$(git config user.email)" --since=yesterday
--oneline` across the current repo. If the user works across multiple repos,
ask which ones to check rather than guessing.

## Step 2 — Draft the update

Format:

```
Yesterday: <1-3 short bullets from the commits found>
Today: <ask the user — this is forward-looking, never infer it from git>
Blockers: <ask the user — never infer this either>
```

If no commits were found for yesterday, say so plainly rather than inventing
activity.

## Step 3 — Confirm

Show the draft and let the user edit "Today" and "Blockers" before finishing.
Never post or send it anywhere automatically — this Skill only drafts text.

## Never do

- Never fabricate "Today" or "Blockers" content — always ask.
- Never include commits from other authors as if they were the user's own
  work.
