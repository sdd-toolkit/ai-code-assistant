# @sdd-tasks Flow Diagram

```mermaid
flowchart TD
    Start([User: @sdd-tasks or @sdd-tasks feature-name]) --> CheckFeature{Feature name<br/>provided?}

    CheckFeature -->|Yes| UseProvided[Use specified feature]
    CheckFeature -->|No| ListSpecs[List .specify/specs/ directories]

    ListSpecs --> CountSpecs{How many<br/>specs found?}

    CountSpecs -->|Zero| ErrorNoSpecs[ERROR: No specs found<br/>Run @sdd-specify first]
    CountSpecs -->|One| AutoSelect[Auto-select single spec]
    CountSpecs -->|Multiple| ErrorMultiple[ERROR: Multiple specs found<br/>Specify feature name]

    UseProvided --> RunCheck[Run: check-task-prerequisites.sh<br/>Parse JSON for FEATURE_DIR]
    AutoSelect --> RunCheck

    RunCheck --> LoadPlan[Load plan.md<br/>Tech stack & libraries]

    LoadPlan --> CheckArtifacts{Which artifacts<br/>exist?}

    CheckArtifacts --> LoadDataModel{data-model.md<br/>exists?}
    LoadDataModel -->|Yes| ReadDataModel[Read entities & relationships]
    LoadDataModel -->|No| LoadContracts

    ReadDataModel --> LoadContracts{contracts/<br/>exists?}
    LoadContracts -->|Yes| ReadContracts[Read API endpoints]
    LoadContracts -->|No| LoadResearch

    ReadContracts --> LoadResearch{research.md<br/>exists?}
    LoadResearch -->|Yes| ReadResearch[Read technical decisions]
    LoadResearch -->|No| LoadQuickstart

    ReadResearch --> LoadQuickstart{quickstart.md<br/>exists?}
    LoadQuickstart -->|Yes| ReadQuickstart[Read test scenarios]
    LoadQuickstart -->|No| CheckRef

    ReadQuickstart --> CheckRef{Reference folder<br/>in spec.md?}

    CheckRef -->|Yes| LoadRefFolder[Load reference context<br/>from spec metadata]
    CheckRef -->|No| DetectTaskType

    LoadRefFolder --> DetectTaskType[Detect task types needed: Testing tasks?; API or endpoint tasks?; Infrastructure tasks?; Mixed or general tasks?]

    DetectTaskType --> LoadConstitution[Load Constitutional Standards<br/>Based on task type:<br/>testing → testing,branching<br/>API → core,architecture,security,branching<br/>infra → core,operations,security,branching<br/>mixed → core,testing,architecture,branching]

    LoadConstitution --> LoadTaskTemplate[Load tasks-template.md]

    LoadTaskTemplate --> GenerateSetup[Generate Setup Tasks: Project initialization; Dependencies install; Linting configuration]

    GenerateSetup --> GenerateTests[Generate Test Tasks (P): Contract tests per endpoint; Integration tests per scenario; Mark as parallel (P)]

    GenerateTests --> GenerateCore[Generate Core Tasks: Model per entity; Service per business logic; Endpoint per contract; Sequential if same file]

    GenerateCore --> GenerateIntegration[Generate Integration Tasks: Database connections; Middleware setup; Logging configuration; External service integration]

    GenerateIntegration --> GeneratePolish[Generate Polish Tasks (P): Unit tests; Performance optimization; Documentation; Mark as parallel (P)]

    GeneratePolish --> OrderTasks[Order by dependencies: Setup → Tests → Core → Integration → Polish]

    OrderTasks --> MarkParallel[Mark parallel execution: Different files = (P); Same file = sequential; Independent tasks = (P)]

    MarkParallel --> AddCheckboxes[Ensure all tasks have checkbox format: e.g. T001 Task description]

    AddCheckboxes --> CreateTaskFile[Create tasks.md in<br/>.specify/specs/feature-name/]

    CreateTaskFile --> IncludeExamples[Include parallel execution<br/>examples with Task agent<br/>commands]

    IncludeExamples --> Done([Complete: Tasks created<br/>Ready for @sdd-implement])

    style Start fill:#e1f5ff
    style Done fill:#d4edda
    style ErrorNoSpecs fill:#f8d7da
    style ErrorMultiple fill:#f8d7da
    style CountSpecs fill:#fff3cd
    style CheckArtifacts fill:#fff3cd
    style DetectTaskType fill:#fff3cd
```

## Key Decision Points

1. **Feature Selection**: Auto-detect if only one spec exists
2. **Artifact Loading**: Dynamically load only available design documents
3. **Task Type Detection**: Determine which constitutional standards to load
4. **Dependency Ordering**: Setup → Tests → Core → Integration → Polish
5. **Parallel Markers**: Tasks on different files can run in parallel [P]

## Task Generation Rules

### From Artifacts

- **Each contract** → Contract test task [P]
- **Each entity** → Model creation task [P]
- **Each endpoint** → Implementation task (sequential if shared files)
- **Each user story** → Integration test [P]

### Parallelization Logic

- **Different files** → Can be parallel [P]
- **Same file** → Must be sequential (no [P])
- **Independent tasks** → Can be parallel [P]

## Task Phases

### 1. Setup

- Project initialization
- Install dependencies
- Configure linting

### 2. Tests [P]

- Contract tests
- Integration scenario tests
- Can run in parallel

### 3. Core

- Models (parallel if different files)
- Services (sequential if dependencies)
- Endpoints (based on file sharing)

### 4. Integration

- Database connections
- Middleware
- Logging
- External services

### 5. Polish [P]

- Unit tests
- Performance
- Documentation
- Can run in parallel

## Output Files

- `.specify/specs/feature-name/tasks.md` - Dependency-ordered task list

## Next Step

Run `@sdd-implement` to execute the implementation
