---
name: detect-features
description: Detect the current agent runtime's usable capabilities and its support for portable, ChatGPT/Codex, and Claude plugin features. Use for "detect features", "what can this runtime do?", capability manifests, or cross-agent runtime adaptation.
---

# Detect Features

Produce an evidence-backed snapshot of what the current session can use and
which plugin components its host supports. Keep runtime abilities separate from
plugin loading support: a host can support a component without making an
instance of it available in this session.

Read [references/feature-catalog.md](references/feature-catalog.md) before
classifying features. It defines the required keys, current non-deprecated
plugin catalog, and the signals that count for each key.

## Evidence rules

Use these values exactly:

- Runtime `available`: `yes`, `no`, or `unknown`.
- Plugin `support`: `yes`, `no`, `partial`, or `unknown`.
- Plugin `available`: `yes`, `no`, or `unknown`.
- Sandbox `writable_fs`: `yes`, `no`, or `unknown`; sandbox `network`:
  `open`, `restricted`, `none`, or `unknown`.
- `basis`: `probe`, `tool`, `status`, `prompt`, `filesystem`,
  `documentation`, `inference`, or `none`.

Quote `"yes"` and `"no"` in YAML so YAML 1.1 parsers do not coerce them to
booleans.

Prefer evidence in this order:

1. A harmless probe run now with an observed result.
2. A callable or deferred tool's description and provenance.
3. A native feature, connector, or MCP status inventory.
4. An explicit statement in the host instructions.
5. Read-only filesystem or CLI metadata.
6. The dated documentation baseline in the feature catalog.
7. An indirect inference.

Apply these constraints:

- Never derive a capability from a vendor, product, surface, or model name
  alone. Identity selects potentially relevant documentation; it does not prove
  current availability.
- Every `yes`, `no`, or `partial` must cite at least one evidence ID. Use
  `unknown` with `basis: none` when no reliable signal exists.
- Use `no` only after direct failure or authoritative negative evidence. A
  missing tool proves unavailability only when the exposed inventory is known
  to be complete.
- Use documentation only for plugin `support`, never for current-session
  `available`.
- Treat conflicting evidence explicitly: retain the strongest observed value
  and record the conflict. Do not silently reconcile it.
- Quote the shortest exact tool-description fragment or output line that
  proves the claim. Deduplicate shared evidence in the `evidence` map.

## Probe the runtime

1. Identify vendor, product, surface, and model only from explicit host
   statements. Otherwise report the field as `unknown`.
2. Inventory every callable and deferred tool visible to you. Classify tools by
   their descriptions, not name matches alone.
3. If local command execution is available, run
   `scripts/probe-environment.sh` from this skill directory. It reads system
   metadata, prints redacted environment hints, and does not test network
   access. Use its exact output lines as evidence.
4. Run only probes that are harmless and proportional:
   - For subagents, use one nonce round trip when a spawn facility is present.
   - For parallel calls, use several independent read-only calls in one turn
     only when the host permits it.
   - For filesystem access, read an existing non-sensitive file. Test writes
     only in a host-designated scratch directory, never in user work, and clean
     up when the host provides a safe method.
   - For document pipelines, rely on the script's binary and library inventory;
     do not create sample documents during the normal probe.
     A missing dependency disproves only that local route. Report the overall
     format as `no` only when the complete inventory also rules out native and
     remote authoring facilities; otherwise use `unknown`.
   - Do not make a network request, browser interaction, external mutation, or
     user-visible action solely to prove a capability.
5. If a safe probe is unavailable, classify from the tool inventory or leave
   the value `unknown`.

## Detect MCP without a bundled server

Do not call any MCP tool merely to test MCP, and do not expect this skill to
ship an MCP configuration.

Check, in order:

1. Callable and deferred tool provenance for tools exposed by an MCP server or
   app/connector.
2. A host-native connector or MCP inventory/status view, when the current
   agent can read it without connecting, authenticating, or changing state.
3. Read-only configuration metadata or a documented list command, when it does
   not start servers or reveal credentials. Record only server names,
   transports, and status; never print headers, tokens, environment values, or
   authentication payloads.
4. The documentation baseline, but only for host-level plugin support after
   the surface has been identified by separate evidence.

An exposed MCP-backed tool proves current availability. A configuration entry
alone proves configuration, not a successful connection. General MCP support
with no connected server can therefore be `support: yes, available: no` or
`available: unknown`, depending on the status evidence.

## Classify plugin features

Report every feature key from the catalog under its ecosystem, even when the
value is `unknown`.

- `support` answers whether the identified host/surface can load or implement
  the component.
- `available` answers whether this session exposes a usable instance or direct
  evidence that the component loaded.
- Use `partial` when the host supports only a documented subset, transport, or
  surface-dependent form. Explain the boundary in a short `note`.

Do not include deprecated features. In particular, omit legacy MCP SSE,
Claude `commands/`, and `.dxt` bundles rather than reporting them as
unsupported.

## Output

Return one fenced YAML document with schema `detect-features/v1`, followed by a
plain-language summary of no more than eight lines. Do not emit a comparison
table or raw appendix by default.

Keep each feature on one YAML line where practical:

```yaml
schema: detect-features/v1
observed_at: "<ISO-8601 timestamp or unknown>"
catalog_as_of: "2026-09-30"
runtime:
  vendor: {value: unknown, basis: none, evidence: []}
  product: {value: unknown, basis: none, evidence: []}
  surface: {value: unknown, basis: none, evidence: []}
  model: {value: unknown, basis: none, evidence: []}
  os: {value: unknown, basis: none, evidence: []}
  sandbox: {writable_fs: unknown, network: unknown, basis: none, evidence: []}
capabilities:
  agents.spawn: {available: unknown, basis: none, evidence: []}
  # Include every runtime and reporting key from the catalog.
plugin_features:
  portable:
    skills: {support: unknown, available: unknown, basis: none, evidence: []}
    # Include every portable key from the catalog.
  openai:
    # Include every OpenAI key from the catalog.
  claude:
    # Include every Claude key from the catalog.
unknowns: []
conflicts: []
evidence:
  E1: {basis: tool, detail: "<short exact description fragment>"}
```

The summary should state the identified runtime, the most consequential usable
features, important plugin limitations, and unresolved unknowns. Do not repeat
the full manifest in prose.

For a verbose or audit request, append these sections without changing the
manifest fields:

1. Complete visible tool inventory, including deferred tools.
2. Unmodified environment-probe output.
3. Per-feature evidence notes and documentation matches.

Write a report file only when the user asks for one. Use the host's normal
output location and return its path.

## Definition of done

- [ ] The output contains valid `detect-features/v1` YAML and a summary of no
      more than eight lines.
- [ ] Every runtime and non-deprecated plugin key in the feature catalog is
      present, including unknown values.
- [ ] Every `yes`, `no`, or `partial` value cites evidence, and identity alone
      was not used to prove a capability.
- [ ] Plugin support is distinct from current-session availability.
- [ ] MCP was detected passively: no MCP tool was called merely for the probe,
      and no bundled MCP server was assumed.
- [ ] No external state was changed, no network request was made solely for
      detection, and no secret or credential value appears in the output.
- [ ] Default output omits raw inventories; audit output includes them without
      changing the stable manifest.
