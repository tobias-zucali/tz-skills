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
- [3, plan-step 3: Audit packaging layer] Checked `.claude-plugin/plugin.json`, `marketplace.json`, README. Structural separation already reasonable: packaging config lives in its own `.claude-plugin/` directory, named after the Claude Code convention, and SKILL.md bodies don't reference "Claude Code" by name. Gap found: README never states that SKILL.md files are usable independent of the `.claude-plugin/` wrapper — reads as if the whole repo requires Claude Code.
- [3, plan-step 3] FRICTION: the original plan paired audits (steps 1-2) with a single fix step (step 5) sized for *those two* steps' finding type (tool-reference rewrites). Step 3 produced a different finding type (a documentation gap) with no allocated fix step. Amended the plan on the fly to fold this into step 6 rather than adding a new step, since both are "add portability documentation" work — but this is a real planning gap: the upfront plan assumed audit findings would all be fixable the same way, and they weren't.
- [3, plan-step 4: AGENTS.md vs CLAUDE.md] Decided AGENTS.md over CLAUDE.md, since the audit's stated goal is cross-agent compatibility and AGENTS.md is the convention other agents recognize. Created a minimal root `AGENTS.md` pointing to README's "Adding a new skill" and `docs/SKILL_DESIGN.md`, noting `.claude-plugin/` as the only Claude-Code-specific part of the repo. Made this call directly rather than asking, since it follows deterministically from the constraint the user already stated at the start of this run.
- [note, step 4 addendum] User asked whether a symlinked CLAUDE.md -> AGENTS.md would make sense, to guarantee Claude Code picks up the instructions even if it only looks for CLAUDE.md. Flagged a real risk: raw-content fetchers (e.g. raw.githubusercontent.com) don't resolve symlinks, so a symlinked CLAUDE.md would serve the literal string "AGENTS.md" instead of real content to any tool that fetches it that way — undermining the exact use case. Recommended a real one-line pointer file instead; user agreed. Created `CLAUDE.md` with a one-line pointer to AGENTS.md.
- [3, plan-step 5: Apply fixes] Rewrote guide-me lines 42/46/62/93: each now names the action generically ("ask the user directly", "the agent's own task-tracking tool") and lists the Claude Code tool as the preferred path when the running agent has one, rather than the sole mechanism. skill-debug needed no changes (step 1 found it already agent-neutral).
- [3, plan-step 6: Add portability guidance] Added a "Cross-agent portability" section to docs/SKILL_DESIGN.md codifying the generic-action-with-preferred-tool pattern applied in step 5, plus the frontmatter/description rules already confirmed clean in step 2. Added a README note (folded in from step 3's finding) stating SKILL.md files work independent of the `.claude-plugin/` install flow.
- [note, step 6 addendum] User asked what's needed for ChatGPT compatibility specifically. Researched via WebSearch/WebFetch (openai.com and agentskills.io themselves were egress-blocked; used third-party coverage and OpenAI Help Center/Learn pages instead): SKILL.md is now an open standard (agentskills.io, opened by Anthropic late 2025) already adopted by ChatGPT, OpenAI Codex CLI, Cursor, GitHub Copilot — same frontmatter/body format this repo already uses, so no content changes were needed beyond step 5's fixes. Added a "Using this repo with other agents" section to README with ChatGPT's upload-based install and Codex CLI's `.agents/skills/` folder convention.
- [3, plan-step 7: Re-verify] Re-read guide-me/SKILL.md in full post-edit. No Claude-only tool names remain as a sole mechanism; no "Claude Code" branding anywhere; still no Definition of done section (intentional, per design). Reviewing the whole run's transcript against guide-me's own stated process for the comparison below surfaced one gap not caught in earlier steps.
- [3, plan-step 7] FRICTION: guide-me's step 2 says to "mirror [the plan] into the agent's own task-tracking tool... for live tracking," and step 3.2 says to "update GUIDE_ME.md and the in-session task list" after every step. Across all 7 steps of this run, only GUIDE_ME.md was ever updated — the in-session task list (TaskCreate/TaskUpdate, available this session) was never touched, despite the harness surfacing reminders about it at multiple points during the run. This went unnoticed until this re-verification pass, because nothing in the skill's own process checks for it.

## Comparison

Mode: **a (fallback)** — guide-me has no `## Definition of done` section. Comparison is judgment-based against its stated purpose and process; that absence is itself a finding (see Analysis).

| Stated behavior (guide-me prose) | Outcome this run |
| --- | --- |
| Step 0: detect existing guide before doing anything else | Met — checked, none found, proceeded correctly. |
| Step 1: gather input, ask only if genuinely vague | Met — goal was concrete, no unnecessary question asked. |
| Step 2: real planning pass, show finalized plan before executing | Met — 7-step plan grouped by verifiable outcome, shown and confirmed before any execution. |
| Step 2/3.2: mirror plan into GUIDE_ME.md *and* the in-session task list | **Partially met** — GUIDE_ME.md updated every step; in-session task list never touched. |
| Step 3.1/3.4: do one step's work only, stop and wait for explicit confirmation | Met — held across all 7 steps and every addendum; correctly did not treat an ambiguous "Hi" as confirmation to proceed. |
| Step 3.5: ask when hitting a decision only the user can make | **Ambiguous** — held for genuinely open questions (symlink vs. pointer file, plan changes), but the AGENTS.md-vs-CLAUDE.md call in step 4 was decided directly rather than asked, on the reasoning that it followed deterministically from a constraint the user had already stated. Outcome was fine (user didn't object), but the skill gives no test for telling a "downstream-determined" call apart from a genuinely open one. |
| Step 4: keep GUIDE_ME.md as durable, resumable state | Met — format matches the suggested template closely. |
| Step 5: finishing — mark complete, summarize, ask about the file | In progress as of this entry — see below. |

## Analysis

**How well the goal was reached:** The underlying audit goal — improving this repo's cross-agent portability — was fully achieved: four concrete, shipped changes (agent-neutral tool references in guide-me, `AGENTS.md`/`CLAUDE.md`, a portability section in `docs/SKILL_DESIGN.md`, and README guidance for ChatGPT/Codex CLI). guide-me's own process discipline held up well on everything a human directly observes — the plan, the stop-and-wait cadence, GUIDE_ME.md itself — but failed silently on the one part nobody would notice without a debug log: task-list mirroring never happened, for 7 steps straight.

**What went wrong, grouped by root cause:**

1. **Task-list mirroring gap.** guide-me phrases it as a soft parallel action ("and mirror it into... the in-session task list") rather than a separately-checkable requirement, and nothing later in the skill verifies it happened. Nothing forced it to be noticed until this explicit re-verification pass.
2. **Plan/fix-step mismatch (already logged mid-run).** The 7-step plan paired two different finding types — tool-reference rewrites and a documentation gap — with a single fix step (step 5) sized for only one of them, forcing an on-the-fly amendment at step 3. guide-me's planning guidance says nothing about keeping each audit step's fix self-contained versus deliberately deferring it.
3. **No test for "ask vs. decide."** Step 3.5 says to ask when a decision is "only the user's to make," but gives no way to tell a decision that's downstream-determined by something the user already stated (this run's AGENTS.md-vs-CLAUDE.md call) from a genuinely open one. This run got lucky; the rule as written doesn't guarantee it.

**Concrete suggestions for guide-me's SKILL.md:**

1. Add a `## Definition of done` section, including an item like "the in-session task list reflects the current step list and state" — this makes the mirroring requirement checkable instead of a narrated aside, and closes the mode-a gap this run's comparison had to fall back on.
2. In step 3.2, split "update GUIDE_ME.md and the in-session task list" into two explicit sub-items rather than one "and"-joined sentence — the soft phrasing is exactly what let this run skip half of it, every step, without tripping anything.
3. In step 2's planning guidance, add a line that each audit-style step's own fix should stay in that step by default, and pooling fixes into a shared later step needs an explicit note saying why (this run's step 3 finding folded into step 6 is a reasonable example of when that's justified).
4. Give step 3.5 a one-line test for the ask/decide boundary, e.g.: "if the decision follows deterministically from something the user already told you, decide and state your reasoning; otherwise ask." Currently the rule just says "ask," with no guidance for calls like this run's step 4.

## Post-run: fixes applied

User asked to act on the four suggestions above. All four applied to guide-me/SKILL.md:

1. Added a `## Definition of done` section (5 checkable items, including the task-list-mirroring item this run's own gap surfaced).
2. Split step 3.2's "update GUIDE_ME.md and the in-session task list" into two explicit actions, with a one-line note on why it's easy to silently skip.
3. Added a planning-pass bullet (step 2) on keeping each step's fix self-contained by default, pooling only with a stated reason.
4. Added the ask/decide test to step 3.5 specifically (not step 2 — first attempt put it in the wrong section, since the triggering decision in this run happened during execution, not planning; caught and corrected before committing).

guide-me now has what it was missing at the start of this run: with a Definition of done in place, a future `skill-debug` run against it would use mode b, not fall back to mode a.
