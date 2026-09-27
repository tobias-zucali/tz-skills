---
name: guide-me
description: Step-by-step guided walkthrough of a task list, setup process, or multi-part goal. Breaks work into reportable steps, tracks done/open state in GUIDE_ME.md, and pauses for confirmation after each step. Use when the user wants to be walked/guided through something, asks to go step by step, or invokes /guide-me.
---

Guide the user through a task (a TODO list, a setup process, a migration, anything
multi-part) one step at a time, at a pace they control. You are the guide, not an
autopilot: never rush ahead of what the user has confirmed.

## 0. Detect an existing guide

Before anything else, check for `GUIDE_ME.md` in the current working directory.

- **If it exists**: read it. Summarize the current state (done / in progress / open)
  back to the user and ask whether to resume this guide, append new tasks to it, or
  start a fresh one (which replaces it — confirm before overwriting).
- **If the user's prompt includes new tasks while a `GUIDE_ME.md` already exists**:
  default to appending the new tasks to the open list rather than replacing it,
  unless they say otherwise.
- **If none exists**: proceed to step 1.

## 1. Gather the input

Figure out what you're guiding the user through. Accept whatever they gave you:

- a pasted list or description in the prompt,
- a reference to a file (TODO.md, an issue, notes) — read it,
- just a goal ("set up this repo", "migrate X to Y") with no explicit list yet.

If the input is missing or too vague to break into steps, ask for it directly rather
than guessing.

## 2. Upfront planning pass

Before starting step 1, turn the raw input into an ordered list of steps and confirm
it with the user. This is a real planning pass, not a rubber stamp:

- Group work by **verifiable outcome** — a step is one unit of work that ends in
  something checkable (a command ran, a file exists, a question got answered), not a
  fixed count of sub-tasks or a time box. Don't over-split into tiny steps; don't
  bundle unrelated outcomes into one step either.
- Where the ordering, scope, or intent is ambiguous, ask the user directly to resolve
  it before finalizing the plan — use a structured-choice tool (e.g. `AskUserQuestion`)
  if the agent has one, otherwise ask in plain text. Don't guess silently on decisions
  that are the user's to make.
- Once the step list is settled, write it to `GUIDE_ME.md` (see format below), and
  also mirror it into the agent's own task-tracking tool (e.g. TodoWrite/Tasks) if it
  has one, for live tracking alongside it.
- Show the user the finalized step list before starting step 1.

## 3. Execute one step at a time

For each step, in order:

1. Do the work for that step only — do not start the next step's work.
2. Update `GUIDE_ME.md` and the in-session task list to reflect the result.
3. Report the concrete result of this step (what happened, what it produced, any
   problems hit) — concisely, no filler.
4. **Stop and wait.** Do not proceed to the next step until the user explicitly
   confirms (e.g. "next", "continue", "looks good") or gives feedback that changes
   the plan. This holds even under a general "keep going without asking" mode — the
   entire point of this skill is that the user sets the pace.
5. If, during a step, you hit a decision only the user can make (not a fact you can
   look up yourself), pause immediately and ask the user directly — with a
   structured-choice tool (e.g. `AskUserQuestion`) if the agent has one — rather than
   guessing and continuing.

If the user's feedback changes scope (adds, removes, or reorders tasks), update the
plan and `GUIDE_ME.md` accordingly before continuing.

## 4. Track state in GUIDE_ME.md

Keep `GUIDE_ME.md` in the current working directory as the durable source of truth,
updated after every step (not just at the end). Suggested format:

```markdown
# Guide: <short title>

Started: <date>

## Done
- [x] Step 1 — <short outcome summary>
- [x] Step 2 — <short outcome summary>

## In progress
- [ ] Step 3 — <what's happening>

## Open
- [ ] Step 4
- [ ] Step 5

## Notes
- <decisions made, things to remember, blockers resolved>
```

This file is what makes the guide resumable: if the session ends, a later invocation
of this skill in the same directory — a `/guide-me` slash command or whatever else
matches the trigger phrasing in this skill's description — should read it and pick up
exactly where things left off.

## 5. Finishing

When every step is done, mark `GUIDE_ME.md` as complete (all items checked, a closing
note), report a short summary of what was accomplished, and ask whether to remove the
file or leave it as a record.
