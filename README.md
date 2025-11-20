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
   # Output: Branch Name: feat/user-authentication-system

   @sdd-plan feat/user-authentication-system
   @sdd-tasks feat/user-authentication-system
   @sdd-implement feat/user-authentication-system
   @sdd-audit user-authentication-system
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
│ Loads reference │    │ Uses stored  │    │ Applies     │    │ Executes    │    │ Validates   │
│ folder ONCE     │    │ Reference    │    │ Reference   │    │ code        │    │ quality     │
│ Summarizes into │    │ Context from │    │ Context     │    │             │    │             │
│ spec.md         │    │ spec.md      │    │ patterns    │    │             │    │             │
└─────────────────┘    └──────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
        │                      │                   │
        ▼                      │                   │
┌─────────────────┐            │                   │
│ Reference       │            │                   │
│ Context Section │◀───────────┴───────────────────┘
│ in spec.md      │
│                 │  • Architecture & Patterns
│ Stored ONCE,    │  • Code Examples & Interfaces
│ Used 3x         │  • Configuration & Setup
│                 │  • Testing Approaches
└─────────────────┘  • Referenced Files
```

## Example Commands

**Standard Workflow:**

```bash
@sdd-init  # Initialize project constitution first
@sdd-specify JWT-based user authentication with login/logout
@sdd-plan feat/jwt-based-user-authentication-with-login-logout
@sdd-tasks feat/jwt-based-user-authentication-with-login-logout
@sdd-implement feat/jwt-based-user-authentication-with-login-logout
@sdd-audit jwt-based-user-authentication-with-login-logout  # Audit specific feature
```

**Enhanced with Reference Context:**

```bash
# 1. Create reference folder with requirements (optional - can be done once and reused)
mkdir -p .specify/reference/user-authentication
# Edit .specify/reference/user-authentication/README.md with requirements

# 2. Create specification with reference context (outputs branch name)
@sdd-specify user authentication with login and logout -ref user-authentication
# Output: Branch created: feat/user-authentication-with-login-logout

# 3. Generate plan (automatically uses Reference Context from spec.md)
@sdd-plan feat/user-authentication-with-login-logout

# 4. Create tasks (automatically uses Reference Context from spec.md)
@sdd-tasks feat/user-authentication-with-login-logout

# 5. Execute implementation (automatically uses Reference Context from spec.md)
@sdd-implement feat/user-authentication-with-login-logout

# 6. Validate implementation quality
@sdd-audit feat/user-authentication-with-login-logout
```

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
```

**Working with Multiple Specs:**

```bash
# List available features if you forget the name
@sdd-audit
# Output: "Multiple specs found. Please specify which feature to audit: @sdd-audit <feature-name>"
#         Available features: user-authentication, payment-system, api-endpoints

# Audit specific feature
@sdd-audit payment-system
```

This generates design documents, creates a task list, and implements the feature following your project's constitutional principles. Reference folders in `.specify/reference/` provide structured context that is loaded once during specification and reused throughout the workflow.

## Reference Context System

The toolkit uses an optimized reference context system that **loads once and reuses**:

### How It Works

1. **During `@sdd-specify <description> -ref <folder>`**:

   - Loads all files from `.specify/reference/<folder>/`
   - Extracts and categorizes insights:
     - Architecture & Patterns
     - Code Examples & Interfaces
     - Configuration & Setup
     - Testing Approaches
   - Stores comprehensive summary in spec.md's **Reference Context** section

2. **During `@sdd-plan` and `@sdd-tasks`**:
   - Reads the Reference Context section from spec.md
   - Uses pre-analyzed insights without re-loading files
   - 50-70% faster with consistent context across stages

### Benefits

- **Performance**: Files loaded once instead of 3 times (67% reduction)
- **Consistency**: Single source of truth across all stages
- **Transparency**: All insights documented and reviewable in spec.md
- **Efficiency**: Reduced token usage and faster execution

### Creating Reference Folders

Create structured requirement folders to enhance your workflow:

```bash
# Create folder structure
mkdir -p .specify/reference/your-domain-name

# Create README.md with requirements
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

## Technical Constraints
- Performance: [requirements]
- Security: [requirements]
EOF

# Use in workflow
@sdd-specify your feature description -ref your-domain-name
```

## Available Prompts

| Prompt           | Purpose                                                        | Usage                                                                                   |
| ---------------- | -------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `@sdd-init`      | Create/update project constitution with versioning             | `@sdd-init`                                                                             |
| `@sdd-drift`     | Detect constitutional drift and generate realignment TODO list | `@sdd-drift`                                                                            |
| `@sdd-specify`   | Create feature specifications from descriptions                | `@sdd-specify <description>` or `@sdd-specify <description> -type <type> -ref <folder>` |
| `@sdd-plan`      | Generate implementation plans and design artifacts             | `@sdd-plan <feature-name>`                                                              |
| `@sdd-tasks`     | Create dependency-ordered task breakdowns                      | `@sdd-tasks <feature-name>`                                                             |
| `@sdd-implement` | Execute implementation following task plan                     | `@sdd-implement <feature-name>`                                                         |
| `@sdd-audit`     | Validate implementation against specification                  | `@sdd-audit <feature-name>`                                                             |

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
- Generates `.specify/specs/CONSTITUTION_DRIFT.md` with realignment tasks
- Overwrites existing drift report on each run for fresh analysis

**Specification Creation**

- Creates feature branches automatically
- Supports explicit branch type specification via `-type` (defaults to `feat`)
- Supports reference context via `-ref <folder>`
- Generates structured spec.md with requirements
- Outputs branch name for easy checkout
- Optimized: Loads reference files once, stores summary

**Implementation Planning**

- Requires feature name parameter (compulsory)
- Generates multi-phase design artifacts
- Integrates constitutional requirements
- Uses Reference Context from spec (no re-loading)
- Creates: research.md, data-model.md, contracts/, quickstart.md

**Task Generation**

- Requires feature name parameter (compulsory)
- Dependency-ordered task lists (TDD approach)
- Marks parallel tasks with [P]
- Uses Reference Context patterns
- Phase-based: Setup → Tests → Core → Integration → Polish

**Implementation Execution**

- Requires feature name parameter (compulsory)
- Executes tasks in dependency order
- Marks completed tasks as [X]
- Respects parallel vs sequential constraints
- Progress tracking and error handling

**Implementation Audit**

- Validates implementation against specification after `@sdd-implement`
- Requires feature name parameter (compulsory)
- Usage: `@sdd-audit <feature-name>`
- Audits a single feature specification at a time
- Checks requirements coverage, acceptance criteria, task completion
- Audits code quality, testing, error handling, and security
- Calculates compliance metrics (requirements %, task %, test coverage)
- Identifies issues by severity (Critical/High/Medium/Low)
- Generates quality scores and production readiness assessment
- Creates feature-specific `AUDIT.md` in `.specify/specs/<feature>/`
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
