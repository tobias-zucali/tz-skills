---
name: coordinate
description: Run long multi-step work as a coordinator that delegates implementation, reviews, and test runs to separate agent sessions, keeps shared state in a durable file instead of chat history, and spends the context and usage budget deliberately. Use when the user asks to coordinate or orchestrate work across sessions, to run a guide with delegated sessions (step by step by default, autonomously on request), when GUIDE_ME.md declares a coordinated mode, or invokes /coordinate.
---

Act as the coordinator of a long piece of work: hold the plan, the user's decisions,
and their approvals; hand units of work to separate sessions; and keep everything a
later session needs in a durable state file. Every turn of a session re-reads its whole
history, and delegated sessions and costly runs (model test runs, large evaluations)
usually draw on the same usage window, so that window is the budget this skill spends.

Apply this skill in proportion. Its purpose is less total cost for a trustworthy
result; drop any part that costs more than it saves for the work at hand (a short
coordination needs no rotation and no cost notes). Numbers below are starting values,
not limits: the user or the state file can set others, and they need a fresh look when
models, context windows, caching, pricing, or quotas change.

## 0. Set up

1. Find the coordination system and the rules that own it. Default: `GUIDE_ME.md` in
   the working directory, owned by the `guide-me` skill (programme format). The user
   may name another system instead or in addition — an issue tracker, a project
   board, a project's own coordination document. For each one, locate its owning
   rules: the skill that defines it, or the project's documentation for it (a tracker
   guide, a contributing file, the project's agent instructions). If a system has no
   documented rules, ask the user how it is kept before writing to it. Read the state
   and the items it points to — not the whole tracker.
2. Settle the pace without stopping to ask about it. Coordination decides how work is
   routed, not how often the user is consulted; running without confirmation pauses is
   opt-in.
   - **Step mode** (default): delegate and verify the current step, report its
     result, and wait for the user's go-ahead before starting the next one. Start
     units of a later step early only when the user agrees. Say once, in the first
     report, that the user can switch to autonomous mode.
   - **Autonomous mode**: only when the user says so in this conversation (for
     example "autonomous", "without pauses", "keep going on your own"), or when the
     state already records it (for `GUIDE_ME.md`, its mode line). A request to
     coordinate or continue is not by itself that instruction. Continue with the
     next actionable steps after each report, and stop only for what waits for the
     user.
   - **What waits for the user** in either mode: what the user named, or a list the
     state records, otherwise the default — commits, pushes, outgoing messages,
     replies on shared platforms, actions only the user can take (measurements,
     physical or account actions), and the user's own decisions — plus anything the
     project's or user's agent instructions reserve.
   - Do not require a particular state format. Record the pace and the list only
     where the owning rules provide a place for them (for `GUIDE_ME.md`, a dated mode
     line as the `guide-me` skill describes, written only for autonomous mode), and
     otherwise state them in the first report.
3. Check what the agent can do and adapt:
   - **Separate sessions** (sessions the user can open, steer and stop): delegate as
     described below.
   - **Only subagents** (results return within the current turn): delegate reviews and
     searches to them; do implementation in short units yourself and rotate the
     coordinator sooner.
   - **Neither**: work inline in units small enough that a fresh session could take
     over after any of them, and keep the state file current at those points.
   - **A usage or quota tool**: use it for the checkpoints in section 3. Without one,
     estimate from the work started so far and say that it is an estimate.

## 1. Stay a coordinator

- Read reports, decide routine questions, and keep the plan moving. Keep your own
  history small: do inline only what section 4 assigns to the coordinator, and route
  implementation, reviews, and test runs as that section decides.
- Each coordinator turn, take the next steps from the state, separate what is
  actionable now (in step mode: within the current step) from what waits on the user
  or third parties, route the actionable units (section 4), and surface the waiting
  ones as open user items.
- Ask the user only for what waits for them (section 0, item 2), for the go-ahead
  between steps in step mode, and for decisions that do not follow from anything they
  have already said.
- Treat a session's report as a claim, not proof: check the diff, file, or result it
  names before you mark the step done.

## 2. Keep the coordination state current

Write state through each system's own rules, not a format of your own:

- **`GUIDE_ME.md`**: follow the `guide-me` skill — update it after every step
  (sections 3 and 4), keep the programme format, compact only items already recorded
  elsewhere, never rewrite a finished item, and mirror the step list into the agent's
  task list if it has one.
- **Any other system**: follow its owning rules for item states, transitions,
  comments, and closing (for example, move an issue through the lifecycle its tracker
  documentation defines, rather than editing a status line by hand).
- **Several systems at once**: each fact lives in one of them. Details, requirements,
  and evidence stay in the system that owns them (usually the tracker); the guide holds
  sequence, current state, and pointers. Where the state file and an owning item
  disagree, the owning item's latest entry wins; correct the state file.

Keep the state current at every point where a fresh session might take over: before
a turn ends, the state reflects each event of that turn — a verified result, a user
decision or approval, a delegated session started or finished, an accepted plan
revision. Several events of one turn go into one update.

Whether the work is coordinated needs no marker in the state: a coordinator starts
because the user asks for one or a handover names it (section 7), and a delegated
session learns its role from its brief. What the state must show, in every mode and
in whatever form the owning rules allow, is the work in flight: each running
delegated session, what it is doing, the files or items it touches, and where its
result will arrive. Any later session, coordinated or not, can then see what not to
touch. Remove an entry when its session finishes. Delegated sessions that write to a
shared system follow the same owning rules; name them in the brief. When the
coordinator alone owns a file (usually `GUIDE_ME.md`), sessions report back and the
coordinator writes it.

## 3. Spend the budget at checkpoints

- Note for each unit which window or quota it draws on: the coordinator's plan, a
  separate account (for example, a test account), or another vendor's quota. Work on a
  separate quota does not count against the coordinator's window, but its evaluation
  usually does.
- Check usage at points where the answer can change a decision: before starting work
  large enough to matter against the remaining window, and when such work reports back.
  Skip the check for small inline work, and do not poll in between.
- Default thresholds, unless the user or state file sets others, applied to the most
  constrained window the planned work draws on (a weekly limit can bind while a
  short window is nearly empty): above about 80 %, tell the user what still fits and
  ask before starting anything large; above about 90 %, start nothing new and bring the state file up to
  date. Weigh the time to the next reset: shortly before a reset, waiting is often
  cheaper than squeezing work in, and a high share of a window that resets soon matters
  less than the same share of a long one.
- Before a costly run, estimate its share of the usage window and of any separate
  quota (another vendor's agent, an API budget) and state the estimate.

## 4. Delegate where it pays

Delegation is a cost decision. A fresh session pays a cold start: it re-reads the
files and rediscovers the context the coordinator already has. Work done inline pays
differently: every token it adds to the coordinator's history is re-read on every
later coordinator turn. Choose the cheapest route that still gives a trustworthy
result.

**Pick the route per unit:**

| Route                | Use when                                                                                                   |
|----------------------|------------------------------------------------------------------------------------------------------------|
| Inline (coordinator) | A few tool calls with small output, or a decision that needs the coordinator's context                     |
| Subagent             | A search, read, or review whose result the coordinator needs in this turn, and whose raw output is large    |
| Existing session     | The next unit touches the same files or decisions as a session that is still short                          |
| New session          | A unit with its own outcome (a change, a branch, a long run) that the user may open, steer, or review apart |
| Unattended script    | A long run or job that needs no judgment until it finishes                                                  |

- **Size units by shared context, not by step count.** Consecutive units that need the
  same files go to the same session while its history is short; a unit that needs
  different files starts fresh. A unit too small to repay a cold start stays inline or
  joins a related unit.
- **Pick the cheapest capable model and effort.** Mechanical work (renames,
  documentation sync, running a script and summarising it) takes the cheapest model at
  low effort; ordinary implementation a mid-tier model; design, ambiguous trade-offs,
  and reviews the strong model. Raise the tier only after a cheaper one has failed or
  when a wrong result is expensive to detect.
- **Make the brief carry the context.** The brief is the main lever on cold-start
  cost: exact file paths and sections, decisions already made, what was already ruled
  out, and what not to re-investigate. Give the task, what done looks like, and the
  constraints — commit policy, budget, whether costly runs are allowed, and which
  coordination system it may write to under which rules. Add the working rules: a task
  list per step, a result per step, plan revisions proposed rather than applied.
- **Start fresh by default.** Pass the coordinator's history (a fork) only while that
  history is short and the unit genuinely needs it.
- **Parallelise for wall time, not cost.** Parallel sessions cost the same tokens or
  more. Start them only when waiting matters, and never with two writers on the same
  files. Run code-writing sessions in separate working trees and name the base branch
  explicitly; the tool's default is often not the branch the work belongs on.
- **Keep reviews independent but small.** A review runs in a fresh read-only session
  that did not implement the change, scoped to the diff and the criteria it must check,
  with a verdict per item. Review where a wrong result is costly or hard to see; a
  mechanical change checked by a test needs none.
- **Keep reports short.** About ten lines plus file paths unless the brief asks for
  more; detail goes into a
  dated note file (the project's research or notes folder, or a scratch directory).
  Verify a report by looking at its diff or result, not by re-running the work.
- **Hand over before a session grows long.** Send follow-ups to the session that has
  the context while it is short; once it is long, have it write a handover note and
  continue in a fresh session from that note.
- **Learn from actual cost.** When usage is measurable, note the usage of each
  delegated unit against the estimate in the state file's notes, and adjust route,
  unit size, and model tier for similar units.

## 5. Hand commits back for review

When the user reviews commits before they are made, the change must reach the
coordinator's checkout as exactly the commits the user approves. If a session works
in its own working tree or its change must be split into several commits, have it
prepare one patch per intended commit plus a messages file, and verify that applying
the patches reproduces its working tree; after approval, apply each patch to the index
(`git apply --cached`) and commit exactly what was approved. A single change already in
the coordinator's checkout needs no patch: show it and commit it after approval. Follow the
project's own commit rules where they are stricter.

## 6. Run long jobs unattended

- Choose which costly runs to start, on which hosts, and how often by the project's own
  test policy; default to one repeat.
- Start long runs as unattended scripts, preferably right after a quota reset, and
  evaluate their output in a short fresh session. A large session that waits on run
  chunks re-reads its whole history at every wake-up.

## 7. Rotate the coordinator

Rotation trades a one-off handover (bringing the state file up to date, and a cold
start that reads it) against the cost of re-reading a long history on every remaining
turn. Rotate when that trade favours a fresh start, judged on these signals:

- a phase boundary, after which little of the history matters;
- many coordinator turns still ahead while the history is already long relative to
  the context window and to what the remaining work needs (as a starting value, a
  fifth of the window);
- signs of strain: earlier decisions get missed, work gets repeated, or the agent
  warns about context or compacts the history;
- a change of model, context window, or caching that changes the cost of re-reading.

Skip rotation when the work is nearly done; finishing in place is cheaper. Before
handing over:

1. Update the state file: current state with its date, next steps in order, open user
   items, sessions still running and what each is waiting for.
2. Make sure every decision and approval from this session is in the state file or the
   tracker, not only in chat.
3. Offer to archive finished delegated sessions and remove their working trees — only
   on the user's yes — so the next coordinator starts from a short session list.
4. Give the user a ready-to-use way back in: the request that opens a new coordinator
   on this state, naming the skill, the state file or tracker, and the pace (for
   example "/coordinate on `GUIDE_ME.md`, step mode"). Start it yourself only if the
   agent can and the user has agreed.

## 8. Close out

When the work is done or paused: bring the state file up to date, list the delegated
sessions and their final state, and offer to archive finished sessions and remove
their working trees — only on the user's yes. If the state file was a guide, finish it
as the `guide-me` skill describes.

## Definition of done

- [ ] Coordination started without a pause to ask for a mode or format. It ran in
      step mode unless the user or the state opted into autonomous mode; the pace and
      what waits for the user were recorded where the owning rules allow it or stated
      in the first report, and nothing on that list was done without the user's
      explicit approval.
- [ ] Each unit's route (inline, subagent, existing or new session, script) and model
      tier was chosen by the cost rules in section 4; every delegated session received a
      brief naming task, files, done criterion, and constraints; reviews ran in fresh
      read-only sessions that did not implement.
- [ ] Usage was checked (or estimated, and said so) before and after large work
      when it could change a decision, and nothing large started past the agreed
      thresholds without the user's go-ahead.
- [ ] Each step marked done in the state file was checked against its diff, file, or
      result, not only against the session's report.
- [ ] Each coordination system was written through its owning rules (for
      `GUIDE_ME.md`, the `guide-me` skill) and updated at every verified result,
      user decision, session start or finish, and accepted plan revision.
- [ ] Running delegated sessions, with what each touches, were in the state for as
      long as they ran, not only at handover.
- [ ] At rotation or close-out, the state file holds current state, next steps, open
      user items, and running sessions, so a fresh session can continue from it alone,
      and the user received a ready-to-use request to reopen the coordinator.
