# tz-skills

Personal agent skills, packaged as plugins so they can be installed and updated
across machines instead of copied into each agent's skills directory.

## Skills

- **detect-features** — evidence-backed detection of general runtime abilities
  and portable, ChatGPT/Codex, and Claude plugin-component support. Produces a
  compact machine-readable manifest plus a short human summary.
- **guide-me** — step-by-step guided walkthrough of a task list,
  setup process, or multi-part goal. Tracks progress in `GUIDE_ME.md` and pauses
  for confirmation after each step.
- **skill-debug** — wraps another skill's execution, logging its process
  and any friction live to `SKILL_DEBUG_<skill-name>.md`, then compares the
  outcome against that skill's own Definition of done (falling back to
  prose-based judgment, explicitly flagged, if it has none) and suggests
  concrete improvements.

See `docs/SKILL_DESIGN.md` for how to write a skill in this repo, including
the Definition of done convention that `skill-debug` relies on, and the
cross-agent portability rule these skills follow.

Each `skills/<name>/SKILL.md` is plain markdown and works on its
own — the plugin install flows below are conveniences, not requirements. Any
AI agent that reads this skill format can use a `SKILL.md` file directly, e.g.
by copying it into wherever that agent looks for skills.

## Installing

### ChatGPT desktop app and Codex CLI

[Official OpenAI plugin documentation](https://developers.openai.com/plugins/build/plugins)

From a terminal, add the marketplace and install the plugin:

```bash
codex plugin marketplace add tobias-zucali/tz-skills
codex plugin add tz-skills@tz-skills
```

Verify the result:

```bash
codex plugin marketplace list
codex plugin list
```

Alternatively, open the Plugins directory in the ChatGPT desktop app, add a
marketplace from `https://github.com/tobias-zucali/tz-skills`, then install
**tz-skills** from that marketplace. Start a new chat after installation so the
new skill catalog is loaded.

### Claude Code

[Official Anthropic plugin marketplace documentation](https://support.claude.com/en/articles/13837440-use-plugins-in-claude)

In the Claude desktop app:

1. Open **Customize → Plugins → Yours**.
2. Select **Add → Add marketplace → Add from a repository**.
3. Enter `https://github.com/tobias-zucali/tz-skills` and select **Sync**.
4. Under **From marketplaces you added**, open **Tz skills** and install it.

To review or update the marketplace later, open
**Customize → Plugins → Yours → Add → Manage marketplaces**.

Alternatively, use the CLI:

```bash
claude plugin marketplace add https://github.com/tobias-zucali/tz-skills
claude plugin install tz-skills@tz-skills
```

To pick up changes later: `claude plugin update tz-skills@tz-skills`. Start a
new session after installing or updating the plugin.

### Ask an agent to install it

You can give a local coding agent this prompt:

> Install the `tz-skills` marketplace and plugin from
> `https://github.com/tobias-zucali/tz-skills`. First check whether the
> marketplace and `tz-skills@tz-skills` are already installed, add only what
> is missing using the host's official plugin commands, verify that the plugin
> is installed and enabled, and tell me whether I need to restart the app or
> start a new session. Do not modify the plugin repository.

### Other agents

`SKILL.md` follows the open Agent Skills format ([agentskills.io](https://agentskills.io)),
so the skills themselves work elsewhere too — each platform just has its own
way of loading them. If a host does not support plugin marketplaces, copy or
symlink the desired `skills/<name>/` directory into that host's skill search
path.

### Local Codex plugin development

For live development of the complete plugin, see
[`docs/CODEX_LOCAL_DEVELOPMENT.md`](docs/CODEX_LOCAL_DEVELOPMENT.md). It explains
how to symlink individual skills into `$HOME/.agents/skills/` and optionally
register this repository as a local Codex marketplace.

## Release conventions

This repository follows [Semantic Versioning](https://semver.org/). The
canonical plugin version is the `version` field in
`.claude-plugin/plugin.json`; do not duplicate it in
`.claude-plugin/marketplace.json` or the individual skills.

Choose the version bump according to the user-visible plugin change:

- **Patch** (`x.y.Z`) for backward-compatible fixes, clarifications, and
  refinements to an existing skill's behavior.
- **Minor** (`x.Y.0`) for a new skill or a substantial backward-compatible
  capability added to an existing skill.
- **Major** (`X.0.0`) for breaking changes such as removing or renaming a skill,
  changing its purpose incompatibly, or requiring users to adapt an established
  workflow.

Documentation or repository-maintenance changes that do not alter the packaged
skills do not require a version bump. When a release contains several changes,
use the highest bump required by any of them. Make the version bump in the same
commit as the change it releases; avoid version-only follow-up commits.

Before committing a release:

1. Follow the validation requirements in `AGENTS.md` for every changed skill.
2. Check the plugin manifest is valid JSON and run `git diff --check`.
3. Review the complete staged diff and commit the skill, documentation, and
   version bump together.
4. Push the commit, then update the installed plugin locally to exercise the
   released version (`claude plugin update tz-skills` for Claude Code).

This repository does not require a Git tag or a separate changelog for each
release. The versioned commit and its message are the release record.

## Adding a new skill

1. Create `skills/<name>/SKILL.md`.
2. Add `"./skills/<name>"` to `.claude-plugin/plugin.json`'s `skills` array.
3. Validate the skill according to `AGENTS.md`.
4. Apply the minor version bump required by the release conventions above.
5. Commit and push, then update the installed plugin locally.
