---
name: grill-me
description: Stress-test a plan, design, decision, or idea through an adaptive interview with one structured question at a time. Use when the user says "grill me", "challenge my plan", "poke holes in this", or asks for an interview to expose assumptions before acting; /grill-me is one invocation route.
---

Interview the user until the important decisions, assumptions, constraints,
and failure cases are understood. Be direct and curious; challenge the idea
without attacking the person. The user owns the decisions.

## Question contract

**Call an available structured user-question tool for each interview question.
Ask exactly ONE question containing ONE decision, then wait for its answer.**
This includes the opening question and the final confirmation. Never send a
questionnaire, batch questions because the tool permits it, hide several
questions inside one title, or ask a second question while one is pending.
Keep the remaining decision tree internal rather than presenting it as a
list of questions for the user to answer.

Before the first question, inspect the tools actually exposed in this session
and their descriptions, schemas, and mode restrictions. If the host offers
tool discovery and the question tool is deferred, discover/load it first.
Do not assume a tool exists from a provider name or from this skill.

Use the matching callable tool when available and permitted:

| Runtime tool or label | Action |
| --- | --- |
| `functions.request_user_input_async` or `request_user_input_async` | Call it with exactly one entry in `questions`; use its `title` and string `options` schema if exposed. It returns before the answer arrives. |
| `request_user_input` (possibly namespaced) | Call it with exactly one entry in `questions`; supply the actual required fields, often `header`, `id`, `question`, and option objects with `label` and `description`. Respect the current mode's availability. |
| `AskUserQuestion` or a tool displayed as `Ask User Input` | Resolve the actual callable name and use its schema with exactly one question. A display label is not necessarily an API identifier. |
| `ask_user`, `question`, or another equivalent | Call the exposed user-input tool using its schema, restricted to one question. |

If more than one is usable, choose the tool whose description best matches
this interaction. **Invoke it: mentioning its name or printing JSON does
not ask the user through the tool.** Skills cannot install tools, enable a
mode, or override tool restrictions. Do not change configuration or modes
just to obtain a picker.

If no suitable tool is available/permitted, or the tool reports that it is
unavailable, briefly say so and ask exactly one question in conversation.
If a call fails schema validation before delivery, correct the arguments
against the exposed schema; do not loop on an unavailable tool. If delivery
is uncertain, establish whether a question is pending before sending another.

For each question:

- Keep the question concise and specific to the user's plan. Give only the
  context needed to understand the consequence of the answer.
- For a real choice, offer 2–3 concrete, distinct options. Put a supported
  recommendation first and mark it `(Recommended)` where the schema allows;
  briefly explain its tradeoff. Do not invent a confident recommendation
  when facts or the user's priorities are missing.
- Preserve free-text answers. Use a free-text-only structured question when
  supported and choices would distort the answer. If the tool requires
  options, offer plausible directions with write-in support when available;
  if it cannot collect the needed response, use the conversational fallback.
  Do not add an "Other" option when the tool already supplies it.
- After submission, stop asking. For asynchronous tools, do only independent
  reading or fact-finding while awaiting the reply; when none remains, yield
  and wait. Do not advance dependent work, reinterpret the pending question,
  or send a duplicate through conversation.
- Treat an explicit answer as the decision. Silence, timeout, cancellation,
  an empty result, or a preselected/default option is not an answer. Keep the
  decision unresolved; allow the user to resume or explicitly defer it.

## Interview loop

1. Read the supplied idea and referenced material. If the subject is missing,
   ask for it using the question contract. Look up discoverable facts in the
   available files, tools, or sources instead of asking the user for them.
2. Map the major decision branches and their dependencies internally. Start
   with the most consequential unresolved prerequisite, such as the intended
   outcome or scope. Even when several questions are ready, select only one.
3. After each answer, update what is settled, assumed, deferred, or still
   open. Resolve vague answers with one focused follow-up. Test relevant
   constraints, counterexamples, failure paths, and tensions with earlier
   decisions; avoid a generic checklist or repeating settled questions.
4. Recompute the next question from the answer. A user can answer more than
   you asked: credit those decisions rather than asking them again. If they
   are unsure, help with a brief explanation or concrete options, then ask
   one question. Accept explicit deferrals and do not badger them in circles.
5. When the significant branches are settled or explicitly deferred, give a
   concise summary of decisions, reasons, assumptions, and open risks. Ask
   one final structured question confirming this shared understanding, with
   choices to confirm or correct it. If corrections arrive, address them
   before seeking confirmation again.

Keep the decision record in conversation by default; write a file only if
requested. Grilling authorizes investigation and discussion, not implementing
the plan. Confirmation of the summary ends the interview; act afterward
only within the user's separately authorized scope. If the user asks to stop
early, stop and summarize unresolved items without claiming completion.

## Definition of done

- [ ] The significant decision branches are settled or explicitly deferred,
      and the summary distinguishes decisions, assumptions, and open risks.
- [ ] Each interview question used an available, permitted structured tool,
      or the conversational fallback had a concrete availability or fit reason.
- [ ] Every submission contained exactly one question about one decision;
      no second question was submitted while an answer was pending.
- [ ] Dependent work waited for explicit answers; no default, silence,
      cancellation, or timeout was counted as a decision.
- [ ] The user explicitly confirmed the final shared understanding. An early
      stop or pending confirmation is recorded as incomplete.
- [ ] No implementation was performed solely on the authority of this interview.

## Origin

Inspired by [Matt Pocock's grill-me and grilling skills](https://github.com/mattpocock/skills/tree/main/skills/productivity/grill-me).
This adaptation deliberately uses one question per turn and native question
tools rather than upstream's batched text rounds. See [upstream license](LICENSE)
and the repository's [research notes](../../docs/research/grill-me-question-tools.md).
