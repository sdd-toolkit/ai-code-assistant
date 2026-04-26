<!--
Copyright (c) Github Speckit
Modified by Trentin Barnard, 2025
MIT License
-->

# Feature Specification: [FEATURE NAME]

**Feature Branch**: `[feature-name]`  
**Created**: [DATE]  
**Status**: Draft  
**Input**: User description: "$ARGUMENTS"

## Execution Flow (main)

```
1. Parse user description from Input
   → If empty: ERROR "No feature description provided"
2. Extract key concepts from description
   → Identify: actors, actions, user-visible outcomes, business rules, constraints, and explicit non-goals
3. For each unclear aspect or missing scope boundary:
   → Mark with [NEEDS CLARIFICATION: specific question]
4. Fill User Scenarios & Testing section
   → Promote each required observable success, invalid, empty, error, or terminal scenario into Acceptance Criteria when the source supports it
   → Do not rely on Edge Cases alone for required user-visible invalid or terminal behavior
   → If no clear user flow: ERROR "Cannot determine user scenarios"
5. Generate Functional Requirements and Business Rules
   → Each requirement must be testable
   → Preserve exact user-facing copy and terminal behavior when clearly specified
   → If the prompt or validated reference clearly specifies how entered values are treated in a way that affects validation, matching, ordering, eligibility, or displayed output, preserve that behavior in business language
   → Do not infer hidden input-handling rules from visual design alone, and do not infer persistence, retries, hidden side effects, or extra navigation unless clearly required by the prompt or validated reference
6. Fill Assumptions & Scope Boundaries
   → Record explicit non-goals, prohibited behaviors, and limited-scope constraints
7. Identify Key Entities (if data involved)
8. Run Review Checklist
   → If any [NEEDS CLARIFICATION]: WARN "Spec has uncertainties"
   → If implementation details found: ERROR "Remove tech details"
   → Ensure the Review Checklist and Execution Status reflect the actual document state
9. Return: SUCCESS (spec ready for planning)
```

---

## ⚡ Quick Guidelines

- ✅ Focus on WHAT users need and WHY
- ❌ Avoid HOW to implement (no tech stack, APIs, code structure)
- ❌ Keep design references in business language only (no implementation identifiers, source-specific handles, or file paths)
- ❌ Do not copy tech stack, framework names, CSS declarations, component identifiers, or code structure from top-priority reference artifacts into the spec
- ❌ Do not infer behaviors not clearly requested or validated (for example normalization, persistence, retries, background side effects, or extra navigation)
- ✅ State scope boundaries and prohibited behaviors explicitly when the feature is limited or prototype-only
- 👥 Written for business stakeholders, not developers

### Section Requirements

- **Mandatory sections**: Must be completed for every feature
- **Optional sections**: Include only when relevant to the feature
- When the source defines multiple distinct observable outcomes, each required outcome should appear as an explicit acceptance criterion
- When a section doesn't apply, remove it entirely (don't leave as "N/A")

### For AI Generation

When creating this spec from a user prompt:

1. **Mark all ambiguities**: Use [NEEDS CLARIFICATION: specific question] for any assumption you'd need to make
2. **Don't guess**: If the prompt doesn't specify something (e.g., "login system" without auth method), mark it
3. **Think like a tester**: Every vague requirement should fail the "testable and unambiguous" checklist item
4. **Common underspecified areas**:
   - User types and permissions
   - Data retention/deletion policies
   - Performance targets and scale
   - Error handling behaviors
   - Integration requirements
   - Security/compliance needs
5. **If design references are provided**: Treat all validated reference artifacts as authoritative inputs, then translate them into user-visible behavior, validation expectations, content requirements, accessibility outcomes, and responsive behavior. Do not copy implementation details from design-tool exports, CSS specs, or code-oriented design artifacts into the spec, and do not infer hidden input-handling rules from visual design alone.
6. **If the prompt or validated reference clearly specifies how entered values are treated**: Preserve that behavior in acceptance criteria or business rules when it affects validation, matching, ordering, eligibility, or displayed output. Express it as observable or decision-relevant behavior, not as an implementation mechanism.
7. **If the source clearly specifies exact user-facing copy**: Preserve that copy exactly in acceptance criteria, business rules, and scope boundaries unless the user explicitly asks to rewrite it.
8. **If the prompt is short or underspecified**: Either keep explicit `[NEEDS CLARIFICATION]` markers or add narrow scope boundaries. Do not silently broaden the feature.
9. **If the source defines separate success, invalid, empty, error, or terminal flows**: Represent each required observable flow as its own acceptance criterion instead of hiding it only in Edge Cases.
10. **Do not infer unrequested behavior**: Leave out source-unsupported input-handling rules, persistence, retries, background side effects, and extra navigation unless they are explicitly required or clearly validated by reference material.

---

## User Scenarios & Testing _(mandatory)_

### Primary User Story

[Describe the main user journey in plain language]

### Acceptance Criteria

- **AC-001**: **Given** [initial state], **When** [action], **Then** [expected outcome]
- **AC-002**: **Given** [initial state], **When** [action], **Then** [expected outcome]

### User-Visible Outcomes

- [Outcome the user can directly see, hear, or otherwise observe]
- [Validation, confirmation, or terminal response the user should experience]

### Edge Cases

- **EC-001**:
  - What happens when [boundary condition]?
  - How does system handle [error scenario]?
- **EC-002**:
  - What happens when [boundary condition]?
  - How does system handle [error scenario]?

## Requirements _(mandatory)_

### Functional Requirements

- **FR-001**: System MUST [specific capability, e.g., "allow users to create accounts"]
- **FR-002**: System MUST [specific capability, e.g., "validate email addresses"]
- **FR-003**: Users MUST be able to [key interaction, e.g., "reset their password"]
- **FR-004**: System MUST [data requirement, e.g., "persist user preferences"]
- **FR-005**: System MUST [behavior, e.g., "log all security events"]

_Example of marking unclear requirements:_

- **FR-006**: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]
- **FR-007**: System MUST retain user data for [NEEDS CLARIFICATION: retention period not specified]

### Business Rules

- **BR-001**: [Constraint, validation rule, or business policy stated in business language]
- **BR-002**: [Rule that limits how the feature behaves or when it may proceed]

### Assumptions & Scope Boundaries

#### Assumptions

- [Assumption that keeps the feature narrowly defined and reviewable]

#### Explicit Non-Goals

- [Behavior, adjacent workflow, or capability that is intentionally out of scope]

#### Prohibited Behaviors

- [What the feature must NOT do, especially for prototype-only or limited-scope flows]

### Key Entities _(include if feature involves data)_

- **[Entity 1]**: [What it represents, key attributes without implementation]
- **[Entity 2]**: [What it represents, relationships to other entities]

---

## Review & Acceptance Checklist

_GATE: Automated checks run during main() execution_

### Content Quality

- [ ] No implementation details (languages, frameworks, APIs, implementation identifiers, or file paths)
- [ ] No tech-stack, CSS implementation detail, or code-structure detail leaked from reference artifacts
- [ ] No `Reference Context` analysis section embedded in `spec.md` (reference analysis belongs in `reference-context.md`)
- [ ] Focused on user value and business needs
- [ ] Written for non-technical stakeholders
- [ ] Reference material translated into business language only
- [ ] Exact user-facing copy preserved when a validated source clearly specifies it
- [ ] All mandatory sections completed

### Requirement Completeness

- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Requirements are testable and unambiguous
- [ ] Success criteria are measurable
- [ ] Scope is clearly bounded
- [ ] Prototype-only or limited-scope flows explicitly state what must NOT happen
- [ ] Short prompts did not silently broaden the feature beyond the given input or validated reference material
- [ ] Acceptance criteria cover all distinct observable scenarios supported by the prompt or validated reference material
- [ ] No inferred behavior was added beyond the prompt, validated reference material, or explicit business rules
- [ ] Dependencies and assumptions identified

---

## Execution Status

_Updated by main() during processing_

- [ ] User description parsed
- [ ] Key concepts extracted
- [ ] Ambiguities marked
- [ ] User scenarios defined
- [ ] Requirements generated
- [ ] Entities identified
- [ ] Review checklist passed

---
