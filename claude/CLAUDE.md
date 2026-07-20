# Personal preferences

## Writing style
- Never use em dashes, en dashes, or other typographic characters a human wouldn't type on a standard keyboard. Use plain hyphens and ordinary punctuation instead.

## Git
- Never add Claude attribution to commit messages or PR bodies. Do not include
  `Co-Authored-By: Claude ...` trailers or "Generated with Claude Code" lines.
  If a project's CLAUDE.md specifies different attribution behavior, follow that instead.

## Notion
- For **reading** Notion (fetch, search, data-source/view queries, meeting notes,
  comments), prefer the `notion-reader` agent (Agent tool,
  `subagent_type: notion-reader`) over calling the Notion read MCP tools directly.
  It absorbs the noisy MCP payloads in its own context and returns only the
  distilled result plus the IDs/URLs you need. Tell it what you want back, and
  pass any IDs you already have. It is read-only — do Notion **writes** yourself.

## Scripting
- Prefer **Ruby** for scripts you write, including small one-off/throwaway
  scripts — I'm most familiar with it. Lean on the stdlib (`net/http`, `json`,
  `uri`, etc.) and avoid gems unless necessary.
- Exceptions: (1) if a task must run inside a toolchain that lacks Ruby (e.g.
  `walt_ui`'s docker/Elixir-only image), use that toolchain's language; (2) if a
  task genuinely needs a library with no good Ruby equivalent, flag it and ask
  before falling back to another language.
