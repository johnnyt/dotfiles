---
name: audit-doc
description: Review existing documentation against the Diátaxis framework — classify each section with the compass, flag quadrant blurring (explanation in tutorials, recipes in reference, feature-organized how-tos), and propose one small concrete improvement per page. Pass a file path, or no argument to sweep the project's docs root.
argument-hint: ["doc file path (omit to sweep the docs root)"]
---

# Audit documentation against Diátaxis

You are assessing existing docs, not rewriting them. The deliverable is findings plus
**one recommended next action per page** — Diátaxis's improvement model is explicitly
incremental ("choose something small, improve it, publish, repeat"), never a
restructure plan.

## Step 0: Load context

1. Read the rulebook at `~/.claude/skills/diataxis/SKILL.md` — especially "The blurring
   problem" section, which is the finding taxonomy for this audit.
2. Read the project docs manifest at `<repo root>/.claude/diataxis.md` for the docs
   root, audience, and conventions. If absent, ask the user which files to audit and
   who the audience is.

## Step 1: Scope

- **Single file given**: audit it inline yourself.
- **No argument**: enumerate the docs root from the manifest. For more than ~3 files,
  fan out one `doc-classifier` agent per file (a user-level agent defined for this
  purpose; fall back to general-purpose agents with the classifier instructions if it
  is unavailable), in parallel, then synthesize.

## Step 2: Classify and find

For each page:

1. **Page-level classification**: which quadrant does the page claim to be (from its
   title and framing), and which is it actually, by the compass?
2. **Section-level pass**: classify each section/paragraph. Record every span that
   belongs to a different quadrant than the page.
3. **Check against the blurring taxonomy** (rulebook): explanation in tutorials,
   teaching in how-tos, recipes/opinion in reference, feature-organized how-tos,
   one-page-does-everything.
4. **Check the page's own quadrant rules**: e.g. a tutorial whose steps lack visible
   results, a how-to with a vague title, a reference section with ambiguity, an
   explanation that never makes connections.
5. **Audience check** against the manifest: internal jargon leaking into end-user copy,
   tone mismatches.

## Step 3: Report

Produce a per-page report, most-problematic pages first:

- **Verdict**: claimed type vs. actual type, one line.
- **Findings**: each with section/heading anchor, the misplaced quadrant, and where the
  content should live instead. Concrete, quotable spans — not vibes.
- **The one next action**: the single smallest change that most improves the page
  (move a paragraph out and link it, retitle to name the task, split one section into a
  new page). One action, not a list — the user repeats the loop for the rest.
- **Coverage gaps** (sweep mode only): user questions with no home — e.g. docs have
  reference and explanation but no how-to guides at all. Note them as candidates for
  the project's issue workflow; do not scaffold empty pages.

Findings and recommendations are the deliverable. Apply a fix only if the user asks —
then apply exactly the "one next action" for the page(s) they name, and re-run the
page's checklist afterward.
