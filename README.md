# tz-skills

Personal agent skills, packaged as plugins so they can be installed and updated
across machines instead of copied into each agent's skills directory.

## Skills

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

### ChatGPT desktop app

[Official OpenAI plugin marketplace documentation](https://developers.openai.com/plugins/build/plugins)

1. Open **Customize → Plugins**.
2. Select **Add → Add plugin marketplace**.
3. Enter the following values:
   - **Source:** `git@github.com:tobias-zucali/tz-skills.git`
   - **Git ref:** `main`
   - **Sparse paths:** `plugins/codex`
4. Select **Add marketplace**.
5. In the **Personal** tab, find the **tz-skills** marketplace and select **+**
   next to **tz-skills** to install it.

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
claude plugin install tz-skills
```

Or, from inside a running Claude Code session:

```
/plugin marketplace add tobias-zucali/tz-skills
/plugin install tz-skills@tz-skills
/reload-plugins
```

After installing, the skills are available as `/tz-skills:guide-me` and
`/tz-skills:skill-debug`. A private repo requires GitHub access (e.g. a working
`gh auth login` or SSH key).

To pick up changes later: `claude plugin update tz-skills`.

### Other agents

`SKILL.md` follows the open Agent Skills format ([agentskills.io](https://agentskills.io)),
so the skills themselves work elsewhere too — each platform just has its own
way of loading them:

- **OpenAI Codex CLI** — copy or symlink `skills/<name>/` into
  `.agents/skills/` (project-local) or `$HOME/.agents/skills/` (global),
  similar to how Claude Code reads `~/.claude/skills/`.

## Adding a new skill

1. Create `skills/<name>/SKILL.md`.
2. Add `"./skills/<name>"` to `.claude-plugin/plugin.json`'s `skills` array.
3. Bump `version` in `plugin.json`.
4. Commit and push (and run `claude plugin update tz-skills` locally to pick it up).
