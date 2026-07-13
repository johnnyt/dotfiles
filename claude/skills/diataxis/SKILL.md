---
name: diataxis
description: Diátaxis documentation framework rulebook (https://diataxis.fr) — the compass classifier, per-type writing rules, language cues, and anti-patterns. Load this before writing, reviewing, or classifying any user-facing documentation. Used by /write-doc and /audit-doc.
---

# Diátaxis rulebook

Diátaxis organizes documentation around **user needs**, which fall into a 2×2 matrix of
two axes:

- **Action vs. cognition** — does the content serve *doing* (practical steps) or
  *knowing* (propositional knowledge)?
- **Acquisition vs. application** — does the user need it while *learning* (at study) or
  while *getting something done* (at work)?

|                          | Action (doing)   | Cognition (knowing) |
|--------------------------|------------------|---------------------|
| **Acquisition** (study)  | **Tutorial**     | **Explanation**     |
| **Application** (work)   | **How-to guide** | **Reference**       |

Each type answers a characteristic user question:

- Tutorial — *"Can you teach me to…?"*
- How-to guide — *"How do I…?"*
- Reference — *"What is…?"*
- Explanation — *"Why…?"* / *"Tell me about…"*

## The compass (classification procedure)

To classify any piece of content — a whole page, a section, or a single sentence — ask
the two axis questions in order:

1. Does it inform **action** or **cognition**?
2. Does it serve the user's **acquisition** of skill or the **application** of skill?

action + acquisition → tutorial · action + application → how-to ·
cognition + application → reference · cognition + acquisition → explanation

Apply the compass **at every scale**. A page that is nominally one type can contain a
paragraph or sentence that belongs to another quadrant — that is the finding, and the fix
is usually to move it and link to it, not delete it.

**Complexity does not determine type.** Advanced tutorials and trivial how-to guides both
exist. Only the user's situation (learning vs. working, doing vs. knowing) matters.

## Tutorial rules (learning-oriented lesson)

The obligation is a successful **learning experience**, not a completed task.
Responsibility for success sits with the author, not the learner.

- One single path, start to finish. **No options, no alternatives, no branches.**
  Eliminate conditions by design.
- **Every step produces a visible, comprehensible result.** Tell the learner what they
  should see at each point (a "narrative of expectations") so they know they're on track.
- **No explanation.** Give the barest minimum needed to keep moving, then link to an
  explanation page for later. This is the single most common failure mode.
- Concrete step to concrete step — no abstraction or generalization.
- Be explicit about basic things; assume no implicit knowledge.
- Must be **reliable**: works identically for every learner, every time. Tutorials go
  stale as the product evolves — they need maintenance discipline.

Language cues: "In this tutorial, you will…" · "Notice that…" · "You should now see…"

## How-to guide rules (task-oriented directions)

The obligation is helping a **competent user accomplish a real goal**. Responsibility
sits with the user; the guide assumes basic competence (like a recipe assumes you can
hold a knife).

- **Action and only action.** No teaching, no digression, no explanation.
- Organize and title around the **user's goal**, never around product features or
  machinery. Titles name the task exactly: "How to <specific outcome>".
- Practical usability beats completeness — start and end at sensible points; no need to
  be exhaustive.
- May **branch**: "If you want x, do y" conditionals are fine (unlike tutorials).
- Sequence steps in the order a human would actually think and act.
- Point to reference material for exhaustive options rather than inlining them.

Language cues: "This guide shows you how to…" · imperative steps · "To achieve w, do z."

## Reference rules (neutral technical description)

The obligation is **truth and certainty** — a firm platform the user consults while
working. Users read reference like a map or dictionary: they consult it, they don't read
it through.

- **Neutral description is the key imperative.** No opinion, no persuasion, no recipes,
  no interpretation.
- Austere, consistent, accurate, complete. Ambiguity and doubt are defects.
- Structure **mirrors the structure of the product itself** — reference is led by the
  product, not by user tasks (the only quadrant where this is true).
- Content: facts, behaviors, options, limits, error states; brief usage examples for
  illustration; warnings where consequences are real.

## Explanation rules (discursive understanding)

The obligation is **deepened understanding** — read at leisure, away from the product,
not while working. It takes the higher, wider view.

- Bounded by a **topic**, not a task or a product component. Titles should support an
  implicit "about": "About <topic>" / "<Topic> explained" / "Why <design choice>".
- Provide background, context, history, design rationale, trade-offs.
- **Make connections** — link related topics, even beyond the immediate scope.
- **Opinion is allowed** and often required: discuss alternatives, counter-examples,
  why one approach was chosen over another (the opposite of reference).
- Keep boundaries: don't absorb instructions (how-to) or specifications (reference).

Language cues: "The reason for x is that historically…" · "W is preferred over z
because…" · "An x interacts with a y as follows…"

## The blurring problem (what audits look for)

Categories bleed into each other over time. The canonical drifts:

1. **Explanation leaking into tutorials** — background/rationale paragraphs derailing a
   lesson. Fix: extract to an explanation page, leave a link.
2. **How-to guides that teach** — a stealth tutorial that assumes nothing and explains
   everything. Fix: strip to actions, assume competence, link out.
3. **Reference with recipes or opinions** — task instructions or advocacy inside
   specifications. Fix: move recipes to how-to guides, judgments to explanation.
4. **Feature-organized how-tos** — guides structured around the product's surface
   instead of user goals. Fix: retitle and reorganize around tasks.
5. **One page trying to be everything** — a "guide" that tutors, instructs, specifies,
   and explains at once. Fix: split into per-type pages that link to each other.

## Workflow rules (how to apply the framework)

- **Never restructure wholesale.** Do not pre-build empty tutorial/how-to/reference/
  explanation sections. Structure is a *consequence* of incremental improvement, not a
  precondition.
- The improvement loop: pick any small piece in front of you → assess it against user
  need → decide **one** action → complete and publish it now → repeat. Don't batch.
- Documentation should be **complete at every stage** of its growth (like an organism),
  never "finished."
- At scale: each of the four sections gets a landing page that genuinely introduces its
  contents (not a bare link list); subdivide lists past ~7 items; parallel hierarchies
  are legitimate when distinct user types (end-user vs. developer vs. operator) can't
  share one structure.
- Functional quality (accuracy, completeness, consistency, precision) is the floor;
  deep quality (flow, anticipation of the user, feeling good to use) is the goal and
  depends on the floor being solid.

## Templates

Skeletons for each type live in `references/` next to this file:

- `references/tutorial-template.md`
- `references/how-to-template.md`
- `references/reference-template.md`
- `references/explanation-template.md`
