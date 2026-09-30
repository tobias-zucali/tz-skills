# Feature catalog

Catalog version: 1

Documentation reviewed: 2026-09-30

Use this catalog as the complete key set for `detect-features/v1`. It covers
runtime abilities from the earlier runtime probe and current plugin component
types from the sources below. It intentionally omits deprecated compatibility
features rather than emitting rows for them.

## Runtime capability keys

| Key | Positive signals | Important boundary |
| --- | --- | --- |
| `agents.spawn` | Successful nonce round trip through a subagent facility | A product claim or agent-themed tool name is insufficient. |
| `tools.parallel` | Host statement permitting parallel calls, or observed parallel read-only calls | Concurrent work inside one shell process is not parallel tool calling. |
| `web.search` | Search tool description or successful harmless search | Browser navigation alone is not search. |
| `web.fetch` | Fetch/open tool description or successful harmless fetch | Search snippets alone are not full-page fetch. |
| `browser.control` | Browser navigation/DOM interaction facility | A fetch-only HTTP client does not count. |
| `computer.use` | Screenshot plus pointer/keyboard control over a UI | Browser-only automation does not prove general computer use. |
| `code.execute` | Shell, interpreter, notebook, or code-execution tool | Pure code editing without execution does not count. |
| `files.read` | Successful read or a direct file-read tool description | A path shown in instructions is not proof it is readable. |
| `files.write` | Successful scratch write or direct writable-filesystem contract | Never write into user work solely for this probe. |
| `files.deliver` | Host output/download facility or proven file attachment path | Filesystem writes alone do not prove user delivery. |
| `artifacts.publish` | Native artifact/canvas/site publishing facility | Creating a local file is not publishing. |
| `docs.living` | Writable document, sheet, slide, canvas, or equivalent connected surface | Local DOCX/XLSX/PPTX generation belongs under reporting. |
| `tasks.schedule` | Automation, trigger, reminder, or scheduler facility | A long-running shell process is not durable scheduling. |
| `skills.load` | This skill's loaded instructions or an explicit skill loader/catalog | A directory named `skills` without loader evidence is insufficient. |
| `user.ask_structured` | Choice/form/question facility described by the host | Plain chat questions do not count. |
| `image.input` | Host accepts images for model inspection | Filesystem image access alone may not prove model vision. |
| `image.generate` | Image-generation facility | Drawing via generic code is not native image generation. |
| `memory.persistent` | Durable memory API or explicit cross-session memory contract | Current conversation history is not persistent memory. |
| `device.local` | Facility explicitly reaching the user's local computer or apps | A remote sandbox is not the user's device. |

## Reporting capability keys

These rows remain under `capabilities` and use the `reporting.` prefix.

| Key | Positive signals |
| --- | --- |
| `reporting.docx` | `docxtpl`, `python-docx`, or Pandoc with reference-document support |
| `reporting.xlsx` | `openpyxl`, `pandas`, or a native spreadsheet authoring facility |
| `reporting.pptx` | `python-pptx`, Pandoc presentation output, or a native presentation authoring facility |
| `reporting.pdf` | LibreOffice conversion, Pandoc plus a PDF engine, Typst, WeasyPrint, wkhtmltopdf, ReportLab, or a native PDF facility |
| `reporting.html` | Jinja, Markdown renderer, or an equivalent HTML templating path |
| `reporting.charts` | Matplotlib, Plotly, or a native chart facility |

A remote service may establish `available: yes` when its tool description
explicitly says it produces that format. Note `via` when a feature needs a
pipeline rather than one tool.

## Portable Agent Plugins keys

The Agent Plugins 1.0.0 portable core consists of a root manifest, skills, MCP
servers, and namespaced client extensions. ChatGPT/Codex and several other
clients document support for skills and current MCP transports, but availability
still requires session evidence.

| Key | What support means | Availability signal |
| --- | --- | --- |
| `manifest` | Loads the root Agent Plugins `plugin.json` contract | The current package was identified through that manifest or a native plugin inventory reports it. |
| `skills` | Loads `skills/<name>/SKILL.md` | This skill is loaded through a portable plugin/skill loader. |
| `mcp.stdio` | Can configure the current `stdio` MCP transport | A connected stdio server/tool or native connected status. |
| `mcp.streamable_http` | Can configure the current Streamable HTTP transport | A connected remote server/tool or native connected status. |
| `client_extensions` | Recognizes at least one reverse-domain extension namespace | A loaded extension with observable host behavior. |

Do not include legacy HTTP+SSE. The specification marks it deprecated and
optional.

## OpenAI plugin keys

| Key | What support means | Availability signal |
| --- | --- | --- |
| `skills` | ChatGPT or Codex can load packaged skills | Current skill metadata/instructions are loaded. |
| `registered_apps` | Resolves a registered MCP app mapping from the OpenAI extension | An installed app/connector exposes tools or native connected status. |
| `lifecycle_hooks` | Loads plugin hook configuration at supported Codex runtime events | Native hook inventory, hook-provided context, or observed harmless hook result. |
| `mcp_apps_ui` | Renders UI resources using the open MCP Apps bridge | A current tool advertises or returns a UI resource; do not call it solely to test. |
| `ui_extensions` | Provides current ChatGPT-specific UI extensions beyond MCP Apps | Explicit host/tool metadata for a supported extension. |
| `mcp_events` | Supports discovery and subscription for current MCP Events methods | Native event capability/status; do not create a subscription solely to test. |
| `mcp_oauth` | Supports MCP authorization and connection UI | Native connection metadata/status indicating OAuth support or an authenticated connection. |

OpenAI packaging uses the portable root manifest plus `extensions.com.openai`;
the `.codex-plugin/plugin.json` layout is a supported compatibility fallback,
not a separate feature row.

## Claude plugin keys

Claude's surfaces load different subsets. When the surface is independently
identified, the platform support matrix may establish `support`; it never
establishes current availability.

| Key | What support means | Availability signal |
| --- | --- | --- |
| `skills` | Loads packaged `skills/<name>/SKILL.md` | Current skill instructions are loaded. |
| `agents` | Loads plugin-defined subagents | Namespaced agent appears in a native agent inventory or completes a nonce round trip. |
| `hooks` | Loads `hooks/hooks.json` | Native hook inventory or an observed harmless hook result. |
| `mcp.local` | Starts local command/stdio MCP servers | Connected local server/tool or native connected status. |
| `mcp.remote` | Connects fixed remote HTTP MCP servers | Connected remote server/tool or native connected status. |
| `mcpb` | Loads current `.mcpb` server bundles | Native plugin/MCP inventory identifies a loaded MCPB server. |
| `lsp` | Loads plugin LSP server configuration | Native LSP status or observed diagnostics attributed to the server. |
| `bin` | Adds plugin `bin/` executables to the execution path | Resolved executable path within an identified plugin root. Do not execute solely to test. |
| `settings` | Applies supported plugin default settings | Native settings inventory or an explicit applied setting. |
| `themes` | Loads plugin themes | Theme inventory identifies the plugin theme. |
| `output_styles` | Loads plugin output styles | Output-style inventory identifies the plugin style. |
| `channels` | Loads an MCP-backed external message channel | Native channel status or explicit channel metadata. |
| `monitors` | Runs supported interactive-session plugin monitors | Native monitor status; do not start one solely to test. |
| `user_config` | Prompts for and resolves declared plugin configuration | Native plugin configuration metadata/status; never print stored values. |

Do not include `commands/`; Claude documents commands as the older format
superseded by skills. Do not include `.dxt`; use the current MCPB row.

### Documented Claude surface baseline

Use this only when the current surface was established independently.

| Feature group | Chat | Cowork | Claude Code |
| --- | --- | --- | --- |
| Skills | yes | yes | yes |
| Agents | no | yes | yes |
| Hooks | no | yes | yes |
| Remote fixed-URL MCP | partial: user connects it | yes | yes |
| Local MCP and MCPB | no | yes when running locally | yes |
| MCP using unresolved user configuration | no | partial | yes |
| `bin/` | no; plugin cannot be installed | no; plugin cannot be installed | yes |
| LSP, output styles, themes, settings | no | no | yes |

The source matrix does not give a complete cross-surface statement for channels
or monitors. Leave those `unknown` unless stronger evidence is present.

## Source baseline

- Agent Plugins specification 1.0.0:
  <https://agent-plugins.org/specification>
- Agent Plugins compatible clients:
  <https://agent-plugins.org/compatible-clients>
- OpenAI plugin architecture:
  <https://developers.openai.com/plugins/concepts/plugins>
- OpenAI package format and lifecycle hooks:
  <https://developers.openai.com/plugins/build/plugins>
- OpenAI MCP Apps UI:
  <https://developers.openai.com/plugins/build/chatgpt-ui>
- OpenAI MCP Events:
  <https://developers.openai.com/plugins/build/mcp-events>
- OpenAI plugin authentication:
  <https://developers.openai.com/plugins/build/auth>
- Claude plugin components:
  <https://code.claude.com/docs/de/plugins/components>
- Claude platform support matrix:
  <https://claude.com/docs/plugins/platform-support>

If a later authoritative source contradicts this dated catalog, record the
conflict and prefer the newer source for that run. Do not silently add or remove
schema keys; that requires a catalog/schema revision.
