# @sdd-specify Flow Diagram

```mermaid
flowchart TD
    Start([User: @sdd-specify feature-description]) --> CheckRef{-ref flag<br/>provided?}

    CheckRef -->|No| LoadBranching[Load Branching Standards<br/>.specify/memory/git-workflow.yaml]
    CheckRef -->|Yes| LoadRef[Load Reference Folder<br/>.specify/reference/folder-name/]

    LoadRef --> LoadBranching

    LoadBranching --> ValidateBranch{Validate against<br/>branching rules}

    ValidateBranch -->|Invalid| ErrorBranch[ERROR: Branch name violates<br/>branching standards<br/>STOP]
    ValidateBranch -->|Valid| CreateDirName[Create compliant directory name<br/>type/short-description]

    CreateDirName --> RunScript[Run: create-new-feature.sh<br/>Parse JSON output]

    RunScript --> PostValidate{Re-validate<br/>generated branch}

    PostValidate -->|Invalid| ErrorBranch
    PostValidate -->|Valid| CheckRefLoad{Reference<br/>folder loaded?}

    CheckRefLoad -->|Yes| PrepareRefContext[Prepare reference-context.md<br/>sidecar content]
    CheckRefLoad -->|No| LoadTemplate[Load spec-template.md]

    PrepareRefContext --> LoadTemplate

    LoadTemplate --> PopulateSpec[Populate business specification:<br/>- Feature Overview<br/>- User Stories<br/>- Acceptance Criteria<br/>- Business Rules]

    PopulateSpec --> CheckRefContext{Reference<br/>context exists?}

    CheckRefContext -->|Yes| CreateRefContext[Create reference-context.md:<br/>- Business-Relevant Signals<br/>- Design & Interaction Signals<br/>- Visual System / Style Tokens<br/>- Technical Observations<br/>- Validation & Testing Signals]
    CheckRefContext -->|No| CreateSpec[Create spec.md in<br/>specs/feature-name/]

    CreateRefContext --> CreateSpec

    CreateSpec --> Done([Complete: Spec created<br/>Branch: Manual if desired<br/>Ready for @sdd-plan])

    style Start fill:#e1f5ff
    style Done fill:#d4edda
    style ErrorBranch fill:#f8d7da
    style ValidateBranch fill:#fff3cd
    style PostValidate fill:#fff3cd
```

## Key Decision Points

1. **Reference Folder**: Optional context for enhanced specifications using `-ref <folder-name>`; all validated files in the folder are authoritative inputs when used
2. **Branch Validation**: Critical checkpoint - must comply with standards
3. **Post-Script Validation**: Ensures generated branch name still complies
4. **Reference Context**: Stored in `reference-context.md` for reuse by @sdd-plan and @sdd-tasks, including preserved visual-system and style-token signals

## Command Usage

```bash
# Basic specification creation
@sdd-specify "Add user authentication system"

# With reference context
@sdd-specify "Add user authentication system" -ref auth-patterns
```

## Output Files

- `specs/feature-name/spec.md` - Feature specification
- `specs/feature-name/reference-context.md` - Supplemental design, visual-system, and technical context from reference inputs (optional)
- Directory name follows branch naming convention: `type/feature-description`

**Note**: Create your git branch manually if desired:

```bash
git checkout -b feat/feature-name
```

## Next Step

Run `@sdd-plan` to create implementation plan
