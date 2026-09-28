# Local Codex development with symlinked skills

Codex can load development skills directly from `$HOME/.agents/skills/`.
Symlinking each skill directory from this repository into that location keeps
the checked-out files as the single source of truth and avoids reinstalling the
plugin after every edit.

Do not symlink directories inside Codex's plugin cache. In particular, replacing
the cached plugin version directory or its complete `skills/` directory with a
symlink can leave the plugin visible in administration while its skills are
absent from the loaded skill catalog.

## Create the skill links

Set `REPO` to the absolute path of the checkout:

```bash
REPO=/absolute/path/to/tz-skills
mkdir -p "$HOME/.agents/skills"

ln -s "$REPO/skills/guide-me" "$HOME/.agents/skills/guide-me"
ln -s "$REPO/skills/skill-debug" "$HOME/.agents/skills/skill-debug"
```

If a destination already exists, inspect it before replacing anything:

```bash
ls -ld "$HOME/.agents/skills/guide-me"
readlink "$HOME/.agents/skills/guide-me"
```

Create one link for every skill that should be available during development.
Start a new Codex thread after adding a link or changing a skill; an existing
thread may retain the skill catalog and instructions it loaded when it started.

## Verify the links

```bash
test -L "$HOME/.agents/skills/guide-me"
test -L "$HOME/.agents/skills/skill-debug"

readlink "$HOME/.agents/skills/guide-me"
readlink "$HOME/.agents/skills/skill-debug"
```

The output should point into this repository. In a newly started Codex thread,
`guide-me` and `skill-debug` should then appear in the available skills.

## Remove the links

Removing these links does not remove the repository or its skill files:

```bash
unlink "$HOME/.agents/skills/guide-me"
unlink "$HOME/.agents/skills/skill-debug"
```

## Optional marketplace registration

The direct skill links are sufficient for live skill development. To make the
plugin available in Codex plugin administration, register this repository's
`.agents/plugins/marketplace.json` as a local marketplace:

```bash
codex plugin marketplace add /absolute/path/to/tz-skills
```

Do not install `tz-skills@tz-skills` while the direct skill links are active.
Otherwise Codex discovers every skill twice: once through the installed plugin
and once through `$HOME/.agents/skills/`.

To switch from live development to testing the packaged plugin, first remove
the direct links and then install it:

```bash
unlink "$HOME/.agents/skills/guide-me"
unlink "$HOME/.agents/skills/skill-debug"
codex plugin add tz-skills@tz-skills
```

Codex copies installed plugin content into its cache. Leave that cache intact.
The repository's `.claude-plugin/` directory is the Claude Code plugin
manifest, while `.agents/plugins/marketplace.json` describes the local Codex
marketplace.
