# Constitution Architecture Standards

<!--
Section: architecture
Priority: medium
Applies to: all projects
Dependencies: [core]
Version: 1.0.0
Last Updated: 2025-10-16
Project: Basic Node Application
-->

## 1. Architectural Principles

| Principle          | Description                    | Priority | Implementation   |
| ------------------ | ------------------------------ | -------- | ---------------- |
| **Design Pattern** | Simple functional modules      | SHOULD   | Pure functions   |
| **Modularity**     | One file per logical component | MUST     | Clear separation |
| **Error Handling** | Propagate errors to caller     | MUST     | throw/try-catch  |

---

## 2. File Organization

| Component   | Responsibility                 | Pattern         | Notes                                         |
| ----------- | ------------------------------ | --------------- | --------------------------------------------- |
| **Index**   | Main entry point               | index.js        | Application start                             |
| **Modules** | Isolated functionality         | src/\*.js       | Reusable logic                                |
| **Utils**   | Helper functions               | src/utils/\*.js | Pure functions                                |
| **Data**    | File-based storage (if needed) | data/\*.json    | No database - use files if persistence needed |

### Data Persistence Guidelines

**IMPORTANT**: This project does not use databases.

| Approach         | When to Use                   | Implementation                                   |
| ---------------- | ----------------------------- | ------------------------------------------------ |
| **In-Memory**    | Temporary, runtime-only data  | JavaScript objects                               |
| **File-Based**   | Persistent configuration/data | JSON/CSV files                                   |
| **Stateless**    | API-only, no persistence      | Request/response                                 |
| **NO Databases** | Never                         | PostgreSQL, MySQL, MongoDB, Redis - ALL EXCLUDED |

---

## 3. Code Organization Standards

| Guideline        | Requirement                   | Priority | When Required     |
| ---------------- | ----------------------------- | -------- | ----------------- |
| **File Naming**  | kebab-case.js                 | MUST     | All files         |
| **Exports**      | Named exports preferred       | SHOULD   | Public interfaces |
| **Dependencies** | Minimal external dependencies | SHOULD   | Reduce complexity |
