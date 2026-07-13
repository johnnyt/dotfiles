---
name: write-doc
description: Author a piece of end-user documentation following the Diátaxis framework — classify the topic with the compass, gather ground truth from the codebase, draft from the matching template, and self-check against the quadrant rules. Project-agnostic; reads the project's docs manifest for audience, tone, and file conventions.
argument-hint: ["topic, user question, or issue number to document"]
---

# Write a Diátaxis document

You are authoring **end-user documentation**, not developer docs. The reader is a user
of the product, described by the project's docs manifest.

## Step 0: Load context

1. Read the Diátaxis rulebook at `~/.claude/skills/diataxis/SKILL.md`. Keep its compass
   and per-type rules in working memory for the whole task.
2. Find the **project docs manifest**: a file named `diataxis.md` in the project's
   `.claude/` directory (i.e. `<repo root>/.claude/diataxis.md`). It defines: the
   product name, the audience, tone/terminology rules, where doc sources live, the file
   format (frontmatter etc.), and any publishing-pipeline notes.
   - If no manifest exists, tell the user and offer to create one (ask them for
     audience, docs root, and format); do not proceed on guesses.

## Step 1: Classify with the compass

Take the requested topic and ask the two compass questions:

1. Action or cognition?
2. Acquisition (learning) or application (working)?

Then:

- State your proposed type (tutorial / how-to / reference / explanation) **and the user
  question it answers** ("How do I…?", "What is…?", …), and confirm with the user
  before drafting.
- If the topic genuinely spans quadrants (most "document X" requests do), propose a
  **split**: separate pages per type that link to each other. Never draft one blended
  page. Recommend which page to write first (usually the one closest to the user's
  stated need).
- Remember: difficulty does not determine type — an advanced topic can still be a
  how-to; a simple one can still be a tutorial.

## Step 2: Gather ground truth

Documentation must describe the product as it actually behaves.

- If codebase-exploration agents are available in this project (e.g.
  `codebase-locator`, `codebase-analyzer`, `Explore`), spawn them to establish the real
  behavior: actual UI flow, actual option names and defaults, actual error states,
  actual limits. Otherwise explore directly.
- For **reference** pages this step is mandatory and exhaustive within the page's
  declared scope — reference must mirror the product's real structure and be wholly
  accurate.
- For **tutorials**, walk the real flow mentally end-to-end; every step's "you should
  now see…" claim must reflect actual product behavior. Flag any step you could not
  verify.
- Use the product's **user-facing vocabulary** (visible labels, menu names), never
  internal code names — the manifest's terminology section governs.

## Step 3: Draft

- Start from the matching template in `~/.claude/skills/diataxis/references/`.
- Follow the manifest's file conventions (location, filename pattern, frontmatter).
- Obey the quadrant's language cues and rules from the rulebook without exception. In
  particular:
  - Tutorial: single path, visible result per step, zero explanation (link out).
  - How-to: action only, goal-titled, branches allowed, delegate detail to reference.
  - Reference: neutral facts only, product-mirroring structure.
  - Explanation: topic-bounded prose, connections, honest trade-offs.
- Where a rule forces content out of the page (e.g. rationale out of a tutorial), leave
  a link to the page that should hold it — creating a stub target or noting it as a
  follow-up if it doesn't exist yet.

## Step 4: Self-check (compass at paragraph level)

Before presenting, re-read the draft one paragraph at a time and classify each with the
compass. Any paragraph that belongs to a different quadrant gets moved out and replaced
with a link. Then run the template's publishing checklist and fix failures.

## Step 5: Present

Show the user where the file was written, the type chosen and why, any split proposal
or stub links created, and anything you could not verify against the product (verify
before publishing). If follow-up pages emerged (stubs, split remainders), list them so
the user can queue them via the project's issue workflow.

Work incrementally — one publishable page per invocation, per Diátaxis's own guidance.
Do not scaffold empty sections or sibling pages "for structure."
