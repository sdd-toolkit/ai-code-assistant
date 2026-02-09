# TODO: Remove Git Branch Creation

**Goal**: Remove automatic git branch checkout from the system while maintaining all other functionality.

**Date**: 2026-02-09  
**Status**: ✅ **IMPLEMENTATION COMPLETE**

---

## Overview

### Current Behavior

- `create-new-feature.sh` and `create-new-feature.ps1` automatically create and checkout git branches
- Branch names are generated from feature descriptions following git-workflow standards
- The system creates branches like `feat/feature-name`, `fix/bug-name`, etc.

### New Behavior

- Scripts will **NOT** create or checkout git branches
- Branch name generation logic remains (for directory naming and output)
- Users manage their own git branching workflow
- All other functionality (spec file creation, directory structure, validation) remains unchanged

### Key Changes Summary

- Remove `git checkout -b` commands from both scripts
- Update documentation to reflect manual git workflow
- Update flow diagrams to remove branch creation steps
- Keep branch name generation for directory naming consistency
- Update error messages and JSON output descriptions

---

## Files to Modify

### Phase 1: Core Scripts (CRITICAL)

#### 1. `.specify/scripts/bash/create-new-feature.sh`

**Location**: Line 31

**Current**:

```bash
git checkout -b "$BRANCH_NAME"
```

**Change**: Remove this line entirely

**Impact**:

- Script will no longer create git branches
- `BRANCH_NAME` still generated and used for directory naming
- JSON output still includes `BRANCH_NAME` for reference

**Additional Changes**:

- Line 6 comment: Update from "Create a new feature with branch, directory structure, and template" to "Create a new feature directory structure and template"

---

#### 2. `.specify/scripts/powershell/create-new-feature.ps1`

**Location**: Lines 44-48

**Current**:

```powershell
# Create new branch
git checkout -b "$branchName"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to create branch: $branchName"
    exit 1
}
```

**Change**: Remove these lines entirely (lines 44-48)

**Impact**:

- Script will no longer create git branches
- `$branchName` still generated and used for directory naming
- JSON output still includes `BRANCH_NAME` for reference

**Additional Changes**:

- Line 1 comment: Update from "Create a new feature with branch, directory structure, and template" to "Create a new feature directory structure and template"

---

### Phase 2: Documentation Updates

#### 3. `.specify/scripts/powershell/README.md`

**Location**: Line 40

**Current**:

```markdown
| `create-new-feature.ps1` | Create new feature with branch | `.\create-new-feature.ps1 "Feature Name"` |
```

**Change**:

```markdown
| `create-new-feature.ps1` | Create new feature directory | `.\create-new-feature.ps1 "Feature Name"` |
```

**Location**: Line 72

**Current**:

```powershell
# Create new feature and branch
.\create-new-feature.ps1 "Add User Authentication"
```

**Change**:

```powershell
# Create new feature directory
.\create-new-feature.ps1 "Add User Authentication"

# Manually create git branch if desired
git checkout -b feat/add-user-authentication
```

---

#### 4. `README.md`

**Location**: Line 198

**Current**:

```bash
# 2. Create specification with reference context (outputs branch name)
```

**Change**:

```bash
# 2. Create specification with reference context (outputs directory name)
```

**Location**: Line 340

**Current**:

```markdown
- Creates feature branches automatically
```

**Change**:

```markdown
- Creates feature directories with branch-compatible naming
```

**Additional Note**: Add a section explaining manual git workflow:

````markdown
**Note**: Git branch management is manual. The system generates branch-compatible directory names, but you control your git workflow:

```bash
# Create your branch manually
git checkout -b feat/your-feature-name

# Then create the specification
@sdd-specify "feat/your feature description"
```
````

````

---

#### 5. `docs/workflow-overview.md`

**Location**: Line 11

**Current**:
```mermaid
        S4[Create Git branch]
````

**Change**:

```mermaid
        S4[Create feature directory]
```

**Location**: Line 111

**Current**:

```markdown
- Creates Git branch automatically
```

**Change**:

```markdown
- Creates feature directory with branch-compatible naming
- Git branch management is manual
```

---

#### 6. `docs/flow-specify.md`

**Location**: Lines 15-17

**Current**:

```mermaid
    ValidateBranch -->|Valid| CreateBranch[Create compliant branch name<br/>type/short-description]

    CreateBranch --> RunScript[Run: create-new-feature.sh<br/>Parse JSON output]
```

**Change**:

```mermaid
    ValidateBranch -->|Valid| CreateDirName[Create compliant directory name<br/>type/short-description]

    CreateDirName --> RunScript[Run: create-new-feature.sh<br/>Parse JSON output]
```

**Location**: Line 38

**Current**:

```mermaid
    CreateSpec --> CreateBranchGit[Create Git branch and switch]

    CreateBranchGit --> Done([Complete: Spec created<br/>Ready for @sdd-plan])
```

**Change**:

```mermaid
    CreateSpec --> Done([Complete: Spec created<br/>Branch: Manual if desired<br/>Ready for @sdd-plan])
```

**Location**: Lines 69-70

**Current**:

```markdown
## Output Files

- `.specify/specs/feature-name/spec.md` - Feature specification
- Git branch created: `type/feature-description`
```

**Change**:

````markdown
## Output Files

- `.specify/specs/feature-name/spec.md` - Feature specification
- Directory name follows branch naming convention: `type/feature-description`

**Note**: Create your git branch manually if desired:

```bash
git checkout -b feat/feature-name
```
````

````

---

#### 7. `docs/viewer.html`

**Location**: Line 330

**Current**:
```javascript
        S5 --> S6[Create Git branch]
````

**Change**:

```javascript
        S5 --> S6[Create feature directory]
```

**Location**: Line 454

**Current**:

```markdown
          Validates branching standards, creates a feature specification, and sets up the Git branch for development.
```

**Change**:

```markdown
          Validates naming standards, creates a feature specification with branch-compatible directory naming.
```

**Location**: Line 493

**Current**:

```mermaid
    CreateSpec --> CreateBranchGit[Create Git branch and switch]
```

**Change**:

```mermaid
    CreateSpec --> Done[Complete: Feature directory created]
```

---

### Phase 3: Template & Prompt Updates

#### 8. `.specify/templates/commands/sdd-specify.md`

**Location**: Line 59

**Current**:

```markdown
0.1. **Summarize the feature description**: After validating the prefix, create a concise summary of the feature description that is 80 characters or less. This summary should capture the essential meaning while preserving the required type prefix and being suitable for use as a git branch name. Preserve key technical terms and maintain clarity.
```

**Change**:

```markdown
0.1. **Summarize the feature description**: After validating the prefix, create a concise summary of the feature description that is 80 characters or less. This summary should capture the essential meaning while preserving the required type prefix and being suitable for use as a directory name. Preserve key technical terms and maintain clarity.
```

**Location**: Line 65

**Current**:

```markdown
**Branch Name Generation**: The script automatically generates a git branch name from the summarized feature description by:
```

**Change**:

```markdown
**Directory Name Generation**: The script automatically generates a directory name from the summarized feature description by:
```

---

#### 9. `prompts/sdd-specify.md`

**Location**: Line 13

**Current**:

```markdown
- `@sdd-specify <feature_description> -type <branch_type>` - Create specification with specific branch type
```

**Change**:

```markdown
- `@sdd-specify <feature_description> -type <branch_type>` - Create specification with specific type prefix
```

**Location**: Line 20

**Current**:

```markdown
- **`-type <branch_type>`** (OPTIONAL): Git branch type - must be one of: `feat`, `fix`, `chore`, `refactor`, `test`, `docs`, `hotfix`, `maintenance` (defaults to `feat`)
```

**Change**:

```markdown
- **`-type <branch_type>`** (OPTIONAL): Feature type prefix - must be one of: `feat`, `fix`, `chore`, `refactor`, `test`, `docs`, `hotfix`, `maintenance` (defaults to `feat`)
```

**Location**: Line 107

**Current**:

```markdown
0.1. **Construct Full Feature Description**: Combine the branch type with the feature description to create the full branch-ready description:
```

**Change**:

```markdown
0.1. **Construct Full Feature Description**: Combine the type prefix with the feature description to create the full description:
```

**Location**: Line 113

**Current**:

```markdown
0.2. **Summarize the feature description**: Create a concise summary of the full feature description (including type prefix) that is 80 characters or less. This summary should capture the essential meaning while preserving the required type prefix and being suitable for use as a git branch name. Preserve key technical terms and maintain clarity.
```

**Change**:

```markdown
0.2. **Summarize the feature description**: Create a concise summary of the full feature description (including type prefix) that is 80 characters or less. This summary should capture the essential meaning while preserving the required type prefix and being suitable for use as a directory name. Preserve key technical terms and maintain clarity.
```

**Location**: Line 119

**Current**:

```markdown
**Branch Name Generation**: The script automatically generates a git branch name from the summarized feature description by:
```

**Change**:

```markdown
**Directory Name Generation**: The script automatically generates a directory name from the summarized feature description by:
```

**Add New Section After Line 130**:

````markdown
**Git Branch Management** (Manual):

The system no longer automatically creates git branches. If you want to use git branches:

1. Create your branch manually before or after running sdd-specify:
   ```bash
   git checkout -b feat/your-feature-name
   ```
````

2. The directory name will follow the same naming convention for consistency

3. This gives you full control over your git workflow

````

---

### Phase 4: Additional Considerations

#### 10. CHANGELOG.md

**Add New Entry**:

```markdown
## [Unreleased]

### Changed - BREAKING CHANGES

#### Git Branch Management Now Manual (2026-02-09)

**⚠️ Breaking Change**: The system no longer automatically creates or checks out git branches.

**What Changed:**

- `create-new-feature.sh` and `create-new-feature.ps1` no longer execute `git checkout -b`
- Branch name generation logic remains for directory naming
- Users now manage their own git branching workflow
- All other functionality (directory creation, spec files, validation) unchanged

**Why This Change:**

- Gives users full control over their git workflow
- Avoids conflicts with existing branch management strategies
- Prevents accidental branch creation
- Allows integration with different git workflows (GitHub Flow, GitFlow, trunk-based, etc.)

**Migration Guide:**

Before:
```bash
# Script automatically created and checked out branch
@sdd-specify "feat/add user authentication"
````

After:

```bash
# Create your branch manually (if desired)
git checkout -b feat/add-user-authentication

# Then create specification
@sdd-specify "feat/add user authentication"

# Or create specification first, then branch
@sdd-specify "feat/add user authentication"
git checkout -b feat/add-user-authentication
```

**Benefits:**

- ✅ No accidental branch creation
- ✅ Works with any git workflow strategy
- ✅ Users control when and how branches are created
- ✅ Compatible with monorepo and multi-repo setups
- ✅ No conflicts with CI/CD branch strategies

**Files Changed:**

- `.specify/scripts/bash/create-new-feature.sh` - Removed `git checkout -b`
- `.specify/scripts/powershell/create-new-feature.ps1` - Removed `git checkout -b` and error handling
- Documentation updated to reflect manual git workflow

```

---

## Testing Checklist

After implementation, verify:

- [ ] `create-new-feature.sh` creates directory structure without git branch
- [ ] `create-new-feature.ps1` creates directory structure without git branch
- [ ] JSON output still includes `BRANCH_NAME` field for reference
- [ ] Directory names follow branch naming convention
- [ ] Script exits successfully without git errors
- [ ] `--json` flag still works correctly
- [ ] Spec template is still copied correctly
- [ ] All documentation accurately reflects new behavior
- [ ] Flow diagrams updated correctly
- [ ] Users can still manually create branches if desired

---

## Benefits of This Change

### For Users:
- ✅ **Full control** over git workflow
- ✅ **No accidental branches** created
- ✅ **Flexibility** to use any branching strategy
- ✅ **Integration** with CI/CD systems
- ✅ **Monorepo friendly** - no forced branching

### For System:
- ✅ **Simpler scripts** - less git interaction
- ✅ **Fewer dependencies** on git state
- ✅ **Less error handling** needed
- ✅ **More portable** - works without git
- ✅ **Clearer separation** of concerns

### For Workflows:
- ✅ Compatible with **GitHub Flow**
- ✅ Compatible with **GitFlow**
- ✅ Compatible with **trunk-based development**
- ✅ Compatible with **custom workflows**
- ✅ No assumptions about branching strategy

---

## Implementation Notes

### What Stays the Same:
- ✅ Branch name generation logic (for directory naming)
- ✅ Directory structure creation
- ✅ Spec template copying
- ✅ JSON output format
- ✅ Validation of naming conventions
- ✅ All other scripts and workflows

### What Changes:
- ❌ No `git checkout -b` execution
- ❌ No git branch error handling
- ✅ Updated documentation and comments
- ✅ Updated flow diagrams
- ✅ Added manual git workflow notes

### Backward Compatibility:
- **BREAKING CHANGE**: Users relying on automatic branch creation will need to adapt
- **Migration Path**: Simple - just create branches manually
- **Impact**: Low - easy to adapt existing workflows

---

## File Count Summary

**Total Files to Modify**: 10

**Core Scripts**: 2
- `.specify/scripts/bash/create-new-feature.sh`
- `.specify/scripts/powershell/create-new-feature.ps1`

**Documentation**: 4
- `README.md`
- `docs/workflow-overview.md`
- `docs/flow-specify.md`
- `docs/viewer.html`

**PowerShell Docs**: 1
- `.specify/scripts/powershell/README.md`

**Templates & Prompts**: 2
- `.specify/templates/commands/sdd-specify.md`
- `prompts/sdd-specify.md`

**Changelog**: 1
- `CHANGELOG.md`

---

## Estimated Effort

- **Phase 1**: 15 minutes (core script changes - 2 simple deletions)
- **Phase 2**: 30 minutes (documentation updates)
- **Phase 3**: 20 minutes (template and prompt updates)
- **Phase 4**: 15 minutes (changelog and testing)

**Total**: ~1.5 hours of work

---

## Risk Assessment

| Risk Level | Impact | Mitigation |
|------------|--------|------------|
| **LOW** | Users must adapt to manual branching | Clear documentation, simple migration |
| **LOW** | Scripts may be called expecting branch creation | JSON output still includes BRANCH_NAME |
| **VERY LOW** | Breaking existing automation | Easy to update - just add git checkout before/after |

---

## Implementation Order

1. **Phase 1 (CRITICAL)**: Remove git commands from both scripts
2. **Phase 4**: Update CHANGELOG.md with breaking change notice
3. **Phase 2**: Update main documentation files
4. **Phase 3**: Update templates and prompts
5. **Testing**: Run through checklist to verify all changes

---

## Approval Checklist

- [x] Review all proposed changes
- [x] Confirm breaking change is acceptable
- [x] Verify migration path is clear
- [x] Approve documentation updates
- [x] Approve terminology changes (branch → directory)
- [x] Ready to implement

---

**Status**: ✅ **IMPLEMENTATION COMPLETE**

**Recommendation**: ✅ **READY FOR TESTING AND MERGE**
```
