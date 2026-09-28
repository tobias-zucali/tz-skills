---
name: skill-debug
description: Wrap another skill's execution to trace the process it goes through, log friction as it happens, and at the end compare the outcome against that skill's own definition of success before suggesting improvements. Use when the user asks to debug, trace, instrument, or evaluate a skill (e.g. "debug guide-me", "trace how the X skill goes", "evaluate skill Y"), or invokes /skill-debug SKILL_NAME.
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

Use `SKILL_DEBUG_<skill-name>.md` in the current working directory, alongside
the target skill's artifact (e.g. `GUIDE_ME.md`). Create it if absent;
otherwise append a run without altering earlier content. Begin each run with
`## Run — <start timestamp>`, followed by the target name, `SKILL.md` path,
and comparison mode. Following content belongs to that run until the next
`## Run` heading.

## 2. Run the target skill, logging live

Follow the target skill's own instructions to actually do its job. At each
checkpoint identified in step 0, append a short entry to the log
**immediately** — do not batch entries to write at the end. A long run's
early context can be compacted before you reach the end, so the file is the
durable record; memory alone is not.

Log observable actions, decisions, and results — not hidden reasoning. For
loaded content, note its source, purpose, relevant scope, and any readily
available version; do not seek a version solely for the log. Summarize rather
than copy, and redact sensitive data.

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

Keep entries short — this is a trace, not a transcript. Consecutive successful
actions of the same kind may share one entry unless a distinct decision or
friction occurred. Never group failures, related retries, or user
interactions. Log real friction only; do not manufacture it.

## 3. Early analysis on request

If the user asks for the analysis before the target skill reaches its own
completion condition, stop the target skill's work where it stands, jump to
step 4 using the trace collected so far, then ask whether to resume the
target skill afterward.

For an unfinished run, append `Status: incomplete` with its stopping point and
compare only against evidence recorded so far.

## 4. Compare against the definition

Once the target skill's own completion condition is met (or analysis was
requested early), append a `### Comparison` section to the current run:

- **Mode b**: go through the Definition of done criteria one by one; mark
  each met / not met / partially met, with a one-line reason citing what's in
  the trace.
- **Mode a**: judge against the skill's stated purpose and process from its
  prose, and write explicitly: "No Definition of done section found in
  `<skill-name>`; this comparison is prose-based judgment, not a mechanical
  check." Carry this into step 5 as an improvement suggestion too.

## 5. Analyze and suggest improvements

Append a `### Analysis` section to the current run, concisely covering:

- How well the goal was reached, tied back to the comparison.
- What went wrong, grouped by root cause where multiple friction entries
  trace back to one source (e.g. three frictions all caused by one ambiguous
  instruction).
- Concrete, specific suggestions for improving the target skill's `SKILL.md`
  — phrased as edits someone could actually make ("add X to step 2",
  "clarify Y", "add a Definition of done section"), not vague praise or
  criticism.

Distinguish instruction flaws from environment or test-case failures. The
analysis may use all runs to identify recurring friction, regressions, or
improvements, but label cross-run evidence clearly. The comparison remains
scoped to the current run and its target definition.

Report a short summary to the user — not the full log — and point them to the
log file for detail.

## Definition of done

- [ ] `SKILL_DEBUG_<skill-name>.md` contains a distinct current-run section
      with start timestamp, target name and path, and comparison mode; earlier
      runs remain unchanged.
- [ ] The current run contains at least one trace entry per checkpoint the
      target skill actually passed through, written incrementally (not
      reconstructed only at the end).
- [ ] Every friction that occurred during the run is logged as a `FRICTION:`
      entry at the point it happened.
- [ ] The current run has a `### Comparison` section, using mode b against an
      explicit Definition of done when the target has one, otherwise mode a
      with the missing-section note stated explicitly.
- [ ] The current run has a `### Analysis` section with concrete, actionable
      improvements, and clearly labels any evidence from earlier runs.
- [ ] A run that stopped before target completion is marked incomplete with
      its stopping point recorded.
- [ ] The user received a short summary, not the full log inline.
