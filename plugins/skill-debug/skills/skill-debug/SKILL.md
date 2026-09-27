---
name: skill-debug
description: Wrap another skill's execution to trace the process it goes through, log friction as it happens, and at the end compare the outcome against that skill's own definition of success before suggesting improvements. Use when the user asks to debug, trace, instrument, or evaluate a skill (e.g. "debug guide-me", "trace how the X skill goes", "evaluate skill Y"), or invokes /skill-debug <skill-name>.
---

Run a target skill exactly as it would normally run, while also keeping a live,
durable trace of its process, and finish by judging how well it met its own
definition of success. You are running two sets of instructions in the same
session: the target skill's own process, plus this logging and analysis
discipline layered on top of it. Never let the logging change what the target
skill actually does — it only observes and records.

## 0. Identify the target skill and its definition

Determine which skill to debug from the user's request. If it's ambiguous
which skill they mean, ask — this is a genuine decision, not something to
guess.

Locate that skill's `SKILL.md` (search likely locations: this repo's
`skills/*/*/`, a project's `.claude/skills/`, installed plugin skill
directories, `~/.claude/skills/`) and read it in full. This is the skill's
*definition*: its stated purpose, its process, and — if present — an explicit
`## Definition of done` section (see `docs/SKILL_DESIGN.md` for the
convention).

Fix the comparison mode now and record it in the log header:

- **Mode b** — the target has an explicit `## Definition of done` (or
  equivalently named) checklist: the end-of-run comparison will go through it
  item by item.
- **Mode a (fallback)** — no such section exists: the comparison will be
  judgment-based against the skill's prose, and the final analysis must say so
  explicitly as its own finding — a missing Definition of done is itself an
  improvement the target skill could use.

Also note the target skill's own natural checkpoints (its defined steps or
phases — e.g. guide-me's numbered sections and its per-step loop). These set
the granularity for the trace. If the target has no clear internal steps,
checkpoint on: start, each tool call, each user interaction, and completion.

## 1. Start the log

Create `SKILL_DEBUG_<skill-name>.md` in the current working directory,
alongside whatever artifact the target skill itself produces (e.g. next to
`GUIDE_ME.md` when debugging guide-me). Write a header: target skill name, its
`SKILL.md` path, start timestamp, and the comparison mode fixed in step 0.

## 2. Run the target skill, logging live

Follow the target skill's own instructions to actually do its job. At each
checkpoint identified in step 0, append a short entry to the log
**immediately** — do not batch entries to write at the end. A long run's
early context can be compacted before you reach the end, so the file is the
durable record; memory alone is not.

Entry format:

```
- [<step/phase>] <what happened, one line>
```

Flag friction inline, in the same trace, as it happens:

```
- [<step/phase>] FRICTION: <what went wrong or was ambiguous — an instruction
  was unclear, you had to guess at intent, a tool failed and you retried, the
  user had to correct course, an unplanned clarifying question was needed>
```

Keep entries short — this is a trace, not a transcript. Log real friction
only; do not manufacture entries to pad the log.

## 3. Early analysis on request

If the user asks for the analysis before the target skill reaches its own
completion condition, stop the target skill's work where it stands, jump to
step 4 using the trace collected so far, then ask whether to resume the
target skill afterward.

## 4. Compare against the definition

Once the target skill's own completion condition is met (or analysis was
requested early), append a `## Comparison` section to the log:

- **Mode b**: go through the Definition of done criteria one by one; mark
  each met / not met / partially met, with a one-line reason citing what's in
  the trace.
- **Mode a**: judge against the skill's stated purpose and process from its
  prose, and write explicitly: "No Definition of done section found in
  `<skill-name>`; this comparison is prose-based judgment, not a mechanical
  check." Carry this into step 5 as an improvement suggestion too.

## 5. Analyze and suggest improvements

Append a `## Analysis` section to the log, concisely covering:

- How well the goal was reached, tied back to the comparison.
- What went wrong, grouped by root cause where multiple friction entries
  trace back to one source (e.g. three frictions all caused by one ambiguous
  instruction).
- Concrete, specific suggestions for improving the target skill's `SKILL.md`
  — phrased as edits someone could actually make ("add X to step 2",
  "clarify Y", "add a Definition of done section"), not vague praise or
  criticism.

Report a short summary to the user — not the full log — and point them to the
log file for detail.

## Definition of done

- [ ] `SKILL_DEBUG_<skill-name>.md` exists in the working directory with a
      header naming the target skill, its `SKILL.md` path, and the comparison
      mode.
- [ ] The log contains at least one trace entry per checkpoint the target
      skill actually passed through, written incrementally (not reconstructed
      only at the end).
- [ ] Every friction that occurred during the run is logged as a `FRICTION:`
      entry at the point it happened.
- [ ] A `## Comparison` section exists, using mode b against an explicit
      Definition of done when the target has one, otherwise mode a with the
      missing-section note stated explicitly.
- [ ] A `## Analysis` section exists with concrete, actionable improvement
      suggestions — not generic praise or criticism.
- [ ] The user received a short summary, not the full log inline.
