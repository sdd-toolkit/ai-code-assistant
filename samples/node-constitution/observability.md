# Constitution Observability Standards

<!--
Section: observability
Priority: low
Applies to: basic applications
Dependencies: [core]
Version: 1.0.0
Last Updated: 2025-10-16
Project: Basic Node Application
Note: Basic console logging only
-->

## 1. Logging Standards

### Console Logging

| Level | When to Use         | Example                         |
| ----- | ------------------- | ------------------------------- |
| log   | General information | `console.log('Starting...')`    |
| error | Error conditions    | `console.error('Failed:', err)` |
| warn  | Warning conditions  | `console.warn('Deprecated...')` |

### Logging Best Practices

| Practice        | Requirement               | Priority |
| --------------- | ------------------------- | -------- | -------------------------------------- |
| Error Context   | Include error message     | MUST     |
| No Secrets      | Never log sensitive data  | MUST     |
| Readable Format | Clear, concise messages   | SHOULD   |
| No DB Queries   | No database query logging | N/A      | Databases are not used in this project |

### Data Logging Guidelines

**Database Logging**: NOT APPLICABLE - This project does not use databases.

| Log Type       | Guideline             | Priority | Notes                    |
| -------------- | --------------------- | -------- | ------------------------ |
| **File I/O**   | Log file operations   | COULD    | If using file storage    |
| **API Calls**  | Log external requests | SHOULD   | If calling external APIs |
| **No DB Logs** | No SQL query logging  | N/A      | No database in project   |

---
