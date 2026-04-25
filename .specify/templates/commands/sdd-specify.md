<!--
Copyright (c) Github Speckit
MIT License
-->

# Specify

Create or update the feature specification from a natural language feature description.

## Usage

- `@sdd-specify <feature_description>` - Create a new feature specification (defaults to `feat` type)
- `@sdd-specify <feature_description> -type <branch_type>` - Create specification with specific type prefix
- `@sdd-specify <feature_description> -ref <reference_folder>` - Create specification with reference context
- `@sdd-specify <feature_description> -type <branch_type> -ref <reference_folder>` - Create specification with both type and reference

---

## Create Feature Specification

The user will provide a feature description (first text after the command), optionally a branch type via `-type` (defaults to `feat`), and optionally a reference folder via `-ref` for additional context.

### Validation Requirements

**CRITICAL**: Validate that required arguments are provided and that the branch type is valid.

### Steps

0. **Parse and Validate Arguments**: Before proceeding, parse the user input and validate:

   **Feature Description Extraction**:
   - **REQUIRED**: Extract the feature description from the first text after `@sdd-specify` (before any flags)
   - All text before the first `-` flag (if any) is the feature description
   - **STOP AND ERROR**: If no feature description is provided, immediately stop processing and return an error message

   **Branch Type Validation**:
   - **Default**: If `-type` is not provided, default to `feat`
   - **REQUIRED**: If `-type` is provided, it MUST be one of: `feat`, `fix`, `chore`, `refactor`, `test`, `docs`, `hotfix`, `maintenance`
   - **STOP AND ERROR**: If an invalid type is provided, immediately stop processing and inform the user of valid types

   **ERROR HANDLING**:

   If feature description is missing:

   ```
   ERROR: Missing required feature description

   The feature description is required.

   Usage:
   @sdd-specify <description>
   @sdd-specify <description> -type <type>
   @sdd-specify <description> -ref <reference_folder>

   Examples:
   @sdd-specify user authentication system
   @sdd-specify payment timeout issue -type fix
   @sdd-specify user authentication system -ref auth-patterns
   ```

   If `-type` has an invalid value:

   ```
   ERROR: Invalid branch type provided

   Branch type must be one of: feat, fix, chore, refactor, test, docs, hotfix, maintenance
   Default: feat (if -type is not specified)

   Examples:
   - @sdd-specify user authentication system -type feat
   - @sdd-specify payment timeout issue -type fix
   - @sdd-specify api documentation update -type docs

   Please provide a valid branch type or omit -type to use the default (feat).
   ```

   Do not proceed with any further steps.

0.1. **Construct Full Feature Description**: Combine the type prefix with the feature description to create the full description:

- Format: `<type>/<feature_description>`
- Example: If `-type fix` and feature description is "payment timeout issue", construct `fix/payment timeout issue`
- If `-type` was not provided, use `feat/<feature_description>`

  0.2. **Summarize the feature description**: Create a concise summary of the full feature description (including type prefix) that is 80 characters or less. This summary should capture the essential meaning while preserving the required type prefix and being suitable for use as a directory name. Preserve key technical terms and maintain clarity.

1. Run the script `.specify/scripts/bash/create-new-feature.sh --json "<summarized_description_with_prefix>"` from repo root and parse its JSON output for BRANCH_NAME and SPEC_FILE. All file paths must be absolute.
   **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for.
   **NOTE** Branch names are automatically generated from the summarized description (max 65 chars after transformation).

   **Directory Name Generation**: The script automatically generates a directory name from the summarized feature description by:
   - Converting the description to lowercase
   - Replacing all non-alphanumeric characters with hyphens
   - Removing consecutive hyphens
   - Trimming leading and trailing hyphens
   - Truncating to a maximum of 65 characters
   - Example: "High-Value Field Redaction & Structured Context" → "high-value-field-redaction---structured-context"

1.5. **Load Reference Folder (if provided)**: If the user specified a reference folder with `-ref <folder_name>`, check for `.specify/reference/<folder_name>/` and load all files in the folder. Extract and summarize:

- **Business-Relevant Signals**: User goals, workflows, validation expectations, visible states, and constraints that belong in the business spec
- **Design & Interaction Signals**: Screen or view inventory, interaction states, loading or empty or error states, accessibility cues, and responsive cues
- **Terminal Behavior & Scope Guards**: Prototype-only endings, explicit non-goals, forbidden assumptions, prohibited behaviors, and exact user-facing copy when the source clearly specifies it
- **Technical Observations**: Implementation-sensitive patterns, component or structure hints, configuration notes, or integration notes
- **Validation & Testing Signals**: Testing patterns, fixtures, utilities, or verification notes
- **Implementation-Sensitive Assumptions**: Assumptions that help planning or task generation but do not belong in the business spec

Store this as REFERENCE_CONTEXT for writing to a separate reference context artifact. Only business-facing signals may be incorporated into the spec itself.

2. Load `.specify/templates/spec-template.md` to understand required sections.

3. Write the specification to SPEC_FILE using the template structure, replacing placeholders with concrete details derived from the feature description and reference folder (if provided) while preserving section order and headings.
   - Promote each distinct observable success, invalid, empty, error, or terminal scenario into its own acceptance criterion when the prompt or validated reference clearly supports it.
   - Do not infer behaviors that are not explicitly requested or validated by the reference material, such as normalization rules, persistence, retries, background side effects, or extra navigation.
   - Update the Review & Acceptance Checklist and Execution Status so they truthfully reflect the actual completeness of the generated document.

   **If a reference folder was used**:

   a) Incorporate only business-facing signals into `spec.md`.

   b) Preserve exact user-facing copy when the reference clearly specifies validation messages, confirmation copy, or terminal user-visible outcomes.

   c) Convert reference scenarios into explicit acceptance criteria, business rules, assumptions and scope boundaries, non-goals, and prohibited behaviors when the source supports them.

   d) Do **not** add reference metadata, technical notes, or a `Reference Context` section to `spec.md`.

   e) Create `reference-context.md` in the same feature directory as `SPEC_FILE` with this structure:

   ```markdown
   # Reference Context: [FEATURE NAME]

   **Reference Folder**: `<folder_name>`
   **Purpose**: Supplementary design and technical context for planning and task generation

   ## Referenced Files

   - [List files that were loaded and analyzed]

   ## Business-Relevant Signals

   [Summarize user goals, validation expectations, visible states, and constraints that matter to downstream planning]

   ## Design & Interaction Signals

   [Summarize screen or view inventory, interaction states, loading or empty or error states, accessibility cues, and responsive cues]

   ## Terminal Behavior & Scope Guards

   [Summarize explicit non-goals, forbidden assumptions, prohibited behaviors, prototype-only endings, and exact user-facing copy that should be preserved]

   ## Technical Observations

   [Summarize implementation-sensitive patterns, component or structure hints, configuration notes, and integration notes]

   ## Validation & Testing Signals

   [Summarize testing patterns, fixtures, utilities, and verification notes]

   ## Implementation-Sensitive Assumptions

   [Summarize assumptions that support planning and task generation but do not belong in the business spec]

   ## Open Questions

   - [List unresolved questions, if any]
   ```

   This allows @sdd-plan and @sdd-tasks to use pre-analyzed reference input without overloading the business spec.

4. Report completion with branch name, spec file path, reference folder used (if any), `reference-context.md` path (if created), and readiness for the next phase.

Note: The script creates the feature directory and initializes the spec file.

---

## Creating Reference Folders

Reference folders provide reusable context that enhances `@sdd-specify`, `@sdd-plan`, and `@sdd-tasks` workflows.

### Minimum Reference Folder Setup

1. Create `.specify/reference/<folder_name>/`
2. Add `README.md` with business-facing requirements, acceptance criteria, business rules, scope boundaries, user-visible states, and any reference-only technical notes that help planning
3. Add extra files only when they provide signal the README cannot capture cleanly

Keep the shared authoring structure technology agnostic. If implementation-sensitive material is useful, keep it in clearly reference-only notes so it can inform planning without leaking into `spec.md`.

### Using Reference Folders

After creating a reference folder:

1. Edit the README.md with the domain or feature requirements you want reused.
2. Add extra files only when they capture additional design, validation, or integration signal.
3. Use the folder when creating specifications:
   - `@sdd-specify <feature_description> -ref <folder_name>` creates `spec.md` plus `reference-context.md`
   - `@sdd-plan` and `@sdd-tasks` automatically source `reference-context.md` from the feature folder
   - No need to pass `-ref` after specification creation

For fuller authoring examples, keep the detail in `README.md` or repo docs rather than expanding the core runtime command path.

### Output Format

Upon successful completion, display the following information:

```
Feature specification created successfully

Branch Name: <BRANCH_NAME>
Spec File: specs/<feature-name>/spec.md
Reference: <folder_name> (if used, otherwise "None")
Reference Context File: specs/<feature-name>/reference-context.md (if created, otherwise "None")

Next Steps:
- Review the specification in the spec file
- Run @sdd-plan to create an implementation plan
- Run @sdd-tasks to break down into actionable tasks
```

### Important Notes

- Only create the folder if it doesn't already exist
- The folder name should be descriptive and kebab-case (e.g., `user-authentication`, `payment-system`)
- The README.md serves as the primary reference document but additional files can be added
- Reference folders provide consistent context: define once in @sdd-specify, automatically used by @sdd-plan and @sdd-tasks
