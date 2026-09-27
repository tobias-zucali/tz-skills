# Skill Debug Log: guide-me

Started: 2026-09-27
Target skill file: skills/productivity/guide-me/SKILL.md
Comparison mode: a (fallback) — no `## Definition of done` section found in guide-me's SKILL.md at start of this run.

## Trace

- [0: Detect existing guide] No `GUIDE_ME.md` found in cwd. Proceeding to step 1 per guide-me's own instructions.
- [1: Gather input] Input given directly by the user in one message: audit this repo's skills and structure against a best-practices checklist, with the explicit constraint that guide-me and skill-debug (and the repo generally) must stay usable by any AI agent that supports the plugin/skill format, not just Claude Code. Goal was concrete enough to plan from directly — no clarifying question needed.
- [2: Planning pass] Drafted a 7-step checklist, each step ending in a checkable outcome (a findings list, an edited file, a doc update, or a re-verification). Wrote it to `GUIDE_ME.md` and am presenting it to the user now for confirmation, per guide-me's requirement to show the finalized step list before starting step 1 of execution.
- [3, plan-step 1: Audit tool references] User confirmed the plan. Read both SKILL.md files in full and grepped for Claude-Code-only mechanism names. guide-me: `AskUserQuestion` (lines 42, 62) and `TodoWrite/Tasks` (line 46) named directly; `/guide-me invocation` (line 93) assumes slash-command syntax. skill-debug: no Claude-Code-only tool names found in the body — already agent-neutral.
- [3, plan-step 2: Audit frontmatter/triggers] Checked both frontmatters (name/description only, minimal and portable) and description wording. Both lead with natural-language triggers and list the `/slash-command` as supplementary, not sole. Both `name` values match their directory slugs. No fixes needed — clean pass.
- [note] User feedback ahead of step 5: platform neutrality matters, but fixes should phrase the *action* generically while still recommending a matching tool (e.g. a structured-choice tool) when the running agent provides one — not strip Claude-specific tool usage outright.
