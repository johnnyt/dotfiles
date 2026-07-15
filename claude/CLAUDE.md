# Personal preferences

## Git
- Never add Claude attribution to commit messages or PR bodies. Do not include
  `Co-Authored-By: Claude ...` trailers or "Generated with Claude Code" lines.

## Scripting
- Prefer **Ruby** for scripts you write, including small one-off/throwaway
  scripts — I'm most familiar with it. Lean on the stdlib (`net/http`, `json`,
  `uri`, etc.) and avoid gems unless necessary.
- Exceptions: (1) if a task must run inside a toolchain that lacks Ruby (e.g.
  `walt_ui`'s docker/Elixir-only image), use that toolchain's language; (2) if a
  task genuinely needs a library with no good Ruby equivalent, flag it and ask
  before falling back to another language.
