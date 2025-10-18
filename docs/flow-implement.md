# @sdd-implement Flow Diagram

```mermaid
flowchart TD
    Start([User: @sdd-implement or @sdd-implement feature-name]) --> CheckFeature{Feature name<br/>provided?}

    CheckFeature -->|Yes| UseProvided[Use specified feature]
    CheckFeature -->|No| ListSpecs[List .specify/specs/ directories]

    ListSpecs --> CountSpecs{How many<br/>specs found?}

    CountSpecs -->|Zero| ErrorNoSpecs[ERROR: No specs found<br/>Run @sdd-specify first]
    CountSpecs -->|One| AutoSelect[Auto-select single spec]
    CountSpecs -->|Multiple| ErrorMultiple[ERROR: Multiple specs found<br/>Specify feature name]

    UseProvided --> RunCheck[Run: check-implementation-prerequisites.sh<br/>Parse JSON for paths]
    AutoSelect --> RunCheck

    RunCheck --> LoadTasks[REQUIRED: Load tasks.md<br/>Parse task phases & dependencies]

    LoadTasks --> LoadPlan[REQUIRED: Load plan.md<br/>Tech stack & architecture]

    LoadPlan --> LoadOptional[Load optional artifacts:<br/>- data-model.md if exists<br/>- contracts/ if exists<br/>- research.md if exists<br/>- quickstart.md if exists]

    LoadOptional --> ParseTasks[Parse task structure:<br/>- Extract phases<br/>- Identify dependencies<br/>- Mark parallel tasks [P]<br/>- Note TDD order]

    ParseTasks --> StartPhase{Next phase?}

    StartPhase -->|Setup| PhaseSetup[Phase: Setup]
    StartPhase -->|Tests| PhaseTests[Phase: Tests]
    StartPhase -->|Core| PhaseCore[Phase: Core]
    StartPhase -->|Integration| PhaseIntegration[Phase: Integration]
    StartPhase -->|Polish| PhasePolish[Phase: Polish]
    StartPhase -->|Complete| AllDone

    PhaseSetup --> IterateSetup[For each Setup task:<br/>- Project initialization<br/>- Install dependencies<br/>- Configure linting]

    IterateSetup --> ExecuteSetupTask[Detect file type &<br/>load relevant constitution:<br/>config → operations,security,branching]

    ExecuteSetupTask --> CompleteSetup{All Setup<br/>tasks complete?}

    CompleteSetup -->|No| IterateSetup
    CompleteSetup -->|Yes| StartPhase

    PhaseTests --> IterateTests[For each Test task [P]:<br/>- Contract tests<br/>- Integration tests<br/>Can run parallel]

    IterateTests --> ExecuteTestTask[Load constitution:<br/>testing,branching<br/>Follow TDD standards]

    ExecuteTestTask --> CheckParallelTest{Parallel [P]<br/>task?}

    CheckParallelTest -->|Yes| RunParallel[Execute in parallel<br/>with other [P] tasks]
    CheckParallelTest -->|No| RunSequential[Execute sequentially]

    RunParallel --> MarkComplete[Mark task as [X] completed]
    RunSequential --> MarkComplete

    MarkComplete --> CompleteTests{All Test<br/>tasks complete?}

    CompleteTests -->|No| IterateTests
    CompleteTests -->|Yes| StartPhase

    PhaseCore --> IterateCore[For each Core task:<br/>- Models<br/>- Services<br/>- Endpoints<br/>Respect file dependencies]

    IterateCore --> DetectCoreType[Detect implementation type:<br/>service → core,architecture,observability<br/>model → core,architecture<br/>endpoint → core,architecture,security<br/>auth → core,security]

    DetectCoreType --> LoadCoreConst[Load relevant constitution<br/>sections for file type]

    LoadCoreConst --> ApplyStandards[Apply standards:<br/>- Coding standards<br/>- Error handling<br/>- Logging patterns<br/>- Security practices]

    ApplyStandards --> ExecuteCoreTask[Implement task<br/>following constitutional<br/>requirements]

    ExecuteCoreTask --> CheckParallelCore{Parallel [P]<br/>or sequential?}

    CheckParallelCore -->|Parallel| RunParallelCore[Execute in parallel]
    CheckParallelCore -->|Sequential| RunSequentialCore[Execute in order]

    RunParallelCore --> MarkCompleteCore[Mark task as [X] completed]
    RunSequentialCore --> MarkCompleteCore

    MarkCompleteCore --> CompleteCore{All Core<br/>tasks complete?}

    CompleteCore -->|No| IterateCore
    CompleteCore -->|Yes| StartPhase

    PhaseIntegration --> IterateIntegration[For each Integration task:<br/>- Database connections<br/>- Middleware<br/>- Logging<br/>- External services]

    IterateIntegration --> DetectIntegrationType[Detect type:<br/>database → core,architecture<br/>logging → observability<br/>security → core,security]

    DetectIntegrationType --> LoadIntegrationConst[Load constitution sections]

    LoadIntegrationConst --> ExecuteIntegrationTask[Implement integration<br/>with proper error handling<br/>and observability]

    ExecuteIntegrationTask --> MarkCompleteIntegration[Mark task as [X] completed]

    MarkCompleteIntegration --> CompleteIntegration{All Integration<br/>tasks complete?}

    CompleteIntegration -->|No| IterateIntegration
    CompleteIntegration -->|Yes| StartPhase

    PhasePolish --> IteratePolish[For each Polish task [P]:<br/>- Unit tests<br/>- Performance<br/>- Documentation<br/>Can run parallel]

    IteratePolish --> ExecutePolishTask[Execute task:<br/>testing → testing,branching<br/>docs → branching]

    ExecutePolishTask --> CheckParallelPolish{Parallel [P]<br/>task?}

    CheckParallelPolish -->|Yes| RunParallelPolish[Execute in parallel]
    CheckParallelPolish -->|No| RunSequentialPolish[Execute sequentially]

    RunParallelPolish --> MarkCompletePolish[Mark task as [X] completed]
    RunSequentialPolish --> MarkCompletePolish

    MarkCompletePolish --> CompletePolish{All Polish<br/>tasks complete?}

    CompletePolish -->|No| IteratePolish
    CompletePolish -->|Yes| StartPhase

    AllDone[Verify all tasks marked [X]<br/>Report completion status]

    AllDone --> TaskError{Any task<br/>errors?}

    TaskError -->|Yes| ErrorReport[Report failed tasks<br/>Provide error context<br/>Suggest next steps]
    TaskError -->|No| Done([Complete: Implementation done<br/>Ready for @sdd-audit])

    ErrorReport --> Done

    style Start fill:#e1f5ff
    style Done fill:#d4edda
    style ErrorNoSpecs fill:#f8d7da
    style ErrorMultiple fill:#f8d7da
    style CountSpecs fill:#fff3cd
    style StartPhase fill:#fff3cd
    style CheckParallelTest fill:#fff3cd
    style CheckParallelCore fill:#fff3cd
    style CheckParallelPolish fill:#fff3cd
    style DetectCoreType fill:#fff3cd
    style DetectIntegrationType fill:#fff3cd
    style TaskError fill:#fff3cd
```

## Key Decision Points

1. **Feature Selection**: Auto-detect if only one spec exists
2. **Phase-by-Phase Execution**: Complete each phase before moving to next
3. **Constitutional Loading**: Just-in-time loading based on file type
4. **Parallel vs Sequential**: Respect task dependencies and file sharing
5. **TDD Approach**: Tests before implementation

## Constitutional Standards (Just-In-Time Loading)

### File Type Detection

- **Test files** (_.test._, _.spec._) → `testing,branching`
- **Service/business logic** (services/, handlers/) → `core,architecture,observability,branching`
- **Auth/security** (auth*, security*, validation\*) → `core,security,branching`
- **Database/models** (models/, entities/, repositories/) → `core,architecture,branching`
- **API/routes** (routes/, controllers/, endpoints/) → `core,architecture,security,branching`
- **Config/deployment** (_.yml, _.yaml, Dockerfile) → `operations,security,branching`
- **Logging/monitoring** (logger*, monitor*, metrics\*) → `observability,branching`

### Re-loading Strategy

When moving to a task in a different category, reload appropriate sections for efficiency.

## Implementation Phases

### 1. Setup

- Initialize project structure
- Install dependencies
- Configure linting and tools
- Execute sequentially

### 2. Tests [P]

- Contract tests (one per API endpoint)
- Integration tests (one per scenario)
- Can run in parallel
- TDD: Before implementation

### 3. Core

- Models (parallel if different files)
- Services (sequential if dependencies exist)
- Endpoints (based on file sharing)
- Apply coding standards, logging, error handling

### 4. Integration

- Database connections
- Middleware setup
- Logging configuration
- External service integration
- Add observability

### 5. Polish [P]

- Unit tests
- Performance optimization
- Documentation
- Can run in parallel

## Standards Applied During Implementation

From loaded constitutional sections:

### core

- Coding standards (error handling, logging, validation)
- Type safety, async patterns, modularity
- Secrets management

### architecture

- Service patterns, CRUD patterns
- API design, data model patterns
- Component structure

### security

- Input validation, authentication
- Authorization, encryption
- Secrets handling, threat protection

### testing

- Test organization, coverage requirements
- Mocking strategy, TDD approach
- Security testing patterns

### observability

- Structured logging, correlation IDs
- Metrics collection, distributed tracing
- Monitoring and alerting

### operations

- Deployment configuration
- Infrastructure as code
- CI/CD integration

## Output

- All tasks in `tasks.md` marked as [X] completed
- Implementation ready for code review and audit

## Next Step

Run `@sdd-audit feature-name` to validate implementation
