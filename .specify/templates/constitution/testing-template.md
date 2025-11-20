# Constitution Testing Standards

<!--
Section: testing
Priority: critical
Applies to: all projects
Dependencies: [core]
Version: 1.0.0
Last Updated: [YYYY-MM-DD]
Project: [PROJECT_NAME]
-->

## 1. Test Coverage Standards

| Coverage Type | Requirement              | Threshold             |
| ------------- | ------------------------ | --------------------- |
| **Overall**   | [COVERAGE_REQUIREMENTS]  | [COVERAGE_PERCENT]    |
| Statement     | [STATEMENT_COVERAGE_REQ] | [STATEMENT_THRESHOLD] |
| Branch        | [BRANCH_COVERAGE_REQ]    | [BRANCH_THRESHOLD]    |
| Function      | [FUNCTION_COVERAGE_REQ]  | [FUNCTION_THRESHOLD]  |
| Exclusions    | [COVERAGE_EXCLUSIONS]    | N/A                   |

---

## 2. Test Organization Standards

| Test Type             | Location                 | Suffix               | Colocated | Priority |
| --------------------- | ------------------------ | -------------------- | --------- | -------- |
| **Unit Tests**        | [UNIT_TEST_LOCATION]     | [UNIT_TEST_SUFFIX]   | Yes       | MUST     |
| **Contract Tests**    | [CONTRACT_TEST_LOCATION] | [CONTRACT_SUFFIX]    | Yes       | MUST     |
| **Integration Tests** | [INTEGRATION_DIRECTORY]  | [INTEGRATION_SUFFIX] | No        | MUST     |
| **Security Tests**    | [SECURITY_TEST_LOCATION] | [SECURITY_SUFFIX]    | Yes       | MUST     |
| **Flow Tests**        | [FLOW_TEST_DIRECTORY]    | [FLOW_SUFFIX]        | No        | SHOULD   |
| **Performance Tests** | [PERFORMANCE_DIRECTORY]  | [PERF_SUFFIX]        | No        | COULD    |

### File Organization Examples

[TEST_FILE_ORGANIZATION_EXAMPLES]

---

## 3. Test Type Requirements

### Unit Tests

| Requirement           | Description                   | Priority |
| --------------------- | ----------------------------- | -------- |
| Colocation            | [UNIT_TEST_COLOCATION_POLICY] | MUST     |
| Naming Convention     | [UNIT_TEST_NAMING]            | MUST     |
| Mocking Allowed       | [UNIT_TEST_MOCKING_POLICY]    | MUST     |
| External Dependencies | [EXTERNAL_DEPENDENCY_MOCKING] | MUST     |
| Fast Execution        | [UNIT_TEST_SPEED_REQUIREMENT] | SHOULD   |

### Integration Tests

| Requirement     | Description                         | Priority |
| --------------- | ----------------------------------- | -------- |
| Location        | [INTEGRATION_TEST_LOCATION_POLICY]  | MUST     |
| Real Services   | [INTEGRATION_TEST_MOCKING_SCOPE]    | MUST     |
| Setup/Teardown  | [INTEGRATION_TEST_LIFECYCLE_POLICY] | MUST     |
| Logging         | [INTEGRATION_TEST_LOGGING_REQ]      | MUST     |
| Error Scenarios | [INTEGRATION_TEST_ERROR_SCENARIOS]  | MUST     |

### Contract Tests

| Requirement            | Description                          | Priority |
| ---------------------- | ------------------------------------ | -------- |
| API Contracts          | [CONTRACT_TEST_REQUIREMENTS]         | MUST     |
| Schema Validation      | [CONTRACT_SCHEMA_VALIDATION_POLICY]  | MUST     |
| Backward Compatibility | [CONTRACT_COMPATIBILITY_TEST_POLICY] | MUST     |
| Consumer-Driven        | [CONSUMER_DRIVEN_CONTRACT_POLICY]    | SHOULD   |

---

## 4. Security Testing Standards

| Test Category        | Requirement                       | Priority |
| -------------------- | --------------------------------- | -------- |
| **Authentication**   | [AUTH_TEST_REQUIREMENTS]          | MUST     |
| Token Validation     | [TOKEN_VALIDATION_TEST_SCENARIOS] | MUST     |
| Session Management   | [SESSION_TEST_REQUIREMENTS]       | MUST     |
| **Authorization**    | [AUTHZ_TEST_REQUIREMENTS]         | MUST     |
| Permission Checks    | [PERMISSION_TEST_COMBINATIONS]    | MUST     |
| **Input Validation** | [INPUT_VALIDATION_TEST_REQ]       | MUST     |
| Sanitization         | [OUTPUT_SANITIZATION_TEST_POLICY] | MUST     |
| **Cryptography**     | [CRYPTO_TEST_REQUIREMENTS]        | MUST     |
| Key Rotation         | [KEY_ROTATION_TEST_REQUIREMENTS]  | SHOULD   |

### Penetration Testing

| Test Type          | Requirement                       | Priority |
| ------------------ | --------------------------------- | -------- |
| Automated Scans    | [AUTOMATED_PENTEST_REQ]           | MUST     |
| Manual Testing     | [MANUAL_PENTEST_REQUIREMENTS]     | SHOULD   |
| Vulnerability Scan | [VULNERABILITY_SCAN_REQUIREMENTS] | MUST     |
| Security Baseline  | [SECURITY_BASELINE_VALIDATION]    | MUST     |

---

## 5. Mocking Standards

| Context               | Mocking Policy                    | Priority |
| --------------------- | --------------------------------- | -------- |
| **Unit Tests**        | [UNIT_TEST_MOCKING_PERMISSIONS]   | MUST     |
| External Services     | [EXTERNAL_SERVICE_MOCKING_POLICY] | MUST     |
| Database Calls        | [DATABASE_MOCKING_POLICY]         | MUST     |
| **Integration Tests** | [INTEGRATION_MOCKING_SCOPE]       | MUST     |
| Critical Services     | [CRITICAL_SERVICE_MOCKING_POLICY] | MUST     |
| Third-party APIs      | [THIRD_PARTY_MOCKING_POLICY]      | SHOULD   |

### Mocking Best Practices

| Practice             | Requirement                            | Priority |
| -------------------- | -------------------------------------- | -------- |
| Consistent Framework | [MOCKING_FRAMEWORK]                    | MUST     |
| Realistic Behavior   | [MOCK_RESPONSE_REALISM_POLICY]         | MUST     |
| Verify Interactions  | [MOCK_INTERACTION_VERIFICATION_POLICY] | SHOULD   |
| Clear Mock Setup     | [MOCK_DOCUMENTATION_REQUIREMENTS]      | SHOULD   |
| Test Isolation       | [TEST_ISOLATION_REQUIREMENTS]          | MUST     |

---

## 6. Test Execution Requirements

| Requirement        | Description                   | Priority |
| ------------------ | ----------------------------- | -------- |
| Test Isolation     | [TEST_ISOLATION_REQUIREMENTS] | MUST     |
| Parallel Execution | [PARALLEL_TEST_POLICY]        | SHOULD   |
