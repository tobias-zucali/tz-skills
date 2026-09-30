#!/usr/bin/env bash

# Read-only environment inventory for the detect-features skill.
# It deliberately performs no network requests and prints no complete
# environment dump.

set -u

printf '%s\n' '## os'
uname -srm 2>/dev/null || printf '%s\n' 'unknown'
printf 'user=%s\n' "$(id -un 2>/dev/null || printf '%s' unknown)"
printf 'cwd=%s\n' "$(pwd 2>/dev/null || printf '%s' unknown)"

printf '%s\n' '## env_hints'
if command -v env >/dev/null 2>&1 && command -v awk >/dev/null 2>&1 && command -v sort >/dev/null 2>&1; then
  env 2>/dev/null | awk -F= '
  $1 ~ /^(CLAUDE|CLAUDECODE|ANTHROPIC_|CODEX|OPENAI_|CHATGPT|GEMINI|CURSOR|VSCODE_|TERM_PROGRAM|WINDSURF|AIDER|CONTINUE_|GITHUB_ACTIONS|CI|CODESPACES|REPL_|JUPYTER|COLAB_|PLAYWRIGHT_BROWSERS_PATH|HTTPS?_PROXY)/ {
    key = $1
    value = substr($0, length(key) + 2)
    upper_key = toupper(key)
    if (upper_key ~ /(KEY|TOKEN|SECRET|PASSWORD|CREDENTIAL|AUTH|COOKIE)/) {
      value = "<redacted>"
    } else if (upper_key ~ /^HTTPS?_PROXY$/) {
      value = "<set>"
    } else if (upper_key !~ /^(CLAUDECODE|CODEX_SANDBOX|CODEX_SANDBOX_NETWORK_DISABLED|CODEX_SHELL|CODEX_VERSION|CI|GITHUB_ACTIONS|TERM_PROGRAM)$/) {
      value = "<set>"
    } else if (length(value) > 120) {
      value = substr(value, 1, 120) "..."
    }
    print key "=" value
    }
  ' | LC_ALL=C sort
else
  printf '%s\n' 'inventory=unavailable'
fi

printf '%s\n' '## path_markers'
for probe_path in \
  /mnt/data \
  /mnt/user-data \
  /mnt/user-data/uploads \
  /mnt/user-data/outputs \
  /mnt/skills \
  /home/claude \
  /home/sandbox \
  /workspace \
  /content \
  /kaggle \
  "${HOME:-/nonexistent}/.claude" \
  "${HOME:-/nonexistent}/.codex" \
  "${HOME:-/nonexistent}/.gemini" \
  ./CLAUDE.md \
  ./AGENTS.md \
  ./GEMINI.md \
  ./.cursor
do
  if [ -e "$probe_path" ]; then
    printf 'present: %s\n' "$probe_path"
  fi
done

printf '%s\n' '## binaries'
for binary_name in \
  bash sh zsh python3 node git curl gh pandoc libreoffice soffice typst \
  pdflatex wkhtmltopdf chromium google-chrome
do
  binary_path=$(command -v "$binary_name" 2>/dev/null || true)
  if [ -n "$binary_path" ]; then
    printf '%s: %s\n' "$binary_name" "$binary_path"
  fi
done

printf '%s\n' '## python_libs'
if command -v python3 >/dev/null 2>&1; then
  python3 - <<'PY' 2>/dev/null || true
import importlib.util

for module in (
    "docx",
    "docxtpl",
    "openpyxl",
    "pptx",
    "jinja2",
    "reportlab",
    "weasyprint",
    "markdown",
    "matplotlib",
    "plotly",
    "pandas",
    "pypdf",
    "fitz",
):
    present = "yes" if importlib.util.find_spec(module) else "no"
    print(f"{module}: {present}")
PY
else
  printf '%s\n' 'python3: unavailable'
fi

printf '%s\n' '## network'
printf '%s\n' 'probe=not_run'
