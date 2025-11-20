# Constitution Security Standards

<!--
Section: security
Priority: critical
Applies to: all projects (especially backend)
Dependencies: [core]
Version: 1.0.0
Last Updated: [YYYY-MM-DD]
Project: [PROJECT_NAME]
-->

## 1. Core Security Principles

| Principle              | Requirement                 | Priority |
| ---------------------- | --------------------------- | -------- |
| **Least Privilege**    | [ACCESS_CONTROL_PRINCIPLE]  | MUST     |
| **Zero Trust**         | [ZERO_TRUST_IMPLEMENTATION] | MUST     |
| **Defense in Depth**   | [DEFENSE_IN_DEPTH_STRATEGY] | MUST     |
| **Fail Secure**        | [FAIL_SECURE_REQUIREMENTS]  | MUST     |
| **Complete Mediation** | [COMPLETE_MEDIATION_POLICY] | MUST     |

---

## 2. Authentication & Authorization

| Security Control      | Requirement                   | Priority |
| --------------------- | ----------------------------- | -------- |
| **Authentication**    | [AUTH_MECHANISM_REQUIREMENTS] | MUST     |
| Multi-Factor Auth     | [MFA_REQUIREMENTS]            | MUST     |
| Token Management      | [TOKEN_MANAGEMENT_POLICY]     | MUST     |
| Session Expiration    | [SESSION_TIMEOUT_POLICY]      | MUST     |
| **Authorization**     | [AUTHZ_MECHANISM]             | MUST     |
| RBAC Implementation   | [ROLE_BASED_ACCESS_CONTROL]   | MUST     |
| Permission Boundaries | [PERMISSION_BOUNDARY_POLICY]  | MUST     |
| Token Rotation        | [TOKEN_ROTATION_REQUIREMENTS] | MUST     |

---

## 3. Data Protection

| Protection Type           | Requirement                          | Priority |
| ------------------------- | ------------------------------------ | -------- |
| **Encryption at Rest**    | [ENCRYPTION_AT_REST_REQUIREMENTS]    | MUST     |
| **Encryption in Transit** | [ENCRYPTION_IN_TRANSIT_REQUIREMENTS] | MUST     |
| **PII Handling**          | [PII_HANDLING_POLICY]                | MUST     |
| Data Minimization         | [DATA_MINIMIZATION_POLICY]           | MUST     |
| **Data Classification**   | [DATA_CLASSIFICATION_STANDARDS]      | MUST     |
| Data Retention            | [DATA_RETENTION_POLICY]              | MUST     |
| Secure Deletion           | [SECURE_DELETION_REQUIREMENTS]       | MUST     |
| **Key Management**        | [KEY_MANAGEMENT_REQUIREMENTS]        | MUST     |

---

## 4. Input Validation & Output Sanitization

| Security Control         | Requirement                       | Priority |
| ------------------------ | --------------------------------- | -------- |
| **Input Validation**     | [INPUT_VALIDATION_SECURITY]       | MUST     |
| SQL Injection Prevention | [SQL_INJECTION_PREVENTION_METHOD] | MUST     |
| XSS Prevention           | [XSS_PREVENTION_MEASURES]         | MUST     |
| Command Injection        | [COMMAND_INJECTION_PREVENTION]    | MUST     |
| **Output Encoding**      | [OUTPUT_ENCODING_REQUIREMENTS]    | MUST     |
| CSP Headers              | [CSP_HEADER_REQUIREMENTS]         | MUST     |
| Path Traversal           | [PATH_TRAVERSAL_PREVENTION]       | MUST     |
| **Type Validation**      | [TYPE_VALIDATION_REQUIREMENTS]    | MUST     |

---

## 5. Secret Management

| Secret Type              | Requirement                   | Priority |
| ------------------------ | ----------------------------- | -------- |
| **API Keys**             | [API_KEY_MANAGEMENT]          | MUST     |
| **Database Credentials** | [DB_CREDENTIAL_MANAGEMENT]    | MUST     |
| **Encryption Keys**      | [ENCRYPTION_KEY_MANAGEMENT]   | MUST     |
| **JWT Secrets**          | [JWT_SECRET_REQUIREMENTS]     | MUST     |
| **Secret Rotation**      | [SECRET_ROTATION_POLICY]      | MUST     |
| Environment Separation   | [ENV_SEPARATION_REQUIREMENTS] | MUST     |

### Secret Prohibitions

[SECRET_HANDLING_PROHIBITIONS]

---

## 6. Security Logging & Monitoring

| Event Type                 | Logging Requirement              | Priority |
| -------------------------- | -------------------------------- | -------- |
| **Authentication Events**  | [AUTH_LOGGING_REQUIREMENTS]      | MUST     |
| Failed Login Attempts      | [FAILED_LOGIN_LOGGING_POLICY]    | MUST     |
| **Authorization Failures** | [AUTHZ_LOGGING_REQUIREMENTS]     | MUST     |
| Privilege Escalation       | [PRIVILEGE_ESCALATION_LOGGING]   | MUST     |
| **Data Access**            | [DATA_ACCESS_LOGGING]            | MUST     |
| Privileged Operations      | [PRIVILEGED_OPERATIONS_LOGGING]  | MUST     |
| **Security Events**        | [SECURITY_EVENT_LOGGING]         | MUST     |
| Anomaly Detection          | [ANOMALY_DETECTION_REQUIREMENTS] | SHOULD   |

---

## 7. Secure Coding Practices

| Practice Area            | Requirement                         | Priority |
| ------------------------ | ----------------------------------- | -------- |
| **Dependency Scanning**  | [DEPENDENCY_SCANNING_REQUIREMENTS]  | MUST     |
| **Code Scanning**        | [STATIC_ANALYSIS_SECURITY_TESTING]  | MUST     |
| **Threat Modeling**      | [THREAT_MODELING_REQUIREMENTS]      | SHOULD   |
| **Security Code Review** | [SECURITY_CODE_REVIEW_REQUIREMENTS] | MUST     |
