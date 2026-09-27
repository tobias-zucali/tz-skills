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

- [x] Step 2 — Audited frontmatter and trigger descriptions. Both skills:
      minimal name/description fields, natural-language triggers listed
      before the supplementary `/slash-command`, `name` matches directory
      slug. No fixes needed — clean.

- [x] Step 3 — Audited the packaging layer. Structural separation is already
      reasonable (`.claude-plugin/` isolates Claude-Code-specific manifests;
      SKILL.md bodies stay unbranded per step 1). Gap: README never states
      SKILL.md files are usable independent of the `.claude-plugin/` wrapper.
      Plan amended: folded this fix into step 6 rather than adding a new step
      (see Notes for why).

- [x] Step 4 — Decided `AGENTS.md` over `CLAUDE.md` (cross-agent goal makes
      the choice deterministic) and created a minimal root `AGENTS.md`
      pointing to README + `docs/SKILL_DESIGN.md`. Addendum: added a
      one-line `CLAUDE.md` pointer to AGENTS.md (not a symlink — raw-content
      fetchers don't resolve symlinks, which would defeat the purpose).
- [x] Step 5 — Rewrote guide-me lines 42/46/62/93 to name the action
      generically with the Claude Code tool as the preferred (not sole)
      path. skill-debug needed no changes.
- [x] Step 6 — Added "Cross-agent portability" section to
      `docs/SKILL_DESIGN.md` (generic-action-with-preferred-tool pattern,
      frontmatter/description rules) and a README note that SKILL.md files
      work independent of the `.claude-plugin/` install flow.

## In progress
_(none — awaiting confirmation to start step 7)_

## Open
- [ ] Step 7 — Re-verify both SKILL.md files after edits and record final
      findings.

## Notes
- This run is being debugged live via `skills/meta/skill-debug` (run by hand,
  not through the Skill tool — see `SKILL_DEBUG_guide-me.md`).
- Comparison mode is (a), fallback: guide-me has no Definition of done
  section. That absence is itself logged as a finding.
- User guidance for step 5: fixes should phrase actions generically (e.g.
  "ask the user directly") while still recommending a matching tool (e.g. a
  structured-choice tool) when the running agent has one — not strip
  Claude-specific tool usage outright.
- Plan gap found during step 3 (logged as friction in the debug log): the
  upfront plan sized step 5 as the one fix step for steps 1-2's finding type
  and didn't allocate for step 3's different finding type (a documentation
  gap, not a tool-reference rewrite). Folded into step 6 rather than adding
  a step.
