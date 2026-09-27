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
├── release-checklist/SKILL.md    # drafts a pre-release checklist from real diff risk signals
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

FIA is not currently installed for any skill in this repo (freshly reset —
register a new FIA tool per skill, one at a time, exactly as a real team
would when it adds FIA to a skill for the first time). Each install
exercises every Monorepo-mode branch in the guide:

- `<skill-name>/fia.config.json` (skill-scoped public config, travels with
  the skill via `skills.sh`)
- `fia-feedback/SKILL.md` at the repo root (synced out separately — never
  placed under `.cursor/skills/` in this repo), shared across all skills
- `<skill-name>/fia.owner.local.json` (skill-scoped owner secret, gitignored)
- the shared owner nudge hook + `fia-inbox`/`fia-review` at the repo root,
  which discover every FIA-configured skill folder automatically
- the `## FIA feedback` handoff block appended to `<skill-name>/SKILL.md`

The first skill installed in a round creates all the shared root infra
(`fia-feedback/SKILL.md`, `Intelligent-Feedback-Agent-FIA/`, `.cursor/`,
`.claude/`); every skill installed after that in the same round should reuse
it untouched and only add its own `<skill-name>/fia.config.json` +
`fia.owner.local.json` + SKILL.md handoff block.
