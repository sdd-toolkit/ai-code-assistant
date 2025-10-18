# Constitution Testing Standards

<!--
Section: testing
Priority: high
Applies to: all projects
Dependencies: [core]
Version: 1.0.0
Last Updated: 2025-10-16
Project: Basic Node Application
-->

## 1. Test Coverage Standards

| Coverage Type | Requirement       | Threshold | Enforcement        |
| ------------- | ----------------- | --------- | ------------------ |
| **Overall**   | Unit tests        | 70%+      | Automated CI check |
| Critical Path | Core logic tested | 100%      | Manual review      |

---

## 2. Test Organization Standards

| Test Type      | Location           | Suffix   | Colocated | Priority |
| -------------- | ------------------ | -------- | --------- | -------- |
| **Unit Tests** | Same dir as source | .test.js | Yes       | MUST     |

### File Organization Examples

| Source File     | Test File            | Location Rule       |
| --------------- | -------------------- | ------------------- |
| `src/utils.js`  | `src/utils.test.js`  | Colocated unit test |
| `src/parser.js` | `src/parser.test.js` | Colocated unit test |

---

## 3. Test Type Requirements

### Unit Tests

| Requirement       | Description                          | Priority | Validation                |
| ----------------- | ------------------------------------ | -------- | ------------------------- |
| Colocation        | Must be next to source file          | MUST     | File structure            |
| Naming Convention | \*.test.js pattern                   | MUST     | Automated lint            |
| Test Framework    | Native Node.js test runner           | SHOULD   | package.json              |
| Fast Execution    | < 1s per test suite                  | SHOULD   | Performance               |
| No Database Tests | No database integration tests needed | N/A      | Project uses no databases |

### Test Data Management

**Database Test Data**: NOT APPLICABLE - This project does not use databases.

| Data Type          | Approach                   | Priority | Notes               |
| ------------------ | -------------------------- | -------- | ------------------- |
| **Mock Data**      | In-memory objects          | SHOULD   | For unit tests      |
| **File Fixtures**  | JSON files in test folders | COULD    | If testing file I/O |
| **No DB Fixtures** | No database seeding needed | N/A      | Databases excluded  |

---

## 4. Test Execution Requirements

| Requirement       | Description                    | Priority | Enforcement      |
| ----------------- | ------------------------------ | -------- | ---------------- |
| Pre-commit Tests  | Run tests before commit        | SHOULD   | Git hooks        |
| CI Pipeline Tests | Run all tests on PR            | MUST     | CI configuration |
| Test Isolation    | Tests must not depend on order | MUST     | Test framework   |
