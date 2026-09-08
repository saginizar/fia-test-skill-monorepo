---
name: release-checklist
description: >-
  Generates a pre-release checklist from what actually changed since the
  last tag (migrations, env vars, breaking API changes, docs to update).
  Invoke when the user says "prep a release", "what do I need to check
  before shipping", or "generate a release checklist".
---

# Release Checklist

Build a short, specific pre-release checklist from real changes — never a
generic boilerplate list unrelated to what's actually in this release.

## Step 1 — Find the range

Ask the user which range to check, if not already clear: since the last tag
(`git describe --tags --abbrev=0`), since a given commit, or main vs. a
release branch.

## Step 2 — Scan for risk signals

Run `git diff <range> --stat` and look for files that typically need a
manual step alongside the code change:

- Migration files (`migrations/`, `*.sql`, `schema.rb`, etc.) → note "run
  migrations before/after deploy"
- Env/config files (`.env.example`, `*.config.*`) → note "check for new
  required env vars"
- Public API/route files → note "check for breaking changes, update API
  docs if needed"
- Dependency manifests (`package.json`, `requirements.txt`, etc.) → note
  "review dependency changes"

Only include a checklist item if you actually found a matching file in the
diff — never pad the list with generic items that don't apply this time.

## Step 3 — Present the checklist

Show the drafted checklist to the user before they act on any of it. Format:

```
## Release checklist — <range>

- [ ] <specific item tied to an actual changed file>
- [ ] ...
```

## Never do

- Never claim a risk signal exists (e.g. "check env vars") unless you found
  the actual file that triggered it — link the specific file in the item.
- Never run the release yourself — this Skill only drafts the checklist.

## FIA feedback

If the user wants to give feedback about this skill, invoke the `fia-feedback`
skill and include the phrase "this feedback is for the `release-checklist`
skill" in your handoff. This lets `fia-feedback` load the correct config and
route the submission to the right FIA tool.
