<!--
Copyright (c) Github Speckit
MIT License
-->

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[feature-name]/`
**Prerequisites**: plan.md (required), research.md, data-model.md, quickstart.md, optional `contracts/`, optional `reference-context.md`

## Execution Flow (main)

```
1. Load plan.md from feature directory
   → If not found: ERROR "No implementation plan found"
   → Extract: selected touched areas, implementation shape, verification strategy, coverage block, repo gaps, and constraints
2. Load optional design documents:
   → data-model.md: Extract entities or stateful concepts when they are relevant to implementation tasks
   → contracts/: Extract externally observable obligations when justified by the plan
   → research.md: Extract decisions and missing prerequisites → setup or implementation tasks
   → quickstart.md: Extract manual validation flows and observable outcomes
   → reference-context.md: Extract design, interaction, and visual-system signals → state, accessibility, styling, and manual visual-verification tasks when needed
   → plan.md Coverage Block: Extract `AC-*`, `FR-*`, and `EC-*` coverage obligations
3. Generate tasks by category:
   → Setup: repo gaps, missing prerequisites, required tooling or config
   → Verification: constitution-supported automated checks and explicit manual validation when automation is not justified
   → Implementation: workflows, interfaces, state handling, validation, and business-rule behavior
   → Integration: cross-boundary or cross-cutting changes only when the plan requires them
   → Design-driven: loading, empty, error, validation, accessibility, responsiveness, preserved visual-system styling, and terminal behaviors when required
   → Polish: documentation, cleanup, and final validation
4. Apply task rules:
   → Different files = mark [P] for parallel
   → Same file = sequential (no [P])
   → Follow plan-selected touched areas and implementation shape
   → Do not invent unsupported verification types or unnecessary layers
5. Number tasks sequentially (T001, T002...)
6. Generate dependency graph
7. Create parallel execution examples
8. Validate task completeness:
   → Every `AC-*`, `FR-*`, and `EC-*` covered?
   → Repo gaps handled before dependent tasks?
   → Constraints and prohibited behaviors preserved?
   → Verification strategy matches the plan and constitution?
9. Return: SUCCESS (tasks ready for execution)
```

## Format: `[ID] [P?] [Source Tags] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Source Tags]**: Requirement IDs only, such as `[AC-001]`, `[FR-003]`, `[EC-002]`
- Do not use quickstart IDs, research decision IDs, contract names, or document-section labels as source tags; mention those only in descriptions when helpful
- Include exact file paths in descriptions

## Path Guidance

- Use the source structure defined in `plan.md`.
- Replace the illustrative placeholders below with exact file paths from the feature plan.
- Do not assume a specific repository layout unless it is explicitly defined in `plan.md`.
- Prefer feature-local or repo-relative paths; reject foreign absolute paths in persistent artifacts.

## Phase 3.1: Setup

- [ ] T001 [FR-001] Address required repo gap or prerequisite for [tooling-or-config] in [file-or-folder]
- [ ] T002 [FR-001] Create or confirm only the files and folders justified in plan.md
- [ ] T003 [P] [FR-001] Align shared tooling, fixtures, or configuration in [tooling-file]

## Phase 3.2: Verification First

**CRITICAL: Use the verification strategy selected in plan.md. Prefer automated checks when supported; otherwise create explicit manual validation tasks tied to quickstart.md.**

Verification tasks must be executable: create or update a supported verification artifact, or run a concrete manual scenario from `quickstart.md`. Do not emit read-only review or analysis tasks as placeholders.

- [ ] T004 [P] [AC-001] Create or run the justified verification for [workflow-or-outcome] in [test-file-or-quickstart-step]
- [ ] T005 [P] [EC-001] Create or run verification for [scenario] in [test-file-or-quickstart-step] (if applicable)
- [ ] T006 [P] [FR-001] Create or run verification for [externally observable obligation] in [verification-file-or-quickstart-step] (if applicable)

## Phase 3.3: Implementation

- [ ] T007 [P] [FR-001] Implement [workflow-state-or-rule] in [source-file]
- [ ] T008 [P] [AC-001] Implement the user-visible surface or interaction for [screen-view-command-or-output] in [source-file] (if applicable)
- [ ] T009 [FR-001] Implement shared validation, error handling, or state transitions for [workflow] in [source-file]
- [ ] T010 [EC-001] Implement safeguards for [constraint-or-prohibited-behavior] in [source-file]

## Phase 3.4: Integration

- [ ] T011 [FR-001] Connect [integration-or-dependency] in [source-file] (if applicable)
- [ ] T012 [FR-001] Implement required cross-boundary, observability, or audit behavior in [source-file] (if applicable)
- [ ] T013 [AC-001] Implement accessibility, responsiveness, preserved visual-system styling, or terminal-behavior handling for [surface] in [source-file] (if applicable)

## Phase 3.5: Polish

- [ ] T014 [P] [FR-001] Add supporting verification for [module-or-surface] in [verification-file] when justified by the plan
- [ ] T015 [P] [FR-001] Update user-facing or developer documentation in [docs-file]
- [ ] T016 [AC-001] Run quickstart and manual validation from quickstart.md

## Dependencies

- Setup tasks before any task that depends on missing prerequisites
- Verification tasks (T004-T006) before dependent implementation tasks when the selected strategy supports it
- Implementation tasks must follow actual file dependencies and the chosen implementation shape
- Constraint-preservation and design-driven state tasks block final validation when the spec, plan, or `reference-context.md` requires them
- Preserved visual-system obligations from `reference-context.md` must be implemented before final manual validation
- Implementation before polish (T014-T016)

## Parallel Example

```
# Launch independent verification tasks together:
Task: "[AC-001] Implement automated or manual verification for [workflow-or-outcome] in [test-file-or-quickstart-step]"
Task: "[EC-001] Verify error, edge, validation, accessibility, or visual-system behavior for [scenario] in [test-file-or-quickstart-step]"
Task: "[FR-001] Verify any externally observable obligation from a justified contract or interface artifact in [verification-file-or-step]"
```

## Notes

- [P] tasks = different files, no dependencies
- Use requirement source tags sparingly and only with requirement IDs
- Do not invent unsupported automated suites; use manual validation tasks when the plan requires them
- Avoid: vague tasks, same file conflicts, paths that are not justified by the plan

## Task Sources

- Scope boundaries and prohibited behaviors from `spec.md`
- Business rules and functional requirements from `spec.md`
- Coverage Block and repo-reality findings from `plan.md`
- Design artifacts from `data-model.md`, `contracts/`, and `research.md` when they exist
- Visible states, interaction cues, and preserved visual-system obligations from `reference-context.md` when present

## Verification Strategy

- Use constitution guidance and repo support to decide automated tests versus manual checks
- Do not invent contract, integration, e2e, or other suites that the repo and plan do not justify
- If automation is not justified, create explicit manual verification tasks tied to `quickstart.md`
- Keep repo-gap detection prompt-driven in the first pass; do not assume richer helper-script metadata exists

## Task Generation Rules

_Applied during main() execution_

1. **From Coverage And Requirements**:
   - Every `AC-*`, `FR-*`, and `EC-*` item must appear in at least one implementation or verification task
   - Keep source tags short and limited to requirement IDs
   - Do not use quickstart IDs, research decisions, or contract names as source tags
2. **From Design Artifacts**:
   - Each justified contract or interface artifact → verification or implementation task when it adds observable obligations
   - Each source-supported rule about how user-entered content is treated when it affects validation, matching, ordering, eligibility, or displayed output → at least one implementation task and one verification task
   - Each entity or stateful concept → implementation task only when the feature actually requires it
3. **From Repo Reality Gaps**:
   - Missing tooling, config, folders, or fixtures → setup tasks before dependent work
   - File paths must come from the plan's selected touched areas, not canned layouts
   - If automated verification depends on missing tooling, add setup tasks first or keep verification manual
4. **From Scope Boundaries And Reference Context**:
   - If `reference-context.md` exists, add tasks for loading, empty, error, validation, accessibility, responsiveness, preserved visual-system styling, terminal behaviors, and any source-supported value-treatment behavior when required
   - If `reference-context.md` preserves visual-system or style-token obligations, add at least one explicit implementation task and one manual visual-verification task for them; name the specific values from the reference in both tasks, including positional and sizing values (for example width, height, min/max constraints, padding, gap, alignment, order, and offsets) — reducing obligations to generic language is a defect
   - If the spec or plan says the feature must NOT do something, add explicit implementation or validation tasks that preserve that constraint
   - Do not infer hidden input-handling rules from visual design alone; task only behaviors that are explicitly supported by the spec, plan, or validated reference material
5. **Ordering**:
   - Setup → Verification → Implementation → Integration → Polish
   - Order work from actual dependencies and implementation shape, not from default architecture sequences
   - Do not emit read-only review, analysis, or requirement-locking tasks; tasks must correspond to concrete work or concrete validation runs

## Validation Checklist

_GATE: Checked by main() before returning_

- [ ] Every `AC-*`, `FR-*`, and `EC-*` item is covered by at least one task
- [ ] Verification strategy matches the constitution and plan
- [ ] Unsupported automated suites were not invented
- [ ] Repo gaps are addressed before dependent tasks
- [ ] Constraint-preservation tasks exist when the spec or plan forbids behavior
- [ ] Design-driven states and visual-system obligations covered when `reference-context.md` exists
- [ ] Paths follow the structure defined in `plan.md`
- [ ] Parallel tasks truly independent
- [ ] Each task specifies exact file path
- [ ] No task modifies same file as another [P] task
- [ ] Source tags use requirement IDs only
- [ ] No task is read-only, planning-only, or non-executable
