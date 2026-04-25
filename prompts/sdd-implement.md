<!--
Copyright (c) Github Speckit
MIT License
-->

# Implement

Execute the implementation plan by progressively executing all tasks defined in tasks.md

## Usage

- `@sdd-implement <feature-name>` - Execute implementation for specified feature

**Note**: The `<feature-name>` parameter is **REQUIRED**. If not provided, an error will be generated.

---

## Execute Implementation

The user **MUST** provide a feature name. This parameter is compulsory.

### Steps

1. **Validate feature name parameter (Deterministic Algorithm)**:

   **Step 1.1**: Check parameter existence
   - IF no feature name provided → RETURN ERROR "Feature name is required. Usage: @sdd-implement <feature-name>"

   **Step 1.2**: Validate feature directory
   - IF `specs/<feature-name>` does not exist → RETURN ERROR "Feature '<feature-name>' not found in specs/. Available features: [list directory names from specs/]"
   - IF `specs/<feature-name>` is not readable → RETURN ERROR "Cannot access feature directory: specs/<feature-name>"

   **Step 1.3**: Set environment
   - SET FEATURE_NAME = <feature-name>
   - CONTINUE to step 2

2. Run `.specify/scripts/{{SCRIPT_LANG}}/check-implementation-prerequisites{{SCRIPT_EXT}} <feature-name> --json` from repo root and parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be absolute.

3. Load and analyze the implementation context:
   - **REQUIRED**: Read tasks.md for the complete task list and execution plan
   - **REQUIRED**: Read plan.md for selected touched areas, implementation shape, verification strategy, repo constraints, and prohibited behaviors
   - **IF EXISTS**: Read data-model.md for entities, stateful concepts, or schemas when the task plan requires them
   - **IF EXISTS**: Read contracts/ for justified contract or interface artifacts and their externally observable obligations
   - **IF EXISTS**: Read research.md for technical decisions and constraints
   - **IF EXISTS**: Read quickstart.md for manual validation scenarios and observable outcomes
   - **IF EXISTS**: Read reference-context.md for supplemental design, interaction, accessibility, and validation signals that affect implementation or verification

4. **Load Constitutional Standards (Task-Shaped Application)**: Analyze the current task and apply the relevant sections without assuming a default backend architecture.

   **Task Shape Detection Priority (First Match Wins)**:
   1. If implementing **verification artifacts** (`*.test.*`, `*.spec.*`, `tests/`, `__tests__/`): Load `testing,branching`
   2. If implementing **validation, permissions, or sensitive-data handling** (`auth*`, `security*`, `validation*`, `permissions*`, `sanit*`): Load `core,security,branching`
   3. If implementing **user-facing interaction or accessibility surfaces** (`components/`, `views/`, `pages/`, `screens/`, `ui/`, style assets): Load `core,user-interface,branching`
   4. If implementing **external interfaces or cross-boundary obligations** (`contracts/`, `events/`, `clients/`, `adapters/`, `routes/`): Load `core,architecture,security,branching`
   5. If implementing **workflow, state, or business-rule coordination** (`domain/`, `logic/`, `use-cases/`, `workflows/`, `flows/`, `lib/`): Load `core,architecture,observability,branching`
   6. If implementing **data/state structures or schemas** (`schemas/`, `types/`, `state/`, `records/`, `shared-data/`): Load `core,architecture,branching`
   7. If implementing **config or deployment surfaces** (`*.yml`, `*.yaml`, `Dockerfile`, `*.json` config): Load `operations,security,branching`
   8. If implementing **logging, monitoring, or metrics surfaces** (`logger*`, `monitor*`, `metrics*`, telemetry files): Load `observability,branching`
   9. **DEFAULT**: Load `core,branching`

   **Execution**:

   ```{{SCRIPT_LANG}}
   .specify/scripts/{{SCRIPT_LANG}}/load-constitution{{SCRIPT_EXT}}
   ```

   **Purpose**: Automatically loads all constitution standards for implementation. Apply the relevant sections according to task shape, not according to a fixed service/API/database architecture.

   **Note**: Constitution is loaded once at the start of implementation.

5. Parse tasks.md structure and extract:
   - **Task phases**: Setup, Verification, Implementation, Integration, Polish
   - **Task dependencies**: Sequential vs parallel execution rules
   - **Task details**: ID, description, file paths, parallel markers [P]
   - **Execution flow**: Order and dependency requirements

6. Execute implementation following the task plan:

   **Task Execution Decision Matrix**:
   - IF (Task A [P] AND Task B [P] AND same_file(A,B)) → Execute A THEN B (sequential override)
   - IF (Task A requires Task B AND Task B [P]) → Wait for B completion before A
   - IF (Task fails AND has_dependents) → Halt phase, report blocking tasks
   - IF (Parallel task fails) → Continue others, aggregate failures at phase end

   **Execution Rules**:
   - **Phase-by-phase execution**: Complete each phase before moving to the next
   - **Respect dependencies**: Run sequential tasks in order, parallel tasks [P] can run together
   - **Follow the plan-selected verification strategy**: Execute verification tasks before dependent implementation tasks when the repo and task plan support that order
   - **File-based coordination**: Tasks affecting the same files must run sequentially
   - **Validation checkpoints**: Verify each phase completion before proceeding
   - **Artifact-driven execution**: Treat `contracts/` as an optional generic artifact location when present; do not assume API endpoints are the default contract shape
   - **Repo-driven execution**: Follow the chosen task descriptions and touched files; do not invent model/service/endpoint/database layers that the plan does not justify
   - **Apply Constitutional Standards**: For each implementation, follow:
     - **Coding standards**: Error handling, logging patterns, validation (from core)
       - **Task-shape patterns**: Interface, workflow, state, or user-interface structure when applicable (from architecture and user-interface)
     - **Testing requirements**: Test organization, coverage, mocking (from testing)
       - **Security practices**: Input validation, secrets management, permissions, privacy (from security)
     - **Observability**: Structured logging, correlation IDs, metrics (from observability)

7. Implementation execution rules:
   - **Setup first**: Initialize or adjust only the prerequisites, dependencies, and configuration that the task plan requires
   - **Verification before implementation**: When the task plan and repo support it, create or run the relevant verification before changing dependent implementation files
   - **Implementation work**: Implement workflows, interfaces, states, transformations, validations, and user-visible surfaces described by the task plan
   - **Integration work**: Connect cross-boundary behavior, observability, accessibility, responsive behavior, or external systems only when the task plan requires them
   - **Polish and validation**: Run supported automated checks, execute manual quickstart scenarios when needed, and update justified documentation

8. Progress tracking and error handling:

   **Task Update State Machine**:
   1. EXECUTING → Mark task in progress
   2. COMPLETED → Attempt file update (max 3 retries, 1s delay)
   3. UPDATE_SUCCESS → Move to next task
   4. UPDATE_FAILED → Log warning, add to completion_report_queue
   5. PHASE_END → Batch update any failed updates from queue

   **Error Handling Rules**:
   - Report progress after each completed task
   - **IMMEDIATELY after task completion**: Update tasks.md to mark task as [X]
   - **Verify update**: Confirm the task file was successfully modified
   - **Atomic updates**: Update one task at a time to avoid file corruption
   - Halt execution if any non-parallel task fails
   - For parallel tasks [P], continue with successful tasks, report failed ones
   - **Task update failure handling**: If task marking fails, log warning but continue implementation
   - Provide clear error messages with context for debugging
   - Suggest next steps if implementation cannot proceed
   - **IMPORTANT** For completed tasks, make sure to mark the task off as [X] in the tasks file.
   - **Backup mechanism**: If direct file update fails, provide explicit instruction to user about which tasks were completed

9. Completion validation:
   - **Final task audit**: Compare completed work against tasks.md to identify any unmarked completed tasks
   - **Batch update missed tasks**: If any completed tasks aren't marked [X], update them all at once
   - Verify all required tasks are completed
   - Check that implemented features match the original specification
   - Validate that tests pass and coverage meets requirements
   - Confirm the implementation follows the technical plan
   - **Generate completion report**: List all tasks with their final status (completed [X] vs pending [ ])
   - Report final status with summary of completed work

Note: This command assumes a complete task breakdown exists in sdd-tasks.md. If tasks are incomplete or missing, suggest running the sdd-tasks prompt first to regenerate the task list.
