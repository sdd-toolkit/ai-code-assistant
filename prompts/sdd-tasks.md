<!--
Copyright (c) Github Speckit
MIT License
-->

# Tasks

Generate an actionable, dependency-ordered tasks.md for the feature based on available design artifacts.

## Usage

- `@sdd-tasks <feature-name>` - Generate tasks for specified feature

**Note**: The `<feature-name>` parameter is **REQUIRED**. If not provided, an error will be generated.

---

## Generate Tasks

The user **MUST** provide a feature name. This parameter is compulsory.

### Steps

1. **Validate feature name parameter**:
   - **If no feature name provided**: ERROR "Feature name is required. Usage: @sdd-tasks <feature-name>"
   - **If feature name provided**: Continue with the specified feature
   - Verify the feature exists in `specs/`
   - If feature doesn't exist: ERROR "Feature '<feature-name>' not found in specs/. Available features: [list directory names from specs/]"
   - Set FEATURE_NAME to the provided feature name

2. Run `.specify/scripts/{{SCRIPT_LANG}}/check-task-prerequisites{{SCRIPT_EXT}} <feature-name> --json` from repo root and parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be absolute.

3. Load and analyze available design documents:
   - Always read plan.md for selected touched areas, implementation shape, verification strategy, repo gaps, and the Coverage Block
   - Always read spec.md for requirements, business rules, scope boundaries, and prohibited behaviors
   - IF EXISTS: Read data-model.md for entities
   - IF EXISTS: Read contracts/ for externally observable obligations when the plan justifies them
   - IF EXISTS: Read research.md for technical decisions
   - IF EXISTS: Read quickstart.md for test scenarios
   - IF EXISTS: Read `specs/<feature-name>/reference-context.md` for supplemental design, interaction, technical, and validation context
     - Add tasks for loading, empty, error, and validation states when required
     - Add accessibility and responsiveness tasks when required
     - Keep non-reference-driven features on the existing task generation path

4. **Validate Plan Completeness**:
   - Check if the plan.md file contains "NEED CLARIFICATION"
   - **If "NEED CLARIFICATION" is found**: STOP execution and ERROR with:

     ```
     ERROR: Cannot proceed with task generation - implementation plan requires clarification

     The implementation plan at <FEATURE_DIR>/plan.md contains unresolved "NEED CLARIFICATION" items.

     Please run @sdd-plan <feature-name> again with the required information to complete
     the implementation plan before generating tasks.
     ```

   - **If no "NEED CLARIFICATION" found**: Continue to next step

5. **Load Constitutional Standards (Context-Aware)**: Based on the tasks being generated, load relevant sections:

   **Task Type Detection**:
   - If tasks involve **testing** (test files, coverage): Load `testing,branching`
   - If tasks involve **API/endpoints** (contracts, services): Load `core,architecture,security,branching`
   - If tasks involve **infrastructure** (deployment, configs): Load `core,operations,security,branching`
   - If tasks are **mixed or general**: Load `core,testing,architecture,branching`

   **Execution**:

   ```{{SCRIPT_LANG}}
   .specify/scripts/{{SCRIPT_LANG}}/load-constitution{{SCRIPT_EXT}}
   ```

   **Purpose**: Automatically loads all constitution standards relevant to task generation.

   **Note**: Not all projects have all documents. For example:
   - CLI tools might not have contracts/
   - Simple libraries might not need data-model.md
   - Generate tasks based on what's available

6. Generate tasks following the template:
   - Use `.specify/templates/tasks-template.md` as the base
   - **IMPORTANT**: All tasks must use checkbox format `- [ ] T001 Task description`
   - Replace example tasks with actual tasks based on:
     - **Setup tasks**: Repo gaps, prerequisites, tooling, config
     - **Verification tasks [P]**: Constitution-supported automated checks or explicit manual validation steps
     - **Implementation tasks**: Workflows, rules, interfaces, states, and constraint-preservation work
     - **Integration tasks**: Cross-boundary or cross-cutting behavior only when required by the plan
     - **Design-driven tasks**: State handling, accessibility, responsiveness, and terminal behavior when `reference-context.md` requires them
     - **Polish tasks [P]**: Final verification, docs, and justified follow-up checks
   - Tasks must be executable changes or concrete verification runs; do not emit read-only review, analysis, or "lock requirements" tasks as substitutes for work

7. Task generation rules:
   - Every `AC-*`, `FR-*`, and `EC-*` item must be covered by at least one implementation or verification task
   - Use constitution-aware verification guidance; do not generate unsupported automated suites
   - If project standards allow only unit tests, do not generate contract, integration, or e2e suites
   - If no backend/API exists, do not generate endpoint, middleware, repository, or DB tasks
   - If the feature is UI-only, favor component, styling, validation, accessibility, and manual-scenario tasks
   - If `reference-context.md` identifies user-visible states, validation behavior, or source-supported rules about how entered values are treated, add implementation and verification tasks for them
   - If the spec, plan, or design artifacts define source-supported value-treatment behavior that changes validation, matching, ordering, eligibility, or user-visible output, add at least one implementation task and one verification task for that behavior
   - If the spec or plan says the feature must NOT do something, add explicit constraint-preservation tasks
   - Do not invent hidden input-handling rules from visual design alone, and do not generate tasks for behaviors that are not explicitly supported by the spec, plan, or validated reference material
   - Source tags may contain only requirement IDs from the spec or Coverage Block (`AC-*`, `FR-*`, `EC-*`); mention quickstart scenario IDs, research decisions, or contract names only in task descriptions
   - If automated verification requires tooling the repo does not yet have, create setup tasks first or keep verification manual; do not generate test-first tasks against a nonexistent harness
   - Verification tasks must either create or update a supported automated check, or run explicit manual scenarios from `quickstart.md`
   - Keep the task set minimal and immediately executable; avoid planning-only or document-reread tasks
   - Different files = can be parallel [P]
   - Same file = sequential (no [P])
   - **All tasks must start with `- [ ]` checkbox syntax**
   - Add short requirement source tags such as `[AC-001]`, `[FR-003]`, `[EC-002]`

8. Order tasks by dependencies:
   - Setup before any dependent work
   - Verification before implementation when supported by the plan and repo
   - Order from file dependencies and implementation shape, not from canned architecture sequences
   - Do not place read-only review tasks ahead of implementation; ordering must reflect real work dependencies
   - Everything before polish

9. Include parallel execution examples:
   - Group [P] tasks that can run together
   - Show actual Task agent commands

10. Create FEATURE_DIR/tasks.md with:

- Correct feature name from implementation plan
- Numbered tasks (T001, T002, etc.) with checkboxes `- [ ]`
- Clear file paths for each task
- Dependency notes
- Parallel execution guidance

11. Perform a coverage audit before returning:

- List any uncovered `AC-*`, `FR-*`, or `EC-*` items
- Refuse to finish silently if coverage gaps remain
- Keep the task set as small as possible while still fully covering the spec and plan

The tasks.md should be immediately executable - each task must be specific enough that an LLM can complete it without additional context.
