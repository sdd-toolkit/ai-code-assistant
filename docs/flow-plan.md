# @sdd-plan Flow Diagram

```mermaid
flowchart TD
    Start([User: @sdd-plan or @sdd-plan feature-name]) --> CheckFeature{Feature name<br/>provided?}

    CheckFeature -->|Yes| UseProvided[Use specified feature]
    CheckFeature -->|No| ListSpecs[List .specify/specs/ directories]

    ListSpecs --> CountSpecs{How many<br/>specs found?}

    CountSpecs -->|Zero| ErrorNoSpecs[ERROR: No specs found<br/>Run @sdd-specify first]
    CountSpecs -->|One| AutoSelect[Auto-select single spec]
    CountSpecs -->|Multiple| ErrorMultiple[ERROR: Multiple specs found<br/>Specify feature name]

    UseProvided --> RunSetup[Run: setup-plan.sh feature-name<br/>Parse JSON for paths]
    AutoSelect --> RunSetup

    RunSetup --> ReadSpec[Read feature specification<br/>spec.md]

    ReadSpec --> CheckRefInSpec{Reference folder<br/>in spec metadata?}

    CheckRefInSpec -->|Yes| LoadRefFolder[Load reference folder<br/>.specify/reference/folder-name/]
    CheckRefInSpec -->|No| LoadConstitution

    LoadRefFolder --> LoadConstitution[Load Constitutional Standards<br/>load-constitution.sh<br/>core,architecture,testing,branching]

    LoadConstitution --> LoadTemplate[Load plan-template.md<br/>copied to plan.md]

    LoadTemplate --> ExecutePhase0[Phase 0: Research<br/>Generate research.md<br/>- Technical decisions<br/>- Library choices<br/>- Architecture patterns]

    ExecutePhase0 --> GateCheck0{Gate check:<br/>Research complete?}

    GateCheck0 -->|No| ErrorGate0[ERROR: Research incomplete<br/>Review and complete]
    GateCheck0 -->|Yes| ExecutePhase1[Phase 1: Design Artifacts<br/>Generate:<br/>- data-model.md<br/>- contracts/<br/>- quickstart.md]

    ExecutePhase1 --> GateCheck1{Gate check:<br/>Artifacts complete?}

    GateCheck1 -->|No| ErrorGate1[ERROR: Artifacts incomplete<br/>Review and complete]
    GateCheck1 -->|Yes| ExecutePhase2[Phase 2: Task Breakdown<br/>Generate tasks.md preview<br/>- Dependency ordered<br/>- Parallel markers]

    ExecutePhase2 --> GateCheck2{Gate check:<br/>Tasks complete?}

    GateCheck2 -->|No| ErrorGate2[ERROR: Tasks incomplete<br/>Review and complete]
    GateCheck2 -->|Yes| VerifyArtifacts[Verify all artifacts created:<br/>- research.md ✓<br/>- data-model.md ✓<br/>- contracts/ ✓<br/>- quickstart.md ✓<br/>- tasks.md ✓]

    VerifyArtifacts --> UpdateProgress[Update Progress Tracking<br/>All phases complete]

    UpdateProgress --> Done([Complete: Plan created<br/>Ready for @sdd-tasks])

    style Start fill:#e1f5ff
    style Done fill:#d4edda
    style ErrorNoSpecs fill:#f8d7da
    style ErrorMultiple fill:#f8d7da
    style ErrorGate0 fill:#f8d7da
    style ErrorGate1 fill:#f8d7da
    style ErrorGate2 fill:#f8d7da
    style GateCheck0 fill:#fff3cd
    style GateCheck1 fill:#fff3cd
    style GateCheck2 fill:#fff3cd
```

## Key Decision Points

1. **Feature Selection**: Auto-detect if only one spec exists
2. **Reference Context**: Automatically loaded if specified in spec.md
3. **Gate Checks**: Each phase must complete before proceeding
4. **Artifact Verification**: All required files must be generated

## Phase Breakdown

### Phase 0: Research

- Technical decisions and trade-offs
- Library and framework choices
- Architecture patterns to follow

### Phase 1: Design Artifacts

- **data-model.md**: Entities, relationships, validation
- **contracts/**: API endpoints, request/response formats
- **quickstart.md**: Integration test scenarios

### Phase 2: Task Breakdown

- Dependency-ordered task list
- Parallel execution markers
- TDD approach (tests before implementation)

## Output Files

- `.specify/specs/feature-name/plan.md` - Implementation plan
- `.specify/specs/feature-name/research.md` - Technical research
- `.specify/specs/feature-name/data-model.md` - Data models
- `.specify/specs/feature-name/contracts/` - API contracts
- `.specify/specs/feature-name/quickstart.md` - Test scenarios

## Next Step

Run `@sdd-tasks` to generate detailed task list
