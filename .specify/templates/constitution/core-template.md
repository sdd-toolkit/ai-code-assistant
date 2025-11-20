# Constitution Core Standards

<!--
Section: core
Priority: critical
Applies to: all projects
Version: 1.0.0
Last Updated: [YYYY-MM-DD]
Project: [PROJECT_NAME]
-->

## 1. Technology Stack Standards

| Component            | Requirement                       | Priority |
| -------------------- | --------------------------------- | -------- |
| **Runtime**          | [RUNTIME_TECHNOLOGY]              | MUST     |
| **Language**         | [LANGUAGE] [VERSION_REQUIREMENT]  | MUST     |
| Language Strictness  | [LANGUAGE_STRICTNESS_REQUIREMENT] | MUST     |
| Language Linting     | [LANGUAGE_LINTING_REQUIREMENT]    | MUST     |
| **Compute Platform** | [COMPUTE_PLATFORM]                | MUST     |
| **Database**         | [DATABASE_TECHNOLOGY]             | MUST     |

### Technology Prohibitions (WON'T without RFC)

- Alternative runtimes without formal RFC approval
- [PROHIBITED_LANGUAGE_PRACTICE]
- [DEPRECATED_LANGUAGE_FEATURE]
- Alternative compute platforms without RFC approval
- Alternative databases without RFC approval

---

## 2. Coding Standards

| Area               | Standard                      | Enforcement |
| ------------------ | ----------------------------- | ----------- |
| **Language**       | [LANGUAGE_STANDARD]           | MUST        |
| **Type Safety**    | [TYPE_SAFETY_REQUIREMENTS]    | MUST        |
| **Async Patterns** | [ASYNC_PATTERN_REQUIREMENTS]  | MUST        |
| **Modularity**     | [MODULARITY_STANDARDS]        | MUST        |
| **Error Handling** | [ERROR_HANDLING_PATTERN]      | MUST        |
| **Logging**        | See observability-template.md | MUST        |
| **Secrets**        | See security-template.md      | MUST        |
| **Validation**     | See security-template.md      | MUST        |
| **DTOs/Models**    | [DTO_NAMING_CONVENTIONS]      | MUST        |

### Error Handling Example

```typescript
try {
  const result = await operation();
  return result;
} catch (error) {
  logger.error("Operation failed", { correlationId, error });
  throw error;
}
```

### Core Requirements

- **Error Handling**: Use try-catch, log with correlation ID, provide context
- **DTOs**: Clear naming, type annotations, immutability preferred, validation methods

---

## 3. Enforcement and Validation

| Standard Area      | Enforcement Level | Validation Method     | Automated |
| ------------------ | ----------------- | --------------------- | --------- |
| Language Standards | Mandatory         | Linting + Compilation | Yes       |
| Type Safety        | Mandatory         | Compile-time          | Yes       |
| Error Handling     | Mandatory         | Linting + Review      | Partial   |
| Architecture       | Mandatory         | Architecture review   | No        |
