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
   - Any technical constraints or dependencies mentioned
   - **Check for Reference Context section**:
     - If present: Use the summarized insights (architecture, patterns, code examples, configuration, testing approaches)
     - This provides pre-analyzed context without re-loading files
     - Reference the "Key Insights" and "Referenced Files" for design decisions and consistency

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
   - Let the template guide artifact generation in $SPECS_DIR:
     - Phase 0 generates research.md
     - Phase 1 generates data-model.md, contracts/, quickstart.md
     - Phase 2 generates tasks.md
   - Incorporate user-provided details from arguments into Technical Context
   - Update Progress Tracking as you complete each phase

5. Verify execution completed:
   - Check Progress Tracking shows all phases complete
   - Ensure all required artifacts were generated
   - Confirm no ERROR states in execution

6. Report results with branch name, file paths, and generated artifacts.

Use absolute paths with the repository root for all file operations to avoid path issues.
