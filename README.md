# fia-test-skill-monorepo

A dummy **monorepo-of-skills** repo, used to test the FIA Skill install
flow's **[Monorepo] mode** — the layout where multiple independent Skills
live as sibling top-level folders in one repo (each its own
`<skill-name>/SKILL.md`) and get distributed out to individual project repos
via `skills.sh`, rather than the repo itself being one single Skill.

This mirrors real skills monorepos (e.g. a team's internal
`agent-skills`/`tdocs` repo) closely enough that FIA's own install guide
should detect **Monorepo mode** at Step 0 without any special-casing.

## Layout

```
fia-test-skill-monorepo/
├── open-pr/SKILL.md              # drafts + opens a PR via gh
├── changelog-writer/SKILL.md     # drafts a CHANGELOG entry from git history
├── standup-notes/SKILL.md        # drafts a daily standup update
├── commit-msg-linter/SKILL.md    # lints/suggests a commit message from staged diff
└── skills.sh                     # syncs a skill out to a target repo
```

None of these Skills are FIA-related — they're realistic, independent
dev-tooling Skills, exactly what a real skills monorepo would actually
contain. FIA gets installed **per skill** inside this repo, the same way it
would for a real team's monorepo — one skill at a time, as the team adds new
skills over time.

## Distributing a skill (`skills.sh`)

```bash
./skills.sh list
./skills.sh sync open-pr /path/to/some-project-repo
./skills.sh sync open-pr /path/to/some-project-repo --claude   # also write .claude/skills/
./skills.sh sync-all /path/to/some-project-repo
```

This copies `<skill-name>/SKILL.md` into the target repo's
`.cursor/skills/<skill-name>/SKILL.md` (and, with `--claude`,
`.claude/skills/<skill-name>/SKILL.md` too) — this is the real mechanism a
team would use to pull a skill from this monorepo into their own project.

## Register this tool on FIA

System type: **AI Agent Skill**
Skill Repo URL: `git@github.com:saginizar/fia-test-skill-monorepo.git`

FIA has already been installed here for `open-pr`, `changelog-writer`, and
`standup-notes` (register a new FIA tool per skill, one at a time, exactly
as a real team would when it adds FIA to another skill later). Each install
exercises every Monorepo-mode branch in the guide:

- `<skill-name>/fia.config.json` (skill-scoped public config, travels with
  the skill via `skills.sh`)
- `fia-feedback/SKILL.md` at the repo root (synced out separately — never
  placed under `.cursor/skills/` in this repo), shared across all skills
- `<skill-name>/fia.owner.local.json` (skill-scoped owner secret, gitignored)
- the shared owner nudge hook + `fia-inbox`/`fia-review` at the repo root,
  which discover every FIA-configured skill folder automatically
- the `## FIA feedback` handoff block appended to `<skill-name>/SKILL.md`

**`commit-msg-linter` has no FIA config yet** — it's the next skill to
register, to test the "adding FIA to one more skill in an already-FIA-ed
monorepo" flow (shared infra reused untouched, only the new skill's files
created).
