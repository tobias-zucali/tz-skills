# tz-skills

Personal Claude Code skills, packaged as a plugin so they can be installed and
updated across machines instead of copy-pasted into `~/.claude/skills`.

## Skills

- **productivity/guide-me** — step-by-step guided walkthrough of a task list,
  setup process, or multi-part goal. Tracks progress in `GUIDE_ME.md` and pauses
  for confirmation after each step.
- **meta/skill-debug** — wraps another skill's execution, logging its process
  and any friction live to `SKILL_DEBUG_<skill-name>.md`, then compares the
  outcome against that skill's own Definition of done (falling back to
  prose-based judgment, explicitly flagged, if it has none) and suggests
  concrete improvements.

See `docs/SKILL_DESIGN.md` for how to write a skill in this repo, including
the Definition of done convention that `skill-debug` relies on.

## Using this repo

```bash
claude plugin marketplace add https://github.com/tobias-zucali/tz-skills
claude plugin install tz-skills
```

To pick up changes later: `claude plugin update tz-skills`.

## Adding a new skill

1. Create `skills/<category>/<name>/SKILL.md`.
2. Add `"./skills/<category>/<name>"` to `.claude-plugin/plugin.json`'s `skills` array.
3. Bump `version` in `plugin.json`.
4. Commit and push (and run `claude plugin update tz-skills` locally to pick it up).
