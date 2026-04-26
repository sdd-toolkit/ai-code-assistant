<!--
Copyright (c) Github Speckit
MIT License
-->

Execute the implementation planning workflow using the plan template to generate design artifacts.

1. Run `.specify/scripts/bash/setup-plan.sh --json` from the repo root and parse JSON for FEATURE_SPEC, IMPL_PLAN, SPECS_DIR, BRANCH. All future file paths must be absolute.

2. Read and analyze the feature specification to understand:
   - The feature requirements and user stories
   - Functional and non-functional requirements
   - Success criteria and acceptance criteria
   - Business constraints and dependencies described in the spec
   - **Check for `reference-context.md` in the feature directory**:
     - If present: Use its design, visual-system, interaction, technical, and validation signals as top-priority supplemental planning input
     - Keep `spec.md` as the business-only source of user intent and requirements
     - Treat preserved visual-system and style-token signals as explicit planning obligations when present
     - Use constitution memory as the source of technical standards, verification guidance, and stack-specific constraints
   - Perform an explicit repo-structure and tooling check before making artifact decisions
   - Derive all repo paths, commands, tooling claims, and touched areas from the current repository state and script-returned paths only

2.1. **Enforce Reference Context Completeness**:

- If `spec.md` indicates reference-derived input (for example reference metadata or reference-context-style analysis cues) but `reference-context.md` is missing in the feature directory: STOP and return an error instead of continuing planning.

3. **Load Constitutional Standards**: Execute `.specify/scripts/bash/load-constitution.sh` to auto-load all constitution sections:

   ```bash
   .specify/scripts/bash/load-constitution.sh
   ```

   **Purpose**: Automatically loads all modular constitution sections from `.specify/memory/constitution/` (or templates if not initialized):
   - **core**: Technology stack, coding standards, linting requirements
   - **architecture**: Architectural principles, design patterns, API design
   - **testing**: Testing strategies, coverage requirements, test organization
   - **security**: Security standards and best practices
   - **observability**: Logging, monitoring, and debugging standards
   - **user-interface**: UI/UX standards (if applicable)
   - **branching**: Git workflow and commit standards (from git-workflow.yaml)

   **Note**: All sections are loaded automatically - no need to specify which ones.

4. Execute the implementation plan template:
   - Load `.specify/templates/plan-template.md` (already copied to IMPL_PLAN path)
   - Set Input path to FEATURE_SPEC
   - Run the Execution Flow (main) function steps 1-9
   - The template is self-contained and executable
   - Follow error handling and gate checks as specified
   - Reject persistent artifact paths that point outside the active workspace or feature directory; if a foreign absolute path appears, replace it with the current workspace-derived path or omit it
   - Start with repo reality, existing touched areas, and the minimal change hypothesis before proposing new structure
   - Derive verification strategy from constitution and existing repo tooling before selecting artifacts
   - Surface missing prerequisites discovered in the repo so they can become setup tasks later
   - Reject unnecessary layers when the feature is UI-only, prototype-only, or otherwise narrow in scope
   - Prefer the lightest structured contract artifact that still preserves observable obligations; when multiple branches, preconditions, or terminal outcomes exist, prefer structure over loose prose
   - Do not add derived behavior unless it is required by the spec, validated reference context, or constitution; if a derived constraint is required, record it explicitly in research and design artifacts
   - If automated verification would require tooling the repo does not currently have, record the gap and keep the plan on supported verification paths
   - Let the template guide artifact generation in $SPECS_DIR:
     - Phase 0 generates research.md
       - Phase 1 generates data-model.md and quickstart.md, plus only the smallest justified artifacts under `contracts/` when a structured contract artifact is actually needed
       - Phase 2 describes the task-generation approach (does not create tasks.md)
   - If `reference-context.md` exists, use it to enrich research, design, and quickstart outputs without changing the normal flow for features that do not have design references
   - Preserve validated visual-system and style-token signals from `reference-context.md` as explicit, named design obligations and manual visual-verification cues; every specific value must appear by name in planning artifacts — including positional and sizing values (for example width, height, min/max constraints, padding, gap, alignment, order, and offsets). Do not reduce reference values to vague layout summaries or generic descriptions, and do not lose any value
   - Ensure reference-context-driven user-visible states, validation cues, accessibility expectations, responsive expectations, visual-system obligations, and terminal behaviors appear in `quickstart.md` and task-planning guidance when relevant
   - Keep repo-structure and gap detection prompt-driven in this first pass; do not require helper-script metadata beyond the current returned paths
   - Incorporate user-provided details from arguments into Technical Context
   - Maintain a lightweight Coverage Block in `plan.md` mapping `AC-*`, `FR-*`, and `EC-*` items to design and verification outputs
   - Keep Progress Tracking aligned with /plan scope only; leave Phase 3 and later unchecked during /plan
   - Update Progress Tracking as you complete each phase

5. Verify execution completed:
   - Check Progress Tracking shows the planning phases are complete
   - Ensure all required planning artifacts were generated inside the feature folder
   - Confirm no ERROR states in execution

6. Report results with branch name, file paths, and generated artifacts.

Use absolute paths with the repository root for all file operations to avoid path issues.
