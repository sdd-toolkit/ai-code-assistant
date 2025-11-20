# SDD Workflow Overview

Complete flow diagram showing how the core development prompts work together in the Specification Driven Development workflow.

```mermaid
flowchart TB
    subgraph Specify["@sdd-specify - Create Specification"]
        S1[User provides feature description]
        S2[Optional: -ref reference-folder]
        S3[Validate branching standards]
        S4[Create Git branch]
        S5[Generate spec.md]
        S6[Store reference context if provided]

        S1 --> S2 --> S3 --> S4 --> S5 --> S6
    end

    subgraph Plan["@sdd-plan - Design Implementation"]
        P1[Auto-detect or specify feature]
        P2[Load spec.md + reference context]
        P3[Load constitutional standards<br/>core,architecture,testing,branching]
        P4[Phase 0: Technical Research]
        P5[Phase 1: Design Artifacts<br/>data-model, contracts, quickstart]
        P6[Phase 2: Task Preview]
        P7[Generate plan.md]

        P1 --> P2 --> P3 --> P4 --> P5 --> P6 --> P7
    end

    subgraph Tasks["@sdd-tasks - Generate Task List"]
        T1[Auto-detect or specify feature]
        T2[Load plan.md + artifacts]
        T3[Detect task types needed]
        T4[Load relevant constitution sections]
        T5[Generate Setup tasks]
        T6[Generate Test tasks P]
        T7[Generate Core tasks]
        T8[Generate Integration tasks]
        T9[Generate Polish tasks P]
        T10[Order by dependencies<br/>Mark parallel tasks]
        T11[Create tasks.md]

        T1 --> T2 --> T3 --> T4 --> T5 --> T6 --> T7 --> T8 --> T9 --> T10 --> T11
    end

    subgraph Implement["@sdd-implement - Execute Implementation"]
        I1[Auto-detect or specify feature]
        I2[Load tasks.md + plan.md + artifacts]
        I3[Parse task phases & dependencies]
        I4[Phase: Setup]
        I5[Phase: Tests P]
        I6[Phase: Core]
        I7[Phase: Integration]
        I8[Phase: Polish P]
        I9[Just-in-time constitution loading<br/>per file type]
        I10[Apply standards & execute]
        I11[Mark tasks complete X]
        I12[All phases done]

        I1 --> I2 --> I3 --> I4 --> I5 --> I6 --> I7 --> I8
        I4 --> I9
        I5 --> I9
        I6 --> I9
        I7 --> I9
        I8 --> I9
        I9 --> I10 --> I11
        I11 --> I4
        I11 --> I5
        I11 --> I6
        I11 --> I7
        I11 --> I8
        I11 --> I12
    end

    subgraph Audit["@sdd-audit - Validate Implementation"]
        A1[Load spec.md + plan.md + tasks.md]
        A2[Validate implementation files exist]
        A3[Phase 1: Critical Standards Audit<br/>core, testing, security, branching]
        A4[Phase 2: Conditional Deep Dive<br/>architecture, observability, operations]
        A5[Calculate quality scores]
        A6[Generate audit-report.md]

        A1 --> A2 --> A3 --> A4 --> A5 --> A6
    end

    Start([Feature Request]) --> Specify
    Specify --> |spec.md created| Plan
    Plan --> |plan.md + artifacts| Tasks
    Tasks --> |tasks.md created| Implement
    Implement --> |implementation complete| Audit
    Audit --> Done([Validated Implementation<br/>Ready for production])

    style Start fill:#e1f5ff
    style Done fill:#d4edda
    style Specify fill:#fff3cd
    style Plan fill:#ffeaa7
    style Tasks fill:#fab1a0
    style Implement fill:#a29bfe
    style Audit fill:#74b9ff
```

## Workflow Stages

### 1. @sdd-specify - Create Specification

**Input**: Natural language feature description  
**Output**: `spec.md` with structured requirements  
**Key Features**:

- Validates against branching standards
- Creates Git branch automatically
- Optional reference context for enhanced specs
- Stores reference metadata for downstream use

**Files Created**:

- `.specify/specs/feature-name/spec.md`

---

### 2. @sdd-plan - Design Implementation

**Input**: Feature specification  
**Output**: Complete implementation plan with design artifacts  
**Key Features**:

- Loads reference context from spec automatically
- Phase-based execution with gate checks
- Generates technical research and design docs
- Creates API contracts and test scenarios

**Files Created**:

- `.specify/specs/feature-name/plan.md`
- `.specify/specs/feature-name/research.md`
- `.specify/specs/feature-name/data-model.md`
- `.specify/specs/feature-name/contracts/`
- `.specify/specs/feature-name/quickstart.md`

---

### 3. @sdd-tasks - Generate Task List

**Input**: Implementation plan + design artifacts  
**Output**: Dependency-ordered, executable task list  
**Key Features**:

- Context-aware constitutional loading
- Parallel task detection [P]
- TDD approach (tests before implementation)
- Dependency ordering across phases

**Files Created**:

- `.specify/specs/feature-name/tasks.md`

**Task Phases**:

1. **Setup** - Project initialization
2. **Tests [P]** - Contract & integration tests (parallel)
3. **Core** - Models, services, endpoints
4. **Integration** - Database, middleware, logging
5. **Polish [P]** - Unit tests, performance, docs (parallel)

---

### 4. @sdd-implement - Execute Implementation

**Input**: Task list + all design artifacts  
**Output**: Working implementation with all tasks completed  
**Key Features**:

- Phase-by-phase execution
- Just-in-time constitutional loading per file type
- Parallel task execution where possible
- Automatic task completion tracking [X]

**Constitutional Loading Strategy**:

- **Test files** → `testing,branching`
- **Services** → `core,architecture,observability,branching`
- **Auth/Security** → `core,security,branching`
- **Database** → `core,architecture,branching`
- **API/Routes** → `core,architecture,security,branching`
- **Config** → `operations,security,branching`
- **Logging** → `observability,branching`

---

### 5. @sdd-audit - Validate Implementation

**Input**: Complete feature implementation (spec.md + plan.md + tasks.md + code)  
**Output**: Quality audit report with compliance scores  
**Key Features**:

- Two-phase progressive audit strategy
- Requirements coverage validation
- Constitutional compliance checking
- Prioritized issue reporting with severity levels

**Audit Phases**:

1. **Phase 1 - Critical Standards** → `core,testing,security,branching`
2. **Phase 2 - Conditional Deep Dive** → `architecture,observability,operations` (if issues detected)

**Files Created**:

- `.specify/specs/feature-name/audit-report.md`

---

## Key Principles

### Reference Context Flow

1. **@sdd-specify**: Load reference folder once, store in spec.md
2. **@sdd-plan**: Read reference context from spec.md metadata
3. **@sdd-tasks**: Read reference context from spec.md metadata
4. **Benefit**: Reference files loaded once, reused 3x (67% reduction)

### Constitutional Loading Strategy

- **@sdd-specify**: `branching` (validation only)
- **@sdd-plan**: `core,architecture,testing,branching` (planning essentials)
- **@sdd-tasks**: Context-aware based on task types
- **@sdd-implement**: Just-in-time based on file type being implemented

### Parallel Execution

- **Tests [P]**: Can run simultaneously (different endpoints/scenarios)
- **Core**: Parallel if different files, sequential if same file
- **Polish [P]**: Can run simultaneously (unit tests, docs, perf)

### TDD Approach

Tests are generated and executed before their corresponding implementation:

1. Contract tests → Then endpoints
2. Integration tests → Then services
3. Unit tests → Then utilities

---

## Verification Points

Each stage has validation:

- **@sdd-specify**: Branching standards compliance
- **@sdd-plan**: Gate checks after each phase
- **@sdd-tasks**: Dependency order verification
- **@sdd-implement**: Task completion tracking

---

## Next Steps After Implementation

After `@sdd-implement` completes:

1. **@sdd-audit feature-name** - Validate implementation against spec
2. Code review and testing
3. Merge to main branch
4. Deploy to production

---

## File Structure Overview

```
.specify/
├── memory/
│   ├── constitution/            # Project-specific constitution files
│   │   ├── core.md             # Filled-in from core-template.md
│   │   ├── architecture.md     # Filled-in from architecture-template.md
│   │   ├── testing.md          # Filled-in from testing-template.md
│   │   ├── security.md         # Filled-in from security-template.md
│   │   ├── observability.md    # Filled-in from observability-template.md
│   │   └── user-interface.md   # Filled-in from user-interface-template.md (optional)
│   └── git-workflow.yaml        # Branch naming rules
├── reference/
│   └── <folder-name>/           # Optional reference context
├── specs/
│   └── <feature-name>/          # Feature workspace
│       ├── spec.md              # ← @sdd-specify creates this
│       ├── plan.md              # ← @sdd-plan creates this
│       ├── research.md          # ← @sdd-plan creates this
│       ├── data-model.md        # ← @sdd-plan creates this
│       ├── contracts/           # ← @sdd-plan creates this
│       ├── quickstart.md        # ← @sdd-plan creates this
│       └── tasks.md             # ← @sdd-tasks creates this
└── templates/
    ├── constitution/            # Pristine template files (never modified)
    │   ├── core-template.md             # Technology stack template
    │   ├── architecture-template.md     # Service patterns template
    │   ├── testing-template.md          # Test strategy template
    │   ├── security-template.md         # Security policies template
    │   ├── observability-template.md    # Logging standards template
    │   └── user-interface-template.md   # Project-specific template (optional)
    ├── spec-template.md
    ├── plan-template.md
    └── tasks-template.md
```

---

## Command Summary

```bash
# 1. Create specification
@sdd-specify "Add user authentication system"
@sdd-specify "Add user authentication system" -ref auth-patterns

# 2. Create implementation plan
@sdd-plan                    # Auto-detect feature
@sdd-plan user-auth          # Specify feature

# 3. Generate task list
@sdd-tasks                   # Auto-detect feature
@sdd-tasks user-auth         # Specify feature

# 4. Execute implementation
@sdd-implement               # Auto-detect feature
@sdd-implement user-auth     # Specify feature

# 5. Validate implementation
@sdd-audit                   # Auto-detect feature
@sdd-audit user-auth         # Specify feature
```

---

**Total Time Estimate**:

- @sdd-specify: 2-5 minutes
- @sdd-plan: 10-20 minutes
- @sdd-tasks: 5-10 minutes
- @sdd-implement: 30-120 minutes (depends on complexity)
- @sdd-audit: 5-15 minutes

**Total Files Created**: 8+ files per feature

---

## Additional Utility Prompts

Beyond the core development workflow, additional prompts support project management and quality:

### @sdd-init

- Create or update project constitution with semantic versioning
- Validate consistency across templates
- Generate sync impact reports

### @sdd-drift

- Detect constitutional drift across entire project
- Identify security, coding, architecture, testing, and operations gaps
- Generate prioritized remediation plans

**Usage**:

```bash
# Create project constitution
@sdd-init

# Check project-wide compliance
@sdd-drift
```
