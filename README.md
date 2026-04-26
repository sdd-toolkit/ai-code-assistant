# LLM Specification Driven Development (SDD) Toolkit

Specification Driven Development (SDD) workflow toolkit for collaborating with AI coding assistants—GitHub Copilot (primary) and Amazon Q Developer (alternative)—using consistent prompts and a spec→plan→tasks→implement loop.

## About

Specification Driven Development (SDD) is a methodology that shifts AI-assisted work upstream: you first create an explicit specification, then derive design artifacts, from which reproducible task lists are generated, and only then execute implementation.

This toolkit packages that flow into markdown prompts and helper scripts for multiple Large Language Model (LLM) developer assistants, using readable **Markdown format** for constitutions and standards.

## Key Features

### Workflow Excellence

- Multi-vendor prompt distribution (Amazon Q + GitHub Copilot) with identical semantics
- Unified command-style verbs (`@sdd-specify`, `@sdd-plan`, `@sdd-tasks`, `@sdd-implement`, etc.)
- Reference folder mechanism (`@sdd-specify <description> -ref <folder>`) to inject structured domain context
- Consistent, auditable, specification-first workflow across different AI assistants

### Markdown-Based Constitutions

- **Human-readable** constitution and standards files
- **Easy to edit** with any text editor
- **Version control friendly** with clear diffs
- **Flexible structure** for project-specific needs

### Architecture

- Clean, modern implementation
- Modular constitution loading
- Shared validation patterns
- Markdown format for all standards and templates

If you maintain or use another AI assistant, add support by placing these markdown prompt files into that tool's custom prompt directory or ingestion mechanism.

## Why This Toolkit?

### Simple and Maintainable

Constitution files use **Markdown format** that is:

- **Human-readable** and easy to understand
- **Simple to edit** with any text editor
- **Version control friendly** with readable diffs
- **Accessible** to all team members

### Practical Benefits

1. **Clear structure** for project standards
2. **Easy collaboration** with readable format
3. **Flexible customization** for your needs
4. **Better maintainability** over time

### Modern Design

This is a clean, modern implementation designed for simplicity and clarity from the ground up. Every aspect is optimized for LLM efficiency and developer experience.

## Quick Start

1. **Install prompts (GitHub Copilot):**

Use the project-local install in the Installation Guide: see [INSTALL.md — GitHub Copilot (Project-Local)](./INSTALL.md#github-copilot-project-local--recommended).

2. **Start developing:**

   ```
   @sdd-specify user authentication system
   # Output: Feature Directory: user-authentication-system

   @sdd-plan feat_user-authentication-system
   @sdd-tasks feat_user-authentication-system
   @sdd-implement feat_user-authentication-system
   @sdd-audit feat_user-authentication-system
   ```

## Why Markdown for LLM Consistency

This toolkit uses **Markdown format** for defining rules, standards, and constraints in the constitution and templates. This design choice provides excellent readability while maintaining machine-parseability.

### The Readability Problem

Traditional prose-based rules can be ambiguous for LLM interpretation:

**Prose Format (Low Structure):**

```markdown
Branch names must follow proper naming conventions and be descriptive.
```

### Markdown Solution (Clear Structure)

**Structured Markdown Format**:

```markdown
## Branch Naming Convention

**Pattern**: `type/short-description`

### Constraints

#### Must

- Follow pattern `type/short-description`
- Use only lowercase letters (a-z), numbers (0-9), hyphens (-)

#### Must Not

- Begin with numbers or numeric prefixes
- Contain uppercase letters or spaces

### Examples

#### Valid

- `feat/add-payment-endpoint`

#### Invalid

- `Fix_DB_Bug` - Contains uppercase and underscore
```

### Why Markdown Works Better

1. **Clear Structure**: Headers and sections organize information hierarchically
2. **Easy to Read**: Natural language with clear formatting
3. **Simple to Edit**: Any text editor, no special syntax knowledge needed
4. **Version Control**: Git diffs are readable and meaningful
5. **Accessible**: Everyone on the team can understand and contribute
6. **Machine-Parseable**: LLMs can still extract requirements effectively

### Benefits for Your Projects

- **Easy to Understand**: Everyone can read and contribute to standards
- **Simple Maintenance**: Edit with any text editor
- **Clear Diffs**: Version control shows exactly what changed
- **Flexible Structure**: Organize standards in ways that make sense
- **Better Collaboration**: No special syntax knowledge required
- **Tool Integration**: Markdown works with every development tool

## Workflow Diagrams

### Standard Workflow

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   @sdd-specify  │───▶│    @sdd-plan     │───▶│   @sdd-tasks    │───▶│ @sdd-implement  │───▶│   @sdd-audit    │
│             │    │              │    │             │    │             │    │             │
│ Creates     │    │ Generates    │    │ Creates     │    │ Executes    │    │ Validates   │
│ spec.md     │    │ design docs  │    │ tasks.md    │    │ code        │    │ quality     │
└─────────────┘    └──────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

### Enhanced Workflow with Reference Context

```
┌─────────────────┐    ┌──────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│    @sdd-specify     │───▶│    @sdd-plan     │───▶│   @sdd-tasks    │───▶│ @sdd-implement  │───▶│   @sdd-audit    │
│  -ref <folder>  │    │              │    │             │    │             │    │             │
│                 │    │              │    │             │    │             │    │             │
│ Loads reference │    │ Uses         │    │ Applies     │    │ Executes    │    │ Validates   │
│ folder ONCE     │    │ reference    │    │ reference   │    │ code        │    │ quality     │
│ Writes spec.md  │    │ context from │    │ context     │    │             │    │             │
│ + sidecar file  │    │ sidecar file │    │ patterns    │    │             │    │             │
└─────────────────┘    └──────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
        │                      │                   │
        ▼                      │                   │
┌─────────────────┐            │                   │
│ reference-      │            │                   │
│ context.md      │◀───────────┴───────────────────┘
│ in feature dir  │
│                 │  • Business-Relevant Signals
│ Stored ONCE,    │  • Design & Interaction Signals
│ Reused later    │  • Technical Observations
│                 │  • Validation & Testing Signals
└─────────────────┘  • Referenced Files
```

## Example Commands

**Standard Workflow:**

```bash
@sdd-init  # Initialize project constitution first
@sdd-specify JWT-based user authentication with login/logout
# Output: Feature Directory: jwt-based-user-authentication-with-login-logout

@sdd-plan jwt-based-user-authentication-with-login-logout
@sdd-tasks jwt-based-user-authentication-with-login-logout
@sdd-implement jwt-based-user-authentication-with-login-logout
@sdd-audit jwt-based-user-authentication-with-login-logout  # Audit specific feature
```

**Enhanced with Reference Context:**

````bash
# 1. Create reference folder with requirements (optional - can be done once and reused)
mkdir -p .specify/reference/user-authentication
# Edit .specify/reference/user-authentication/README.md with requirements

# 2. Create specification with reference context (outputs directory name)
@sdd-specify user authentication with login and logout -ref user-authentication
# Output: Branch created: feat/user-authentication-with-login-logout

**Note**: Git branch management is manual. The system generates branch-compatible directory names, but you control your git workflow:

```bash
# Create your branch manually
git checkout -b feat/your-feature-name

# Then create the specification
@sdd-specify "feat/your feature description"
````

# 3. Generate plan (automatically uses reference-context.md when present)

@sdd-plan feat/user-authentication-with-login-logout

# 4. Create tasks (automatically uses reference-context.md when present)

@sdd-tasks feat/user-authentication-with-login-logout

# 5. Execute implementation (uses plan/tasks outputs created from reference-context.md when present)

@sdd-implement feat/user-authentication-with-login-logout

# 6. Validate implementation quality

@sdd-audit feat/user-authentication-with-login-logout

````

**Using Different Branch Types:**

```bash
# Feature (default type if not specified)
@sdd-specify user authentication system

# Bug fix
@sdd-specify payment timeout issue -type fix

# Documentation update
@sdd-specify api documentation update -type docs

# Refactoring
@sdd-specify code cleanup and optimization -type refactor

# Combined with reference folder
@sdd-specify payment processing -type feat -ref payment-patterns
````

**Working with Multiple Specs:**

```bash
# List available features if you forget the name
@sdd-audit
# Output: "Multiple specs found. Please specify which feature to audit: @sdd-audit <feature-name>"
#         Available features: user-authentication, payment-system, api-endpoints

# Audit specific feature
@sdd-audit payment-system
```

This generates design documents, creates a task list, and implements the feature following your project's constitutional principles. Reference folders in `.specify/reference/` provide structured context that is loaded once during specification and written to `reference-context.md` for downstream planning and task generation.

## Reference Context System

The toolkit uses an optimized reference context system that **loads once and reuses**:

### How It Works

1. **During `@sdd-specify <description> -ref <folder>`**:
   - Loads all files from `.specify/reference/<folder>/`
   - Treats all validated files in the folder as authoritative inputs; `README.md`, if present, is an organizer and does not outrank sibling artifacts
   - Extracts and categorizes insights:
     - Business-Relevant Signals
     - Design & Interaction Signals
       - Visual System / Style Tokens
     - Technical Observations
     - Validation & Testing Signals
   - Writes business-facing requirements to `spec.md` without leaking tech stack, framework, API, code-structure, or CSS implementation detail
   - Writes supplementary context, including preserved visual-system detail, to `reference-context.md`

2. **During `@sdd-plan` and `@sdd-tasks`**:
   - Reads `reference-context.md` from the feature folder when present
   - Uses pre-analyzed insights without re-loading files
   - 50-70% faster with consistent context across stages

### Benefits

- **Performance**: Files loaded once instead of 3 times (67% reduction)
- **Consistency**: Single source of truth across all stages
- **Transparency**: Business requirements stay in `spec.md`, while supplementary design, visual-system, and technical context stays in `reference-context.md`
- **Efficiency**: Reduced token usage and faster execution

## Maintainer Sync Checklist

Use this checklist whenever prompt or template behavior changes:

- Update each pair together: `.specify/templates/commands/sdd-specify.md` and `prompts/sdd-specify.md`
- Update each pair together: `.specify/templates/commands/sdd-plan.md` and `prompts/sdd-plan.md`
- Update each pair together: `.specify/templates/commands/sdd-tasks.md` and `prompts/sdd-tasks.md`
- Update each pair together: `.specify/templates/commands/sdd-implement.md` and `prompts/sdd-implement.md`
- Confirm usage, arguments, output examples, and path examples match the current `specs/<feature>/...` model
- Confirm business-only `spec.md` behavior and `reference-context.md` behavior match across command templates and runtime prompts
- Confirm validated reference artifacts are treated as top-priority inputs and that `README.md` is documented only as an optional organizer
- Confirm plan and task generation rules stay behaviorally aligned after edits
- Confirm shared prompts and templates stay technology agnostic before repo analysis; stack-specific detail belongs in instantiated constitutions and generated repo-grounded artifacts, not in shared scaffolding
- Confirm `contracts/` is described as optional and generic across plan, tasks, and implement surfaces rather than as an API-only default
- Confirm long sections are necessary for the primary execution path; move tutorial or authoring detail to docs when it is not execution-critical
- Confirm persistent artifact paths stay feature-local, repo-relative, or current-workspace-derived; reject foreign absolute paths

## Agnosticism Boundary

- Shared workflow prompts, command templates, and generic output templates must stay technology agnostic before repo inspection.
- Instantiated constitution files may contain stack-specific standards once they are grounded in the actual project.
- Generated `plan.md`, `research.md`, `quickstart.md`, and `tasks.md` may contain stack-specific detail when that detail comes from the real repo, constitution, or validated feature context.

## Example Guardrails

Keep examples balanced across feature shapes so the prompts do not learn one default architecture:

- UI-only interaction feature: prefer existing view, state, styling, accessibility, and manual-validation surfaces without inventing backend layers
- Backend or service feature: prefer existing service, boundary, or contract surfaces only when the repo and feature justify them
- Library or utility change: prefer focused module, helper, or file-processing surfaces without inventing page-level or API-level artifacts
- Do not treat API contracts, service layers, or integration suites as the default answer for every feature

### Creating Reference Folders

Create structured requirement folders to enhance your workflow:

```bash
# Create folder structure
mkdir -p .specify/reference/your-domain-name

# Optional: create README.md when a prose overview helps organize the artifacts
cat > .specify/reference/your-domain-name/README.md << 'EOF'
# Your Domain Requirements

## Primary User Story
As a [user], I want [goal] so that [benefit].

## Acceptance Criteria
- [ ] Must have: [requirement]
- [ ] Should have: [requirement]

## Key Entities
- **Entity1**: fields, relationships
- **Entity2**: fields, relationships

## Business Rules
- Rule 1: [constraint or validation]
- Rule 2: [business logic]
EOF

# Add other authoritative reference artifacts when they carry real design or workflow signal
cat > .specify/reference/your-domain-name/formCSS.md << 'EOF'
# Spacing, typography, sizing, border, and color tokens
EOF

cat > .specify/reference/your-domain-name/stories.md << 'EOF'
# User-visible scenarios and validation behavior
EOF

# Use in workflow
@sdd-specify your feature description -ref your-domain-name
```

All validated files inside the folder are authoritative when the folder is used. `README.md` is optional and does not outrank sibling artifacts.

See [docs/reference-folder-example.md](docs/reference-folder-example.md) for a mixed-artifact example showing how business behavior stays in `spec.md` and design-token detail moves to `reference-context.md`, planning, and tasks.

## Available Prompts

| Prompt           | Purpose                                                        | Usage                                                                                   |
| ---------------- | -------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `@sdd-init`      | Create/update project constitution with versioning             | `@sdd-init`                                                                             |
| `@sdd-drift`     | Detect constitutional drift and generate realignment TODO list | `@sdd-drift`                                                                            |
| `@sdd-specify`   | Create feature specifications from descriptions                | `@sdd-specify <description>` or `@sdd-specify <description> -type <type> -ref <folder>` |
| `@sdd-plan`      | Generate implementation plans and design artifacts             | `@sdd-plan <folder-name>`                                                               |
| `@sdd-tasks`     | Create dependency-ordered task breakdowns                      | `@sdd-tasks <folder-name>`                                                              |
| `@sdd-implement` | Execute implementation following task plan                     | `@sdd-implement <folder-name>`                                                          |
| `@sdd-audit`     | Validate implementation against specification                  | `@sdd-audit <folder-name>`                                                              |

### Prompt Details

**Constitution Management**

- Manages project principles and governance
- Supports semantic versioning (MAJOR.MINOR.PATCH)
- Validates consistency across templates
- Generates sync impact reports

**Drift Detection**

- Detects drift between project state and constitutional requirements
- Identifies gaps and violations
- Prioritizes drift items by severity (Critical/High/Medium/Low)
- Includes security drift checks
- Generates `specs/CONSTITUTION_DRIFT.md` with realignment tasks
- Overwrites existing drift report on each run for fresh analysis

**Specification Creation**

- Creates feature directories with descriptive naming
- Supports explicit branch type specification via `-type` (defaults to `feat`)
- Supports reference context via `-ref <folder>`
- Generates structured spec.md with requirements
- Outputs feature directory name (use this for subsequent commands)
- Optimized: Loads reference files once, stores summary

**Implementation Planning**

- Requires feature folder name parameter (compulsory)
- Generates multi-phase design artifacts
- Integrates constitutional requirements
- Uses `reference-context.md` from the feature folder when present
- Creates: research.md, data-model.md, contracts/, quickstart.md

**Task Generation**

- Requires feature folder name parameter (compulsory)
- Dependency-ordered task lists (TDD approach)
- Marks parallel tasks with [P]
- Uses `reference-context.md` patterns when present
- Phase-based: Setup → Tests → Core → Integration → Polish

**Implementation Execution**

- Requires feature folder name parameter (compulsory)
- Executes tasks in dependency order
- Marks completed tasks as [X]
- Respects parallel vs sequential constraints
- Progress tracking and error handling

**Implementation Audit**

- Validates implementation against specification after `@sdd-implement`
- Requires feature folder name parameter (compulsory)
- Usage: `@sdd-audit <folder-name>`
- Audits a single feature specification at a time
- Checks requirements coverage, acceptance criteria, task completion
- Audits code quality, testing, error handling, and security
- Calculates compliance metrics (requirements %, task %, test coverage)
- Identifies issues by severity (Critical/High/Medium/Low)
- Generates quality scores and production readiness assessment
- Creates feature-specific `AUDIT.md` in `specs/<feature>/`
- Overwrites existing audit report on each run for fresh validation

## Documentation

- [Installation Guide](./INSTALL.md)
- [Usage Guide](./PROMPTS_HOWTO.md)
- [Prompt Summary](./PROMPTS_SUMMARY.md)
- [Update Scripts](./sdd-toolkit/README.md)

## Automated Updates

The `sdd-toolkit/` directory contains automated update scripts to keep your installation current:

- **Update Scripts**: `sdd-update-copilot.sh`, `sdd-update-amazonq.sh`

Scripts can be run directly from GitHub using curl, or locally if you've cloned the repository. See [sdd-toolkit/README.md](./sdd-toolkit/README.md) for details.

## AmazonQ

AmazonQ install [INSTALL.md](./INSTALL.md#alternative-amazon-q-developer-global).

## Credits & Attribution

This work is inspired by the amazing project: [github/spec-kit](https://github.com/github/spec-kit) by GitHub.

## License

This project is licensed under the [MIT License](./LICENSE).

Portions of this project are based on or adapted from
[Spec-Kit](https://github.com/github/spec-kit),
© 2024 GitHub, Inc., licensed under the MIT License.
See the [Spec-Kit LICENSE](https://github.com/github/spec-kit/blob/main/LICENSE)
for details.
