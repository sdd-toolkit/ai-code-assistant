<!--
Copyright (c) Github Speckit
MIT License
-->

Generate an actionable, dependency-ordered tasks.md for the feature based on available design artifacts.

1. Run `.specify/scripts/bash/check-task-prerequisites.sh --json` from repo root and parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be absolute.

2. Load and analyze available design documents:
   - Always read plan.md for selected touched areas, implementation shape, verification strategy, repo gaps, and the Coverage Block
   - Always read spec.md for requirements, business rules, scope boundaries, and prohibited behaviors
   - IF EXISTS: Read data-model.md for entities
   - IF EXISTS: Read contracts/ for externally observable obligations when the plan justifies them
   - IF EXISTS: Read research.md for technical decisions
   - IF EXISTS: Read quickstart.md for test scenarios
   - IF EXISTS: Read reference-context.md for supplemental design, visual-system, interaction, technical, and validation signals
     - Add tasks for loading, empty, error, and validation states when required
     - Add accessibility and responsiveness tasks when required
     - Add explicit styling and manual visual-verification tasks when preserved visual-system or style-token obligations are present
     - Keep non-reference-driven features on the existing task generation path

2.1. **Enforce Reference Context Completeness**: - If `spec.md` indicates reference-derived input (for example reference metadata or reference-context-style analysis cues) but `reference-context.md` is missing in the feature directory: STOP and return an error instead of continuing task generation.

Note: Not all projects have all documents. For example:

- CLI tools might not have contracts/
- Simple libraries might not need data-model.md
- Generate tasks based on what's available

3. Generate tasks following the template:
   - Use `.specify/templates/tasks-template.md` as the base
   - Replace example tasks with actual tasks based on:
     - **Setup tasks**: Repo gaps, prerequisites, tooling, config
     - **Verification tasks [P]**: Constitution-supported automated checks or explicit manual validation steps
     - **Implementation tasks**: Workflows, rules, interfaces, states, and constraint-preservation work
     - **Integration tasks**: Cross-boundary or cross-cutting behavior only when required by the plan
     - **Design-driven tasks**: State handling, accessibility, responsiveness, preserved visual-system styling, and terminal behavior when `reference-context.md` requires them
     - **Polish tasks [P]**: Final verification, docs, and justified follow-up checks
   - Tasks must be executable changes or concrete verification runs; do not emit read-only review, analysis, or "lock requirements" tasks as substitutes for work

4. Task generation rules:
   - Every `AC-*`, `FR-*`, and `EC-*` item must be covered by at least one implementation or verification task
   - Use constitution-aware verification guidance; do not generate unsupported automated suites
   - If project standards allow only unit tests, do not generate contract, integration, or e2e suites
   - If no backend/API exists, do not generate endpoint, middleware, repository, or DB tasks
   - If the feature is UI-only, favor component, styling, validation, accessibility, visual-system, and manual-scenario tasks
   - If `reference-context.md` identifies user-visible states, validation behavior, visual-system obligations, or source-supported rules about how entered values are treated, add implementation and verification tasks for them
   - If `reference-context.md` preserves visual-system or style-token requirements, add at least one explicit implementation task and one manual visual-verification task for them; each task must name the specific values from the reference that must be applied or confirmed, including positional and sizing values (for example width, height, min/max constraints, padding, gap, alignment, order, and offsets) — reducing obligations to generic language such as "style the form" or "add responsive behavior" is a defect
   - If the spec or plan says the feature must NOT do something, add explicit constraint-preservation tasks
   - Source tags may contain only requirement IDs from the spec or Coverage Block (`AC-*`, `FR-*`, `EC-*`); mention quickstart scenario IDs, research decisions, or contract names only in task descriptions
   - If automated verification requires tooling the repo does not yet have, create setup tasks first or keep verification manual; do not generate test-first tasks against a nonexistent harness
   - Verification tasks must either create or update a supported automated check, or run explicit manual scenarios from `quickstart.md`
   - Keep the task set minimal and immediately executable; avoid planning-only or document-reread tasks
   - Different files = can be parallel [P]
   - Same file = sequential (no [P])
   - Add short requirement source tags such as `[AC-001]`, `[FR-003]`, `[EC-002]`

5. Order tasks by dependencies:
   - Setup before any dependent work
   - Verification before implementation when supported by the plan and repo
   - Order from file dependencies and implementation shape, not from canned architecture sequences
   - Do not place read-only review tasks ahead of implementation; ordering must reflect real work dependencies
   - Everything before polish

6. Include parallel execution examples:
   - Group [P] tasks that can run together
   - Show actual Task agent commands

7. Create FEATURE_DIR/tasks.md with:
   - Correct feature name from implementation plan
   - Numbered tasks (T001, T002, etc.)
   - Clear file paths for each task
   - Dependency notes
   - Parallel execution guidance

8. Perform a coverage audit before returning:
   - List any uncovered `AC-*`, `FR-*`, or `EC-*` items
   - Refuse to finish silently if coverage gaps remain
   - Keep the task set as small as possible while still fully covering the spec and plan

The tasks.md should be immediately executable - each task must be specific enough that an LLM can complete it without additional context.
