# Skill design guidelines

How to write a skill for this repo so it's easy for Claude to follow correctly
and easy to evaluate afterward.

## Anatomy of a skill

- **Frontmatter** — `name` and `description`. The description is what routes a
  request to this skill: state concretely when to invoke it (trigger phrases,
  the situations that should match, the `/slash-command` name if any). Vague
  descriptions ("helps with tasks") cause both missed and wrong invocations.
- **Body** — imperative instructions addressed to Claude, describing what to
  do, not what the skill "is". Structure into ordered sections when the skill
  has a real sequence (setup → do the work → finish); group by concern when it
  doesn't.

## Definition of done

Recommended for any skill whose job is more than a single trivial step: a
`## Definition of done` section near the end of the SKILL.md, written as a
checklist of concrete, checkable outcomes.

```markdown
## Definition of done
- [ ] <file/state X exists or reached this value>
- [ ] <user explicitly confirmed Y>
- [ ] <Z>
```

Write each item so it can be checked against actual session state — a file
exists, a value equals X, the user gave an explicit confirmation — rather than
a vague goal like "did a good job" or "helped the user."

**Why it matters:** prose alone ("the guide is done when every step is
checked") is fine for a human skimming the skill once, but hard to verify
mechanically or compare against after the fact. A checklist lets a tool (for
example `skill-debug`, see below) confirm success item by item instead of
falling back to subjective judgment. A skill without this section isn't
broken, but tools that evaluate skills will flag the absence explicitly
rather than silently guessing — this is a real gap worth closing.

## Other principles for a good skill

- **Single responsibility.** One skill does one thing. If you're describing
  a skill with "and", consider whether that's two skills.
- **Checkable steps.** Each step in the process should have a clear, checkable
  outcome — not just for the user, but ideally for a debugging tool reading
  the same instructions.
- **Consistent artifacts.** If a skill produces a durable file (state,
  progress tracking, a report), name and format it consistently so it's
  predictable across runs and discoverable by other tooling.
- **Imperative voice, addressed to Claude.** Write instructions as directives
  ("Read the file", "Ask the user") rather than descriptions of behavior
  ("Claude will read the file").
- **Don't over-specify.** Match step granularity to verifiable outcomes, not
  a fixed count of sub-tasks or a time box — see `guide-me`'s own guidance on
  this for an example.

## Debugging a skill

`skills/meta/skill-debug` wraps another skill's execution: it traces the
process live to a log file, flags friction as it happens, and at the end
compares the outcome against the target skill's Definition of done (falling
back to prose-based judgment, explicitly flagged, if the section doesn't
exist) before suggesting concrete improvements. Use it to evaluate any skill
in this repo, including itself.
