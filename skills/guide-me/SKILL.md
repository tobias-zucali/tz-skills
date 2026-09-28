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
- Before finalizing the plan, scan the live environment for anything already
  running or configured that a step will depend on (a running server, a tunnel,
  an env var already set). That state can change what the "right" answer for a
  step even is — catch it up front instead of discovering it mid-step.
- A step often splits into a part the agent can do itself (a check, a lookup, a
  doc cross-reference) and a part only the user can do (an account action, a
  browser click). Note that split in the step description instead of treating
  every open item as pure "tell the user what to click."
- Phrase a step that verifies existing behavior against documentation as "do X,
  and fix any doc/behavior mismatch found" — not just "verify X." The check
  itself is rarely the valuable output; a live-test step's real job is usually
  to compare reality against what's documented and correct any gap it finds.
- Keep each step's own fix in that same step by default. Only pool a step's finding
  into a later, shared fix step when you can state why (e.g. two steps' findings need
  the same kind of edit) — write that reason into `GUIDE_ME.md`'s Notes when you do.
  A plan that defers fixes without saying why tends to break the moment one step's
  finding doesn't fit the shape the deferred step was sized for.
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

1. Do the work for that step only — do not start the next step's work. If the step
   hands the user a URL, target, or value to act on, verify it live first (it
   resolves, it matches what's documented) rather than reciting it unchecked from a
   checklist or doc — that verification is itself a place real mismatches surface.
2. Update `GUIDE_ME.md` to reflect the result. Separately, update the in-session task
   list too, if the agent has one — this is its own action, not a detail folded into
   the `GUIDE_ME.md` update; skipping it is easy to do silently and easy to miss.
3. Report the concrete result of this step (what happened, what it produced, any
   problems hit) — concisely, no filler.
4. **Stop and wait.** Do not proceed to the next step until the user explicitly
   confirms (e.g. "next", "continue", "looks good") or gives feedback that changes
   the plan. This holds even under a general "keep going without asking" mode — the
   entire point of this skill is that the user sets the pace.
   A confirmation such as "done", "erledigt", or "looks good" both closes the
   current step and normally authorizes starting the next open step in the agreed
   order. Do not ask for separate permission merely to proceed. Ask again when the
   next step requires distinct authorization because it is sensitive, destructive,
   externally consequential, or outside the previously agreed scope, or when the
   remaining plan must be revised.
5. If, during a step, you hit a decision only the user can make (not a fact you can
   look up yourself), pause immediately and ask the user directly — with a
   structured-choice tool (e.g. `AskUserQuestion`) if the agent has one — rather than
   guessing and continuing. A useful test: if the decision follows deterministically
   from something the user already told you, decide and state your reasoning instead
   of asking; if it doesn't follow from anything they've already said, ask.
6. If a step's own outcome shows that the remaining plan no longer holds — a later
   step turns out unnecessary, a new one is needed, the order no longer makes sense —
   stop before continuing. Propose the revised step list with your reasoning, and wait
   for the user to confirm before applying it; don't restructure silently just because
   you noticed something. This is separate from #5: #5 is a decision you can't make at
   all, this is a change you *could* just make, but shouldn't without sign-off since it
   alters steps the user already saw and expects. Only steps still **Open** or **In
   progress** are eligible for this kind of revision — a step already marked **Done**
   stays as-is; if a done step turns out wrong, say so and let the user decide whether
   to reopen it rather than rewriting history in `GUIDE_ME.md`.
7. If the user's own report, given while working on the current step, already covers
   a later open step out of order (they explored ahead on their own initiative and it
   produced a real result), credit that step directly instead of asking them to redo
   it "properly" in sequence — then re-thread the remaining open steps around what's
   now known. Free exploration adjacent to the current step is valuable, not a
   deviation to correct back onto the plan.

If the user's feedback changes scope (adds, removes, or reorders tasks), that request
already is the confirmation — update the plan and `GUIDE_ME.md` accordingly before
continuing, no separate approval round needed.

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

**Keep it out of version control by default.** `GUIDE_ME.md` is session scratch
state, not a repo artifact — it's easy to sweep into an unrelated commit via
`git add -A`/`git commit -a` without anyone meaning to track it. The first time this
skill creates `GUIDE_ME.md` in a directory under git version control, check whether
it's already ignored; if not, exclude it locally (e.g. append `GUIDE_ME.md` to
`.git/info/exclude` — a local, uncommitted ignore list, not the tracked
`.gitignore`) rather than leave it exposed. Skip this if it's already ignored, the
directory isn't under version control, or the user has said they want this
particular file tracked.

## 5. Finishing

When every step is done, mark `GUIDE_ME.md` as complete (all items checked, a closing
note) and report a short summary of what was accomplished.

Before asking what to do with the file, actively check whether anything in it isn't
already captured in its proper place outside `GUIDE_ME.md` — a fix belongs in the
file it changed, a decision in the target repo's own docs or issue tracker, a
result in whatever record convention that repo uses. Go through the Notes and each
step's findings one by one; for anything not yet durable elsewhere, either move it
there now or flag it to the user and ask where it belongs. Content that belongs
nowhere in the target repo (e.g. an observation about this skill's own process) goes
to the user directly, not left stranded in the file.

Once nothing of value is orphaned in it, remove `GUIDE_ME.md` by default — it was
progress-tracking scratch state, not a record worth keeping for its own sake once
everything it held has a proper home. Keep it only if the user explicitly wants a
resumable record on disk regardless (e.g. the guide isn't actually finished, just
paused), or asks to keep it. If they want it kept **and** shared with others (not
just left on disk for themselves), that means actually tracking it — say so and let
them decide, since the default above keeps it locally excluded.

## Definition of done

- [ ] `GUIDE_ME.md` exists and reflects the current plan and state, updated after
      every step (not reconstructed only at the end).
- [ ] In a git-versioned directory, `GUIDE_ME.md` is excluded from accidental
      commits (already ignored, newly excluded, or the user explicitly chose to
      track it).
- [ ] The in-session task list (if the agent has one) reflects the current step list
      and state — checked separately from `GUIDE_ME.md`, not assumed to follow from it.
- [ ] Every step was reported with its concrete result before moving on. The guide
      waited for explicit user confirmation where required; that confirmation also
      authorized starting the next agreed open step without a redundant permission
      question, unless that step required distinct authorization.
- [ ] No step's work started before the user confirmed the previous one, except where
      the user's own feedback changed the plan.
- [ ] Any mid-execution plan revision — whether from user feedback or from something
      discovered during a step — was reflected in `GUIDE_ME.md`; revisions the agent
      itself proposed (not requested by the user) were confirmed before being applied,
      and no step already marked **Done** was silently rewritten.
- [ ] At finishing: `GUIDE_ME.md` is marked complete, a summary was reported, its
      content was checked against where it's actually captured elsewhere (with any
      orphaned finding moved or flagged), and the file was removed unless the user
      chose to keep it.
