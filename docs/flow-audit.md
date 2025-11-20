# @sdd-audit Flow Diagram

```mermaid
flowchart TD
    Start([User: @sdd-audit feature-name]) --> CheckSpecs{Check for specs<br/>with required files}

    CheckSpecs -->|None| ErrorNoSpec[ERROR: No specs found<br/>Run @sdd-specify first<br/>STOP]
    CheckSpecs -->|Multiple| PromptSelect[Show available features<br/>Prompt user to specify]
    CheckSpecs -->|Single| ValidateFiles

    PromptSelect --> UserSelect[User: @sdd-audit feature-name]
    UserSelect --> ValidateFiles[Verify required files exist:<br/>- spec.md<br/>- plan.md<br/>- tasks.md]

    ValidateFiles --> CheckMissing{All files<br/>present?}
    CheckMissing -->|No| ErrorMissing[ERROR: Missing required files<br/>Cannot audit<br/>STOP]
    CheckMissing -->|Yes| LoadTemplate[Load audit-template.md]

    LoadTemplate --> LoadDocs[Load specification documents:<br/>- spec.md (requirements)<br/>- plan.md (architecture)<br/>- tasks.md (expectations)]

    LoadDocs --> CheckRef{Reference context<br/>exists?}
    CheckRef -->|Yes| LoadRefContext[Load reference context<br/>for patterns & standards]
    CheckRef -->|No| Phase1Load

    LoadRefContext --> Phase1Load[Phase 1: Load Critical Standards<br/>core, testing, security, branching]

    Phase1Load --> AuditPhase1[Phase 1 Audit:<br/>- Requirements coverage<br/>- Acceptance criteria<br/>- Task completion<br/>- Core code quality<br/>- Testing standards<br/>- Security compliance<br/>- Branching compliance]

    AuditPhase1 --> CalcScore1[Calculate Phase 1<br/>Quality Score]

    CalcScore1 --> DetectIssues{Issues detected<br/>in Phase 1?}

    DetectIssues -->|No major issues| GenerateReport[Generate audit report]
    DetectIssues -->|Architecture issues| LoadArch[Phase 2: Load architecture section]
    DetectIssues -->|Observability issues| LoadObs[Phase 2: Load observability section]
    DetectIssues -->|Operations issues| LoadOps[Phase 2: Load operations section]

    LoadArch --> AuditPhase2[Phase 2 Audit:<br/>Deep dive into specific areas]
    LoadObs --> AuditPhase2
    LoadOps --> AuditPhase2

    AuditPhase2 --> CalcScore2[Calculate Phase 2<br/>Quality Score]

    CalcScore2 --> GenerateReport

    GenerateReport --> CreateAuditReport[Create audit-report.md:<br/>- Executive summary<br/>- Quality metrics<br/>- Compliance status<br/>- Issues by category<br/>- Recommendations<br/>- Action items]

    CreateAuditReport --> SaveReport[Save to feature directory:<br/>.specify/specs/feature-name/<br/>audit-report.md]

    SaveReport --> ShowSummary[Display summary:<br/>- Overall score<br/>- Critical issues count<br/>- Recommendations<br/>- Next actions]

    ShowSummary --> Done([Complete: Audit report created<br/>Review findings])

    style Start fill:#e1f5ff
    style Done fill:#d4edda
    style ErrorNoSpec fill:#f8d7da
    style ErrorMissing fill:#f8d7da
    style CheckMissing fill:#fff3cd
    style DetectIssues fill:#fff3cd
    style CheckRef fill:#fff3cd
```

## Key Decision Points

### 1. **File Validation Check**

**Location**: After feature selection  
**Purpose**: Ensure all required files exist before starting audit  
**Decision Logic**:

- ✅ All files present → Continue to audit
- ❌ Missing files → Stop with error

**Why Important**: Cannot audit without complete specification, plan, and task list.

---

### 2. **Reference Context Check**

**Location**: Before Phase 1 loading  
**Purpose**: Determine if reference patterns and standards should be loaded  
**Decision Logic**:

- If spec.md contains reference metadata → Load reference context
- Otherwise → Skip to Phase 1 constitutional loading

**Why Important**: Reference context provides domain-specific patterns to audit against.

---

### 3. **Phase 1 Issues Detection**

**Location**: After initial audit completion  
**Purpose**: Determine if additional constitutional sections need loading  
**Decision Logic**:

- No major issues → Generate report immediately
- Architecture issues → Load `architecture` section
- Observability issues → Load `observability` section
- Operations issues → Load `operations` section

**Why Important**: Progressive loading reduces context size while ensuring thorough coverage.

---

## Two-Phase Audit Strategy

### Phase 1: Critical Compliance (Always Loaded)

**Sections**: `core`, `testing`, `security`, `branching`

**What's Audited**:

- ✅ **Requirements Coverage** - All functional requirements implemented
- ✅ **Acceptance Criteria** - Test against each scenario from spec.md
- ✅ **Technical Alignment** - Implementation matches plan.md architecture
- ✅ **Task Completion** - All tasks marked complete [X]
- ✅ **Code Quality** - Error handling, logging, validation
- ✅ **Testing Standards** - Coverage, organization, security tests
- ✅ **Security Compliance** - No secrets, input sanitization, auth/authz
- ✅ **Branching Standards** - Branch names and commits follow rules

**Purpose**: Phase 1 covers ~80% of common compliance issues with minimal context.

---

### Phase 2: Deep Dive (Conditional Loading)

**Sections**: Loaded only if specific issues detected

**Conditional Sections**:

- 🏗️ **Architecture** - If architectural violations found

  - Design patterns
  - Module structure
  - Separation of concerns
  - API contracts

- 📊 **Observability** - If logging/monitoring issues found

  - Structured logging
  - Metrics collection
  - Trace correlation
  - Alert thresholds

- ⚙️ **Operations** - If deployment/config issues found
  - CI/CD pipelines
  - Environment configuration
  - Deployment strategies
  - Infrastructure as code

**Purpose**: Only load additional context when Phase 1 reveals specific gaps.

---

## Audit Report Structure

The generated `audit-report.md` includes:

### 1. Executive Summary

- Overall quality score (0-100)
- High-level compliance status
- Critical issues count
- Recommended next actions

### 2. Quality Metrics

- Requirements coverage percentage
- Acceptance criteria pass rate
- Task completion percentage
- Test coverage metrics
- Security compliance score

### 3. Compliance Status

- ✅ Compliant areas
- ⚠️ Areas needing attention
- ❌ Non-compliant areas
- 📋 Not applicable sections

### 4. Issues by Category

Each issue includes:

- **Severity**: Critical / High / Medium / Low
- **Category**: Requirements / Code Quality / Testing / Security / etc.
- **Description**: What's wrong
- **Location**: File path and line number
- **Expected**: What the constitution requires
- **Actual**: Current implementation state
- **Recommendation**: How to fix

### 5. Action Items

Prioritized TODO list:

- Critical issues to fix immediately
- High-priority improvements
- Medium-priority enhancements
- Low-priority optimizations

---

## Output Files

### Primary Output

```
.specify/specs/<feature-name>/audit-report.md
```

**Contains**: Complete audit results with metrics, issues, and recommendations

---

## Next Steps After Audit

### If Audit Passes (Score ≥ 90%)

```bash
# Feature is production-ready
git push origin feature/branch-name

# Create pull request
@pr
```

### If Issues Found (Score < 90%)

```bash
# Review audit report
cat .specify/specs/<feature-name>/audit-report.md

# Fix critical issues first
# Re-run audit to verify fixes
@sdd-audit <feature-name>
```

### If Major Refactoring Needed (Score < 70%)

```bash
# Review architectural issues
# Update plan if needed
@sdd-plan <feature-name>

# Regenerate tasks
@sdd-tasks <feature-name>

# Re-implement problem areas
@sdd-implement <feature-name>

# Re-audit
@sdd-audit <feature-name>
```

---

## Benefits of Two-Phase Audit

### Efficiency

- **80% coverage** with minimal Phase 1 context
- **20% additional** only when issues detected
- **Average 60% token reduction** vs full constitution loading

### Thoroughness

- **Critical areas always checked** (security, testing, core standards)
- **Deep dives only when needed** (architecture, observability, operations)
- **Progressive coverage** ensures nothing important is missed

### Actionable Results

- **Clear quality score** (0-100)
- **Prioritized issues** (Critical → Low)
- **Specific recommendations** with file paths
- **Next action guidance** based on score

---

## Common Audit Failures

### Critical Issues (Stop Development)

- ❌ Exposed secrets or API keys
- ❌ SQL injection vulnerabilities
- ❌ Missing authentication/authorization
- ❌ Unhandled error conditions causing crashes

### High Priority Issues (Fix Before Merge)

- ⚠️ Missing required test coverage
- ⚠️ Incomplete error handling
- ⚠️ Missing input validation
- ⚠️ Security logging gaps

### Medium Priority Issues (Fix Soon)

- 📋 Incomplete documentation
- 📋 Missing integration tests
- 📋 Code duplication
- 📋 Performance concerns

### Low Priority Issues (Technical Debt)

- 💡 Style inconsistencies
- 💡 Minor optimization opportunities
- 💡 Additional test cases
- 💡 Enhanced logging

---

## Related Commands

- `@sdd-specify` - Create feature specification
- `@sdd-plan` - Design implementation
- `@sdd-tasks` - Generate task list
- `@sdd-implement` - Execute implementation
- **`@sdd-audit`** - Validate implementation ← You are here
- `@sdd-drift` - Detect constitutional drift across entire project

---

**Last Updated**: October 12, 2025  
**Version**: 0.2.0
