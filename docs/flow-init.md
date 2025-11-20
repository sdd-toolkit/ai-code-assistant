# @sdd-init Flow Diagram

```mermaid
flowchart TD
    Start([User: @sdd-init or @sdd-init core]) --> CheckFiles{Constitution files<br/>exist in memory/?}

    CheckFiles -->|No files| InitializeAll[Initialize Constitution System<br/>Create .specify/memory/constitution/]
    CheckFiles -->|Files exist| AskUser[Ask which file(s) to update:<br/>core, architecture, testing,<br/>security, observability, optional]

    InitializeAll --> CopyTemplates[Copy templates to memory/<br/>Remove '-template' suffix:<br/>core, architecture, testing,<br/>security, observability, optional]

    CopyTemplates --> CheckGitWorkflow{Git workflow<br/>exists?}

    CheckGitWorkflow -->|No| CopyGitWorkflow[Copy git-workflow-template.md<br/>to memory/git-workflow.yaml]
    CheckGitWorkflow -->|Yes| InformUser

    CopyGitWorkflow --> InformUser[Inform user:<br/>Constitution initialized]

    InformUser --> IdentifyPlaceholders

    AskUser --> SelectFiles{User specifies<br/>file(s)?}

    SelectFiles -->|No specification| DefaultCore[Default to core.md]
    SelectFiles -->|Specified| LoadTarget[Load target file(s)]

    DefaultCore --> CheckGitWorkflow2{Git workflow<br/>exists?}
    LoadTarget --> CheckGitWorkflow2

    CheckGitWorkflow2 -->|No| CopyGitWorkflow2[Copy git-workflow-template.md]
    CheckGitWorkflow2 -->|Yes| IdentifyPlaceholders

    CopyGitWorkflow2 --> IdentifyPlaceholders[Identify placeholders:<br/>ALL_CAPS_IDENTIFIER patterns<br/>Respect user's principle count]

    IdentifyPlaceholders --> CollectValues[Collect/derive placeholder values:<br/>- User input<br/>- Repo context (README, docs)<br/>- Prior constitution versions<br/>- Governance dates]

    CollectValues --> DetermineVersion[Determine version bump:<br/>MAJOR: Breaking changes<br/>MINOR: New principles/sections<br/>PATCH: Clarifications/fixes]

    DetermineVersion --> DraftContent[Draft updated content:<br/>- Replace all placeholders<br/>- Preserve heading hierarchy<br/>- Ensure principles are declarative<br/>- Add metadata header]

    DraftContent --> ValidateContent{Validation<br/>checks pass?}

    ValidateContent -->|No| ErrorValidation[ERROR: Validation failed<br/>- Remaining placeholders<br/>- Invalid version format<br/>- Invalid date format<br/>- Vague language]

    ValidateContent -->|Yes| CheckConsistency[Consistency propagation:<br/>- plan-template.md<br/>- spec-template.md<br/>- tasks-template.md<br/>- commands/*.md<br/>- README.md]

    CheckConsistency --> GenerateReport[Generate Sync Impact Report:<br/>- File(s) updated<br/>- Version changes<br/>- Modified principles<br/>- Added/removed sections<br/>- Template update status<br/>- Cross-file impacts]

    GenerateReport --> WriteFiles[Write constitution file(s)<br/>to .specify/memory/constitution/]

    WriteFiles --> OutputSummary[Output summary:<br/>- Files updated<br/>- Version bump rationale<br/>- Manual follow-ups<br/>- Suggested commit message<br/>- Modular system reminder]

    OutputSummary --> Done([Complete: Constitution updated<br/>Ready for specification work])

    style Start fill:#e1f5ff
    style Done fill:#d4edda
    style ErrorValidation fill:#f8d7da
    style ValidateContent fill:#fff3cd
    style DetermineVersion fill:#fff3cd
    style CheckFiles fill:#fff3cd
```

## Key Decision Points

1. **Initialization vs Update**: Detect if constitution files exist or need first-time setup
2. **File Selection**: Default to core.md if not specified; allow multiple file updates
3. **Version Bump Type**: Semantic versioning based on change impact (MAJOR/MINOR/PATCH)
4. **Validation**: Enforce no placeholders, valid dates, declarative principles

## Constitution Structure

### Templates (`.specify/templates/constitution/`)

Pristine templates with placeholders, never modified:

- `core-template.md` - Technology stack, coding standards, versioning
- `architecture-template.md` - Service patterns, design principles
- `testing-template.md` - Test strategy, coverage requirements
- `security-template.md` - Security policies, authentication
- `observability-template.md` - Logging, monitoring, metrics
- `user-interface-template.md` - Project-specific standards (optional)

### Working Copies (`.specify/memory/constitution/`)

Project-specific filled-in versions:

- `core.md`, `architecture.md`, `testing.md`, `security.md`, `observability.md`, `user-interface.md`
- Copied from templates on first run (removing `-template` suffix)
- Updated versions managed independently per file

## Placeholder Tokens

Format: `[ALL_CAPS_IDENTIFIER]`

Common placeholders:

- `[PROJECT_NAME]`
- `[PRINCIPLE_1_NAME]`, `[PRINCIPLE_2_NAME]`, etc.
- `[RATIFICATION_DATE]` - Original adoption date
- `[LAST_AMENDED_DATE]` - Date of most recent change
- `[VERSION]` - Semantic version per file

## Version Bump Rules

- **MAJOR**: Backward incompatible governance/principle removals or redefinitions
- **MINOR**: New principle/section added or materially expanded guidance
- **PATCH**: Clarifications, wording, typo fixes, non-semantic refinements

## Sync Impact Report

Prepended as HTML comment at top of updated file(s):

```markdown
<!--
Sync Impact Report
- File updated: core.md
- Version change: v1.0.0 → v1.1.0
- Modified principles:
  - Code Quality → Enhanced with TypeScript strict mode
- Added sections: None
- Removed sections: None
- Templates requiring updates:
  ✅ plan-template.md
  ✅ spec-template.md
  ⚠ tasks-template.md (pending)
- Follow-up TODOs: None
- Impact on other files: None
-->
```

## Consistency Checks

Files validated for alignment with updated constitution:

1. `.specify/templates/plan-template.md` - Constitution checks
2. `.specify/templates/spec-template.md` - Scope/requirements alignment
3. `.specify/templates/tasks-template.md` - Task categorization
4. `.specify/templates/commands/*.md` - Generic guidance
5. `README.md` - Principle references

## Modular Constitution Benefits

- **Token efficiency**: Load only needed sections (e.g., `@sdd-implement` loads `testing,branching` for test files)
- **Focused updates**: Change architecture without touching testing standards
- **Clear ownership**: Each file has specific purpose and version
- **Better scalability**: Add new modules without affecting existing ones

## Output Files

- `.specify/memory/constitution/core.md` - Core standards (if updated)
- `.specify/memory/constitution/architecture.md` - Architecture principles (if updated)
- `.specify/memory/constitution/testing.md` - Testing strategy (if updated)
- `.specify/memory/constitution/security.md` - Security policies (if updated)
- `.specify/memory/constitution/observability.md` - Monitoring/logging (if updated)
- `.specify/memory/constitution/user-interface.md` - Custom standards (optional, if updated)
- `.specify/memory/git-workflow.yaml` - Git workflow (if initialized)

## Next Steps

After initializing or updating the constitution:

1. Run `@sdd-specify` to create feature specifications aligned with constitutional standards
2. Constitution files are automatically loaded by other prompts based on context needs
3. Commit changes with suggested message format: `docs: update constitution/{file} to v{version} ({description})`
