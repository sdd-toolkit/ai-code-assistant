<!--
Copyright (c) Github Speckit
MIT License
-->

Execute the implementation plan by processing and executing all tasks defined in tasks.md

1. Run `.specify/scripts/bash/check-implementation-prerequisites.sh --json --require-tasks --include-tasks` from repo root and parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be absolute.

2. Load and analyze the implementation context:
   - **REQUIRED**: Read tasks.md for the complete task list and execution plan
   - **REQUIRED**: Read plan.md for selected touched areas, implementation shape, verification strategy, repo constraints, and prohibited behaviors
   - **IF EXISTS**: Read data-model.md for entities, stateful concepts, or schemas when the task plan requires them
   - **IF EXISTS**: Read contracts/ for justified contract or interface artifacts and their externally observable obligations
   - **IF EXISTS**: Read research.md for technical decisions and constraints
   - **IF EXISTS**: Read quickstart.md for manual validation scenarios and observable outcomes
   - **IF EXISTS**: Read reference-context.md for supplemental design, visual-system, interaction, accessibility, and validation signals that affect implementation or verification

3. Parse tasks.md structure and extract:
   - **Task phases**: Setup, Verification, Implementation, Integration, Polish
   - **Task dependencies**: Sequential vs parallel execution rules
   - **Task details**: ID, description, file paths, parallel markers [P]
   - **Execution flow**: Order and dependency requirements

4. Execute implementation following the task plan:
   - **Phase-by-phase execution**: Complete each phase before moving to the next
   - **Respect dependencies**: Run sequential tasks in order, parallel tasks [P] can run together
   - **Follow the plan-selected verification strategy**: Execute verification tasks before dependent implementation tasks when the repo and task plan support that order
   - **File-based coordination**: Tasks affecting the same files must run sequentially
   - **Validation checkpoints**: Verify each phase completion before proceeding
   - **Artifact-driven execution**: Treat `contracts/` as an optional generic artifact location when present; do not assume API endpoints are the default contract shape
   - **Repo-driven execution**: Follow the chosen task descriptions and touched files; do not invent model/service/endpoint/database layers that the plan does not justify
   - **Constitution application**: Apply constitution sections according to task shape such as verification, security-sensitive behavior, user-interface work, interfaces, workflows, state management, observability, or operations

5. Implementation execution rules:
   - **Setup first**: Initialize or adjust only the prerequisites, dependencies, and configuration that the task plan requires
   - **Verification before implementation**: When the task plan and repo support it, create or run the relevant verification before changing dependent implementation files
   - **Implementation work**: Implement workflows, interfaces, states, transformations, validations, user-visible surfaces, and preserved visual-system obligations described by the task plan
   - **Integration work**: Connect cross-boundary behavior, observability, accessibility, responsive behavior, preserved visual-system styling, or external systems only when the task plan requires them
   - **Polish and validation**: Run supported automated checks, execute manual quickstart scenarios when needed, and update justified documentation

6. Progress tracking and error handling:
   - Report progress after each completed task
   - Halt execution if any non-parallel task fails
   - For parallel tasks [P], continue with successful tasks, report failed ones
   - Provide clear error messages with context for debugging
   - Suggest next steps if implementation cannot proceed
   - **IMPORTANT** For completed tasks, make sure to mark the task off as [X] in the tasks file.

7. Completion validation:
   - Verify all required tasks are completed
   - Check that implemented features match the original specification
   - Validate that tests pass and coverage meets requirements
   - Confirm the implementation follows the technical plan
   - Report final status with summary of completed work

Note: This command assumes a complete task breakdown exists in sdd-tasks.md. If tasks are incomplete or missing, suggest running the sdd-tasks prompt first to regenerate the task list.
