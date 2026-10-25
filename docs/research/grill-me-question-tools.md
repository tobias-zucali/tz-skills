# Grill-me and structured question tools

Research date: 2026-10-25. Scope: primary documentation, upstream source, public adaptations, and first-person upstream feedback. These sources establish available mechanisms and design choices, not measured cross-provider compliance rates. Tool availability belongs to the running host, not just the model provider.

## What upstream actually does

Matt Pocock's current [`grill-me`](https://github.com/mattpocock/skills/blob/main/skills/productivity/grill-me/SKILL.md) is a thin launcher for [`grilling`](https://github.com/mattpocock/skills/blob/main/skills/productivity/grilling/SKILL.md). The latter collects every currently unblocked decision into a numbered prose round. Consequently, copying current upstream would preserve the user's unwanted batching.

Upstream explicitly makes [native question tools out of scope](https://github.com/mattpocock/skills/blob/main/.out-of-scope/native-question-tool.md). Its reasons are host differences, unavailable tools, and the risk of multiple-choice UI constraining open answers. It suggests personal instructions for users who prefer their host's question tool. This repository should describe its adaptation as an intentional preference change, rather than a repair endorsed by upstream.

In [upstream discussion #771](https://github.com/mattpocock/skills/discussions/771), users report too many questions, increased cognitive load, and questions being reformulated when background investigation returns. These are first-person reports, not controlled evaluations. They directly support testing one stable outstanding question at a time.

## Documented host capabilities

| Host | Primary evidence | Implication for this skill |
| --- | --- | --- |
| Claude Code | [Tools reference](https://code.claude.com/docs/en/tools-reference#askuserquestion-tool-behavior) documents `AskUserQuestion`, option selection, custom answers through Other/notes, and configurable auto-continue timeout. | Explicitly call the exposed tool. Do not interpret a timeout or dismissed dialog as a substantive decision. |
| Codex / OpenAI hosts | [Official app-server documentation](https://learn.chatgpt.com/docs/app-server#toolrequestuserinput) documents the request/response lifecycle and an optional `autoResolutionMs` value that lets clients resolve unanswered prompts automatically. | A server request being resolved does not by itself prove the user answered. Read the response and require an explicit substantive answer for the interview decision. |
| Gemini CLI | [Ask User Tool](https://geminicli.com/docs/tools/ask-user/) documents `ask_user`, 1–4 questions, choice/text/yes-no forms, and a dialog that pauses until answer or dismissal. Choices require option objects, unlike the user-provided OpenAI async example. | Submit an array containing exactly one question. Use native free text where appropriate; inspect dismissal rather than inventing an answer. |
| OpenCode | [Tools documentation](https://opencode.ai/docs/tools/#question) documents `question`, selectable options/custom answers, and multi-question navigation. | Use the native question tool when exposed, but submit only one question despite its batching capability. |

The official OpenAI page above does **not** establish a universal ChatGPT tool name or universal availability of `functions.request_user_input_async`. In this task, that exact alias and its title/string-options schema were supplied by the user and exposed in the authoring session. The synchronous `request_user_input` tool description says Plan-only, illustrating why availability must be checked together with applicable mode restrictions. Those are session observations, not claims about all installations. Likewise, `Ask User Input` is a user-supplied Claude name here; the Claude Code documentation cited above establishes `AskUserQuestion`. Treat all names as candidate aliases and obey the actual exposed schema and restrictions.

## Public adaptations worth learning from

These are inspectable implementations, not evidence of measured improvement. Similar names alone do not prove fork ancestry.

| Source | Observed adaptation | Assessment for this request |
| --- | --- | --- |
| [RobMitt/grill-me-skill](https://github.com/RobMitt/grill-me-skill/blob/main/SKILL.md) | Requires `AskUserQuestion`, one question at a time, explicit waiting, concrete options, and self-service file investigation. | Closest small implementation of the requested interaction, but its unconditional Claude tool dependency needs a portable availability fallback. |
| [MrAlias/codex-skills](https://github.com/MrAlias/codex-skills/blob/main/grill-me/SKILL.md) | Checks current-mode availability of `request_user_input`, uses it for natural 2–3-option choices, asks one question, and avoids low-value repetition. | Good capability/mode handling. Its plain-text fallback choices should defer to host restrictions; its Plan-mode output format is host-specific. |
| [marmotize/skills](https://github.com/marmotize/skills/blob/main/grill-me/SKILL.md) | Explicitly names `request_user_input` and falls back to one chat question when unavailable. | Useful direct invocation instruction and fallback; its absolute prohibition on summarizing is unnecessary here. |
| [gusinov/grill-me](https://github.com/gusinov/grill-me/blob/main/grill-me/SKILL.md) | One-at-a-time interviewing, recommended answers, persistent answer capture, and flags for gaps the user cannot resolve. | Useful long-session state management. Automatic file writes/indexing introduce extra scope; an internal decision ledger is sufficient unless durable capture is requested. |
| [teamvoth/claude-skills](https://github.com/teamvoth/claude-skills/blob/main/skills/grill-me/SKILL.md) | Explicit structured tool calls, meaningful option descriptions, and batches of up to four questions. | Tool use is useful, but batching directly conflicts with the stated preference. |

## Recommended portable contract

The following are design recommendations inferred from the evidence and this user's requirements, not vendor guarantees:

1. Put the binding interaction rule near the start: **exactly one decision question in flight**, including tool payloads. One array element must not conceal several decisions in its title or prose.
2. Before asking, inspect the exposed tool catalog and applicable restrictions. Call the native structured question tool when available **and permitted**. Name known aliases as examples, including the requested OpenAI async alias, without pretending a skill can install or expose them. Follow the live schema rather than replaying one provider's JSON everywhere.
3. For a decision with real alternatives, offer 2–3 concise options with meaningful tradeoffs and an evidence-based recommendation when warranted. Preserve custom answers. Do not invent choices simply to force an open-ended question into multiple choice; use supported free text or the permitted conversational fallback.
4. When an async tool returns immediately, leave the question pending. Only independent fact gathering may continue. Do not ask the next question, decide a dependent branch, issue a final completion summary, or count a preselected default as the user's answer.
5. Distinguish answer, skip/defer, dismissal, cancellation, and timeout. A skip marks a decision unresolved; a missing answer is not consent. Respect higher-priority host instructions about optional no-answer behavior and use conversation for any required answer when that host prohibits the structured tool for required input.
6. Read discoverable facts before asking. Once a question is presented, keep it stable; late evidence should inform the next turn or an explicit correction, not silently replace a pending question.
7. Recompute the dependency tree after each answer. Track settled decisions and explicit unresolved items; summarize and stop when useful decisions are covered or the user ends the interview. Do not infer authorization to implement the resulting plan.
8. Validate the interaction as a transcript/state-machine behavior. Check zero-, one-, and async-tool hosts; wrong-mode restrictions; native text questions; pending response; timeout; skip; contradiction; stop; and multiple unblocked decisions. Check emitted calls and transitions, not merely whether the instructions contain a tool name.

This improves clarity of instructions and makes violations observable. It cannot guarantee tool selection, create unavailable tools, override host rules, or establish reliability percentages without repeated real-provider evaluations.

## License and attribution

Upstream uses the [MIT license](https://github.com/mattpocock/skills/blob/main/LICENSE), copyright 2026 Matt Pocock. It permits reuse and modification and requires preserving its copyright and permission notice with copies or substantial portions. For an adaptation, retain that notice and license text in the distributed skill directory (for example, `LICENSE`) and link upstream in an attribution note. Do not assume that upstream MIT covers copied additions from other authors; this report paraphrases their design choices and recommends writing the implementation independently.
