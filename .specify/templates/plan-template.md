<!--
Copyright (c) Github Speckit
MIT License
-->

# Implementation Plan: [FEATURE]

**Branch**: `[feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[feature-name]/spec.md` and optional supplementary context from `/specs/[feature-name]/reference-context.md`

## Execution Flow (/plan command scope)

```
1. Load feature spec from Input path
   → If not found: ERROR "No feature spec at {path}"
2. Fill Summary, Technical Context, and Repo Reality Check (scan for NEEDS CLARIFICATION)
   → Use constitution memory, repository context, research, and optional reference-context.md for implementation details
   → Treat preserved visual-system and style-token signals in reference-context.md as explicit design obligations when present
   → Identify existing entry points, touched areas, verification tooling, and missing prerequisites from the current repo
   → Use only current repo-root paths, commands, and detected tooling; do not reuse assumptions from earlier runs or other workspaces
   → Reject any foreign absolute path in persistent artifacts; use current workspace-derived paths only when an absolute path is truly required
   → State the smallest plausible implementation shape before proposing new structure
   → If `spec.md` indicates reference-derived input but `reference-context.md` is missing: ERROR "Missing required reference-context.md for reference-driven feature"
3. Fill the Constitution Check section based on the content of the constitution document.
4. Evaluate Constitution Check section below
   → If violations exist: Document in Complexity Tracking
   → If no justification possible: ERROR "Simplify approach first"
   → Update Progress Tracking: Initial Constitution Check
5. Execute Phase 0 → research.md
   → If NEEDS CLARIFICATION remain: ERROR "Resolve unknowns"
6. Execute Phase 1 → data-model.md, quickstart.md, and only the smallest justified structured contract artifacts inside specs/[feature]/
7. Re-evaluate Constitution Check section
   → If new violations: Refactor design, return to Phase 1
   → Update Progress Tracking: Post-Design Constitution Check
8. Plan Phase 2 → Describe task generation approach (DO NOT create tasks.md)
9. STOP - Ready for /tasks command
```

**IMPORTANT**: The /plan command STOPS at step 9. It creates planning artifacts and a task-generation approach, but it does not create implementation-side files outside the feature folder.

- /tasks command creates tasks.md
- Implementation execution happens later (manual or via tools)

## Summary

- **User-visible outcomes**: [Primary outcome users should observe]
- **Implementation constraints**: [Repo, constitution, or operational constraints that shape the solution]
- **Prohibited behaviors**: [What the implementation must avoid]

## Minimal Change Hypothesis

[State the lightest justified implementation shape before adding files, layers, or abstractions]

## Technical Context

**Runtime / Language Context**: [What the repo already uses, or NEEDS CLARIFICATION]  
**Existing Dependencies / Boundaries**: [Libraries, services, packages, modules, or boundaries already present in the repo]  
**Storage / External Systems**: [Datastores, external APIs, files, queues, or N/A]  
**Verification Strategy**: [Allowed by constitution and supported by the repo today, or NEEDS CLARIFICATION]  
**Operational Constraints**: [Security, compliance, latency, deployment, offline, accessibility, or support constraints]  
**Scale / Performance Constraints**: [Expected scale, throughput, volume, or responsiveness targets]

## Repo Reality Check

**Current Entry Points**: [Existing app entry points, commands, routes, screens, jobs, or modules this feature will touch]  
**Existing Layout Patterns**: [Patterns already established in the repo that this work should follow]  
**Existing Verification / Tooling**: [What testing, linting, validation, or manual-check workflows already exist]  
**Missing Prerequisites**: [Tooling, config, folders, fixtures, or setup gaps that must be addressed before or during implementation]

## Constitution Check

_GATE: Must pass before Phase 0 research. Re-check after Phase 1 design._

[Gates determined based on constitution file]

## Project Structure

### Documentation (this feature)

```
specs/[feature]/
├── plan.md              # This file (/plan command output)
├── research.md          # Phase 0 output (/plan command)
├── data-model.md        # Phase 1 output (/plan command)
├── quickstart.md        # Phase 1 output (/plan command)
├── contracts/           # Optional Phase 1 output when a structured contract artifact is justified
└── tasks.md             # Phase 2 output (/tasks command - NOT created by /plan)
```

All /plan outputs stay inside `specs/[feature]/`.

### Repository Surface

**Implementation Shape Decision**: [UI interaction, service/API feature, library/helper change, data-processing workflow, multi-surface feature, or another justified shape]

Use the example shapes illustratively, not as a fixed architecture menu.

Do not invent `models`, `services`, `api`, `repository`, `middleware`, or similar layers unless the repo or feature explicitly requires them.

**Existing Touched Areas**:

- [Existing file, folder, or module expected to change]
- [Existing file, folder, or module expected to change]

**Proposed New Files / Folders (only if justified)**:

- [New path]: [Why it is needed]

**Rejected Structure Additions**:

- [Layer, folder, or abstraction not added]: [Why it is unnecessary for this feature]

## Phase 0: Outline & Research

1. **Extract unknowns from Technical Context** above:
   - For each NEEDS CLARIFICATION → research task
   - For each dependency → best practices task
   - For each integration → patterns task
   - For each missing prerequisite → confirm whether it is required now or can be deferred
   - If `reference-context.md` exists: Extract design, interaction, and visual-system signals that affect research or implementation choices

2. **Generate and dispatch research agents**:

   ```
   For each unknown in Technical Context:
     Task: "Research {unknown} for {feature context}"
   For each technology choice:
     Task: "Find best practices for {tech} in {domain}"
   ```

3. **Consolidate findings** in `research.md` using format:
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

**Output**: research.md with all NEEDS CLARIFICATION resolved

## Phase 1: Design & Contracts

_Prerequisites: research.md complete_

1. **Extract entities from feature spec** → `data-model.md`:
   - Entity name, fields, relationships
   - Validation rules from requirements
   - State transitions if applicable

2. **Generate the smallest justified design artifact** for externally observable obligations:
   - Choose the lightest artifact that fits the feature shape (for example interaction contract, API contract, event contract, file/schema contract, or no separate contract artifact if none is justified)
   - Prefer a structured artifact format when multiple observable branches, preconditions, terminal behaviors, or source-supported rules about how entered values are treated must be preserved
   - Preserve any source-supported rule about how user-entered content is treated when it affects validation, matching, ordering, eligibility, or displayed output. Express the effect in technology-agnostic, observable terms
   - Do not add behaviors that are not required by the spec, validated reference context, or constitution constraints, and do not infer hidden input-handling rules from visual design alone
   - Output contract artifacts to `/contracts/` only when they add clear planning value

3. **Define verification expectations** from constitution and repo tooling first:
   - Identify what the repo can already verify automatically and what must be validated manually
   - If required tooling is missing, record the gap instead of assuming it exists
   - Do not assume test-first or harness-specific verification unless the repo already supports it or setup work is explicitly justified
   - If `reference-context.md` preserves visual-system or style-token obligations, add explicit manual visual-verification expectations that name the specific values to be verified, including positional and sizing values (for example width, height, min/max constraints, padding, gap, alignment, order, and offsets); do not reduce preserved reference values to generic layout descriptions, and do not lose any value
   - Capture verification expectations in `quickstart.md`, the Coverage Block, and task-planning guidance
   - Do not create implementation-side test files during /plan

4. **Extract test scenarios** from user stories and optional reference context:
   - Map each acceptance criterion, functional requirement, and edge case to a verification path
   - User-visible states, validation cues, responsive expectations, visual-system obligations, and any source-supported rules about how entered values are treated from `spec.md` or `reference-context.md` → quickstart and verification scenarios when present
   - Quickstart = story validation steps plus relevant state, validation, accessibility, and terminal-behavior coverage

5. **Maintain the Coverage Block in this plan**:
   - Map each `AC-*`, `FR-*`, and `EC-*` item to research decisions, design artifacts, quickstart scenarios, and expected task coverage
   - Keep the mapping lightweight inside `plan.md`; do not create a separate mandatory traceability artifact

**Output**: data-model.md, quickstart.md, and any justified artifacts in `/contracts/`

## Coverage Block

| Requirement | Research / Decision | Design Artifact | Quickstart / Verification | Expected Task Coverage |
| ----------- | ------------------- | --------------- | ------------------------- | ---------------------- |
| AC-001      | [decision]          | [artifact/none] | [scenario]                | [task source]          |
| FR-001      | [decision]          | [artifact/none] | [scenario]                | [task source]          |
| EC-001      | [decision]          | [artifact/none] | [scenario]                | [task source]          |

## Phase 2: Task Planning Approach

_This section describes what the /tasks command will do - DO NOT execute during /plan_

**Task Generation Strategy**:

- Load `.specify/templates/tasks-template.md` as base
- Generate tasks from Phase 1 design docs, the Coverage Block, and repo-gap findings
- Choose verification tasks from constitution-approved and repo-supported strategies first
- Add setup tasks for missing prerequisites before relying on them
- Ensure each acceptance criterion, functional requirement, and edge case is covered by at least one implementation or validation task
- Target existing touched areas first; add new structure only when justified in the plan

**Ordering Strategy**:

- Setup before verification when repo gaps block execution
- Verification before implementation when the repo and constitution support it; otherwise add explicit manual validation tasks tied to `quickstart.md`
- Order work by actual file dependencies and the chosen implementation shape, not by canned architecture sequences
- Mark [P] only for truly independent files

**Estimated Output**: The smallest executable task set that fully covers the spec and plan in tasks.md

**IMPORTANT**: This phase is executed by the /tasks command, NOT by /plan

## Phase 3+: Future Implementation

_These phases are beyond the scope of the /plan command_

**Phase 3**: Task execution (/tasks command creates tasks.md)  
**Phase 4**: Implementation (execute tasks.md following constitutional principles)  
**Phase 5**: Validation (run tests, execute quickstart.md, performance validation)

## Complexity Tracking

_Fill ONLY if Constitution Check has violations that must be justified_

| Violation                  | Why Needed         | Simpler Alternative Rejected Because |
| -------------------------- | ------------------ | ------------------------------------ |
| [e.g., 4th project]        | [current need]     | [why 3 projects insufficient]        |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient]  |

## Progress Tracking

_This checklist is updated during execution flow_

**Phase Status**:

- [ ] Phase 0: Research complete (/plan command)
- [ ] Phase 1: Design complete (/plan command)
- [ ] Phase 2: Task planning complete (/plan command - describe approach only)
- [ ] Phase 3: Tasks generated (/tasks command)
- [ ] Phase 4: Implementation complete
- [ ] Phase 5: Validation passed

During `/plan`, only Phases 0-2 may be checked. Leave Phase 3 and later unchecked.

**Gate Status**:

- [ ] Initial Constitution Check: PASS
- [ ] Post-Design Constitution Check: PASS
- [ ] All NEEDS CLARIFICATION resolved
- [ ] Complexity deviations documented

---

_Based on Constitution - See `.specify/memory/constitution/`_
