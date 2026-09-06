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
├── open-pr/SKILL.md            # drafts + opens a PR via gh
├── changelog-writer/SKILL.md   # drafts a CHANGELOG entry from git history
├── standup-notes/SKILL.md      # drafts a daily standup update
└── skills.sh                   # syncs a skill out to a target repo
```

None of these three Skills are FIA-related — they're realistic, independent
dev-tooling Skills, exactly what a real skills monorepo would actually
contain. FIA gets installed for **one specific skill** inside this repo, the
same way it would for a real team's monorepo.

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

**Use the `open-pr` skill folder for this test.** When the FIA install guide
asks "What is the folder name of the skill you are installing FIA for?",
answer `open-pr`. That makes this repo exercise every Monorepo-mode branch in
the guide:

- `open-pr/fia.config.json` (skill-scoped public config, travels with the
  skill via `skills.sh`)
- `fia-feedback/SKILL.md` at the repo root (synced out separately — never
  placed under `.cursor/skills/` in this repo)
- `open-pr/fia.owner.local.json` (skill-scoped owner secret, gitignored)
- the shared owner nudge hook + `fia-inbox`/`fia-review` at the repo root,
  which discover `open-pr/` automatically
- the `## FIA feedback` handoff block appended to `open-pr/SKILL.md` (Step 2a)

The other two skills (`changelog-writer`, `standup-notes`) exist purely to
make the monorepo detection realistic — more than one sibling `SKILL.md`
folder, so Step 0 can't mistake this for a single-skill repo. FIA should
never touch them.
