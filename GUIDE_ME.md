# Guide: Cross-agent portability audit for tz-skills

Started: 2026-09-27

Goal: audit this repo's skills and structure against a best-practices
checklist, and improve them, while keeping `guide-me` and `skill-debug` (and
the repo generally) usable by any AI agent that supports the plugin/skill
format — not coupled to Claude-Code-only mechanisms.

## Done
- [x] Step 1 — Audited both SKILL.md instruction bodies. Findings: guide-me
      names `AskUserQuestion` (lines 42, 62) and `TodoWrite/Tasks` (line 46)
      directly, and assumes `/guide-me` slash-command syntax (line 93);
      skill-debug has no Claude-Code-only tool names in its body.

## In progress
_(none — awaiting confirmation to start step 2)_

## Open
- [ ] Step 2 — Audit SKILL.md frontmatter and trigger descriptions for
      portability: minimal universal fields, natural-language triggers that
      don't depend solely on a `/slash-command`.
- [ ] Step 3 — Audit the packaging layer (`.claude-plugin/plugin.json`,
      `marketplace.json`, README install instructions) for clear separation
      between Claude-Code-specific packaging and agent-neutral skill content.
- [ ] Step 4 — Decide whether the repo needs a root agent-instructions file,
      and if so whether `AGENTS.md` (cross-agent convention) fits better than
      `CLAUDE.md` (Claude-specific) for this repo.
- [ ] Step 5 — Apply the fixes found in steps 1–2 to guide-me and skill-debug.
- [ ] Step 6 — Add a cross-agent portability guideline to
      `docs/SKILL_DESIGN.md` so future skills follow the same rule.
- [ ] Step 7 — Re-verify both SKILL.md files after edits and record final
      findings.

## Notes
- This run is being debugged live via `skills/meta/skill-debug` (run by hand,
  not through the Skill tool — see `SKILL_DEBUG_guide-me.md`).
- Comparison mode is (a), fallback: guide-me has no Definition of done
  section. That absence is itself logged as a finding.
