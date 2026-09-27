# Agent instructions for tz-skills

This repo is a collection of skills (`skills/<category>/<name>/SKILL.md`),
packaged as a Claude Code plugin. The `.claude-plugin/` directory is the only
part of this repo allowed to assume Claude Code specifically — the skill
content itself (each `SKILL.md`) is meant to be usable by any AI agent that
reads this format, independent of that packaging.

- To add or change a skill, follow "Adding a new skill" in `README.md`.
- Before writing or editing any `SKILL.md`, read `docs/SKILL_DESIGN.md` —
  frontmatter conventions, the Definition of done section, and the
  cross-agent portability rule.
- There is no build step, package manifest, or test suite beyond the skills
  themselves — this is a markdown-only repo. To validate a skill, run
  `skills/meta/skill-debug` against it rather than looking for a test
  command.
- Keep `SKILL.md` bodies agent-neutral: don't name a specific tool by its
  exact Claude Code name as the only way to do something. Describe the
  action generically, and note the matching tool as the preferred path when
  the running agent has one.
