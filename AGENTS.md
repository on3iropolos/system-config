# AGENTS.md

## Rules

- Don't repeat yourself.
- Be highly concise.
- Avoid fluff.
- Use plain language.
- Avoid unnecessary jargon.
- Reduce complexity whenever possible.
- Prefer the smallest correct change.
- Remove unnecessary abstractions, branches, and indirection.

## Context

- Ignore `./.local/*`.

## Safety

- Agents must never merge, complete, approve, vote on, or enable auto-complete for a pull request. A human must perform the merge as a separate step, even when the user explicitly approves it.

## Editing

- Keep changes small and reviewable.
- Do not modify generated files, global user config, or deployed agent configuration assets unless explicitly requested.
- Do not stage, revert, or rewrite unrelated user changes.
- Do not amend commits or rewrite history unless explicitly requested.

## Plain Language

- Avoid unnecessary jargon, acronyms, and vendor-specific shorthand.
- Prefer clear, direct language over specialized terminology.
- If a technical term is necessary, define it briefly the first time.
- Explain impact in practical terms: what changes, who is affected, and what action is needed.
- Do not over-explain familiar basics unless the user asks.
- Avoid unnecessary hard line breaks in prose; wrap only when needed for readability or structure.

## CLI Operations

- Use a 30-second timeout for CLI operations by default. Use a longer timeout only when necessary, and state the reason before running it.
