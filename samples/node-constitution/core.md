# Constitution Core Standards

<!--
Section: core
Priority: critical
Applies to: all projects
Version: 1.0.0
Last Updated: 2025-10-16
Project: Basic Node Application
-->

## 1. Technology Stack Standards

| Component       | Requirement        | Priority | Notes                                                                                              |
| --------------- | ------------------ | -------- | -------------------------------------------------------------------------------------------------- |
| **Runtime**     | Node.js >=18.0.0   | MUST     | LTS version                                                                                        |
| **Language**    | JavaScript ES2022+ | MUST     | Modern JS                                                                                          |
| Language Lint   | ESLint             | MUST     | Code quality                                                                                       |
| **File System** | Local file system  | MUST     | Basic I/O only                                                                                     |
| **Database**    | None (excluded)    | MUST NOT | No database required. Use file-based storage, in-memory data structures, or stateless architecture |

### Data Storage Philosophy

This project explicitly excludes databases to maintain simplicity. Data persistence options:

- **File-based storage**: JSON, CSV, or text files
- **In-memory**: JavaScript objects, Maps, Sets for runtime data
- **Stateless**: API-only with no data persistence
- **Third-party services**: External APIs for data needs (if required)

---

## 2. Coding Standards

| Area               | Standard                           | Enforcement | Validation        |
| ------------------ | ---------------------------------- | ----------- | ----------------- |
| **Language**       | ESLint recommended config          | MUST        | Automated linting |
| **Async Patterns** | async/await preferred over Promise | MUST        | Code review       |
| **Modularity**     | ES6 modules (import/export)        | MUST        | Code review       |
| **Error Handling** | try/catch blocks for async code    | MUST        | Code review       |

### Error Handling Example

```javascript
try {
  const result = await operation();
  return result;
} catch (error) {
  console.error("Operation failed:", error.message);
  throw error;
}
```

---

## 3. Enforcement and Validation

| Standard Area      | Enforcement Level | Validation Method | Automated | Frequency    |
| ------------------ | ----------------- | ----------------- | --------- | ------------ |
| Language Standards | Mandatory         | Linting           | Yes       | Every commit |
| Error Handling     | Mandatory         | Code review       | No        | Per PR       |
| Modularity         | Mandatory         | Code review       | No        | Per PR       |
