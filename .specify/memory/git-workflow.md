# Git Workflow Standards

## Branch Naming: `type/short-description`

**Rules**: 10-50 chars | lowercase | a-z,0-9,-,/ | from develop (hotfix from main)  
**Types**: feat, fix, chore, refactor, test, docs, hotfix, maintenance

**Valid**: `feat/add-payment-endpoint` `fix/auth-timeout` `docs/update-readme`  
**Invalid**: `123-fix` (starts number) `Fix_DB` (uppercase/\_) `user-auth` (no type)

## Branch Lifecycle

```
main (prod)          <-- hotfix/*        (critical)
  |                   \-- maintenance/*  (updates)
  v
develop (integrate)  <-- feature/*       (new features)
```

| Branch         | From         | To            | Merge Requires           |
| -------------- | ------------ | ------------- | ------------------------ |
| feature/\*     | develop      | develop       | Tests pass, PR review    |
| hotfix/\*      | main         | main, develop | Emergency approval       |
| maintenance/\* | main/develop | main, develop | Tests, security scan     |
| develop        | -            | main          | Audit, all tests, review |

## Commit Format: `type: brief description`

**Rules**: <=72 chars | imperative mood | lowercase type | match branch type

**Valid**: `feat: add user auth endpoint` `fix: resolve payment timeout` `docs: update API v2.1`  
**Invalid**: `added feature` (past tense) `bug fix` (no format) `FEAT: Add` (uppercase) `fix stuff` (vague)

**Types**: feat | fix | chore | refactor | test | docs | hotfix | maintenance
