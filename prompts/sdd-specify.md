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

### Arguments

- **`<feature_description>`** (REQUIRED): Natural language description of the feature without type prefix (first text after `@sdd-specify`)
- **`-type <branch_type>`** (OPTIONAL): Feature type prefix - must be one of: `feat`, `fix`, `chore`, `refactor`, `test`, `docs`, `hotfix`, `maintenance` (defaults to `feat`)
- **`-ref <reference_folder>`** (OPTIONAL): Name of the reference folder in `.specify/reference/` to use for context

### Examples

```{{SCRIPT_LANG}}
# Basic usage with default feat type
@sdd-specify user authentication system

# With explicit branch type:
@sdd-specify payment timeout issue -type fix

# With reference context:
@sdd-specify user authentication system -ref auth-patterns

# With both type and reference:
@sdd-specify api documentation update -type docs -ref api-standards
```

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

   Valid examples:
   - @sdd-specify user authentication system -type feat
   - @sdd-specify payment timeout issue -type fix
   - @sdd-specify api documentation update -type docs

   Please provide a valid branch type or omit -type to use the default (feat).
   ```

   Do not proceed with any further steps if validation fails.

0.1. **Construct Full Feature Description**: Combine the type prefix with the feature description to create the full description:

- Format: `<type>/<feature_description>`
- Example: If `-type fix` and feature description is "payment timeout issue", construct `fix/payment timeout issue`
- If `-type` was not provided, use `feat/<feature_description>`

  0.2. **Summarize the feature description**: Create a concise summary of the full feature description (including type prefix) that is 80 characters or less. This summary should capture the essential meaning while preserving the required type prefix and being suitable for use as a directory name. Preserve key technical terms and maintain clarity.

1. Run the script `.specify/scripts/{{SCRIPT_LANG}}/create-new-feature{{SCRIPT_EXT}} --json "<summarized_description_with_prefix>"` from repo root and parse its JSON output for BRANCH_NAME and SPEC_FILE. All file paths must be absolute.
   **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for.
   **NOTE** Branch names are automatically generated from the summarized description (max 65 chars after transformation).

   **Directory Name Generation**: The script automatically generates a directory name from the summarized feature description by:
   - Converting the description to lowercase
   - Replacing all non-alphanumeric characters with hyphens
   - Removing consecutive hyphens
   - Trimming leading and trailing hyphens
   - Truncating to a maximum of 65 characters
   - Example: "High-Value Field Redaction & Structured Context" → "high-value-field-redaction---structured-context"

**Git Branch Management** (Manual):

The system no longer automatically creates git branches. If you want to use git branches:

1. Create your branch manually before or after running sdd-specify:

   ```bash
   git checkout -b feat/your-feature-name
   ```

2. The directory name will follow the same naming convention for consistency

3. This gives you full control over your git workflow

1.5. **Load Reference Folder (if provided)**: If the user specified a reference folder with `-ref <folder_name>`:

- Check if `.specify/reference/<folder_name>/` exists
- **If folder does NOT exist**, immediately stop and return:

  ```
  ERROR: Reference folder not found

  Requested folder: .specify/reference/<folder_name>/

  Available reference folders:
  [List all subdirectories in .specify/reference/]

  To create a new reference folder, see the "Creating Reference Folders" section in the specify command documentation.
  ```

  STOP all processing and do not continue.

- **If folder exists**, load all validated files in the folder and treat them as top-priority inputs.
  - A `README.md`, if present, is an organizing aid only and does not outrank sibling reference artifacts.
  - If a validated reference artifact conflicts with a generic prompt default, the validated reference artifact wins.
  - If validated reference artifacts conflict with each other, surface that conflict in `Open Questions` instead of silently choosing one.
  - **MANDATORY OUTPUT**: When `-ref` is provided, `reference-context.md` MUST be created in the feature directory. If it is not created, STOP and return an error instead of reporting success.
  - Extract and summarize:
    - **Business-Relevant Signals**: User goals, workflows, validation expectations, visible states, and constraints that belong in the business spec
    - **Design & Interaction Signals**: Screen or view inventory, interaction states, loading or empty or error states, accessibility cues, and responsive cues
    - **Visual System / Style Tokens**: Authoritative spacing, typography, sizing, density, border, color, contrast, iconography, and layout-token signals that **must be preserved verbatim and must never be lost**; they belong in `reference-context.md`, not in the business spec — do not summarise, soften, or omit any value
    - **Terminal Behavior & Scope Guards**: Prototype-only endings, explicit non-goals, forbidden assumptions, prohibited behaviors, and exact user-facing copy when the source clearly specifies it
    - **Technical Observations**: Implementation-sensitive patterns, component or structure hints, configuration notes, or integration notes
    - **Validation & Testing Signals**: Testing patterns, fixtures, utilities, or verification notes
    - **Implementation-Sensitive Assumptions**: Assumptions that help planning or task generation but do not belong in the business spec

Store this as REFERENCE_CONTEXT for writing to a separate reference context artifact. Only business-facing signals may be incorporated into the spec itself; never copy tech stack, framework choices, APIs, code structure, CSS declarations, class names, or file paths into `spec.md`.

2. Load `.specify/templates/spec-template.md` to understand required sections.

3. Write the specification to SPEC_FILE using the template structure, replacing placeholders with concrete details derived from the feature description and reference folder (if provided) while preserving section order and headings.
   - Promote each distinct observable success, invalid, empty, error, or terminal scenario into its own acceptance criterion when the prompt or validated reference clearly supports it.
   - If the prompt or validated reference clearly specifies that user-entered content is treated in a way that affects validation, matching, ordering, eligibility, or user-visible output, record that behavior explicitly in the specification as business-facing behavior. Describe only the observable or decision-relevant effect. Do not describe the implementation mechanism.
   - Even when validated reference artifacts are top-priority, keep `spec.md` business-only. Translate visual and design inputs into user-visible behavior, accessibility outcomes, copy, scope boundaries, and responsive expectations only.
   - Do not infer hidden input-handling rules from visual design alone, and do not infer other behaviors that are not explicitly requested or validated by the prompt or reference material, such as persistence, retries, background side effects, or extra navigation.
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

   ## Visual System / Style Tokens

   [Preserve verbatim every authoritative spacing, typography, sizing, density, border, color, contrast, iconography, and layout-token value from the reference files. These values are first-class and must never be lost, compressed, softened, or omitted. Do not summarise or generalise — record exact values as found in the reference.]

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

   f) Before completion, validate all boundary conditions:
   - `spec.md` remains business-only and does not include a `Reference Context` section.
   - `spec.md` contains no implementation detail (tech stack, framework choices, APIs, code structure, CSS declarations, class names, or file paths).
   - `reference-context.md` exists and contains the loaded reference-file inventory plus preserved visual-system/style-token values.

4. Report completion with branch name, spec file path, reference folder used (if any), and readiness for the next phase.

Note: The script creates the feature directory and initializes the spec file.

### Output Format

Upon successful completion, display the following information:

```
✅ Feature specification created successfully

Branch Name: <BRANCH_NAME>
Spec File: <SPEC_FILE>
Reference: <folder_name> (if used, otherwise "None")
Reference Context File: <REFERENCE_CONTEXT_FILE> (if created, otherwise "None")

Next Steps:
- Review the specification in the spec file
- Run @sdd-plan to create an implementation plan
- Run @sdd-tasks to break down into actionable tasks
```

**Example**:

```
✅ Feature specification created successfully

Branch Name: feat/user-authentication-system
Spec File: specs/feat-user-authentication-system/spec.md
Reference: auth-patterns
Reference Context File: specs/feat-user-authentication-system/reference-context.md

Next Steps:
- Review the specification in the spec file
- Run @sdd-plan to create an implementation plan
- Run @sdd-tasks to break down into actionable tasks
```

---

## Creating Reference Folders

Reference folders provide reusable context that enhances `@sdd-specify`, `@sdd-plan`, and `@sdd-tasks` workflows.

### Minimum Reference Folder Setup

1. Create `.specify/reference/<folder_name>/`
2. Add validated reference artifacts that carry authoritative behavior, design, copy, workflow, or verification signal
3. Optionally add `README.md` when a prose overview helps organize multiple artifacts or clarify how they relate
4. Keep filenames and file contents clear enough that each artifact can stand on its own if `README.md` is absent

Keep the shared authoring structure technology agnostic. If implementation-sensitive material is useful, keep it in clearly reference-only notes so it can inform planning without leaking into `spec.md`.

### Using Reference Folders

After creating a reference folder:

1. Add or update any validated files that carry the feature behavior, design, copy, or workflow signal you want reused.
2. Add `README.md` only when it helps explain or organize those artifacts; it does not outrank sibling files.
3. Use the folder when creating specifications:
   - `@sdd-specify <description> -ref <folder_name>` creates `spec.md` plus `reference-context.md`
   - `@sdd-plan` and `@sdd-tasks` automatically source `reference-context.md` from the feature folder
   - No need to pass `-ref` after specification creation

For fuller authoring examples, keep the detail in the validated reference artifacts themselves or repo docs rather than expanding the core runtime command path.

### Important Notes

- Only create the folder if it doesn't already exist
- The folder name should be descriptive and kebab-case (e.g., `user-authentication`, `payment-system`)
- All validated files in the folder are authoritative inputs when the folder is used
- `README.md`, if present, is a helpful organizing document but not the sole or highest-priority source
- Reference folders provide consistent context: define once in @sdd-specify, automatically used by @sdd-plan and @sdd-tasks
