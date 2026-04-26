# Reference Folder Example

This example shows how a mixed reference folder should be authored and how its contents flow through the toolkit.

## Example Folder

```text
.specify/reference/contact-form/
├── README.md
├── stories.md
└── formCSS.md
```

## Artifact Roles

- `README.md`: Optional organizer that explains how the artifacts relate. It does not outrank sibling files.
- `stories.md`: Authoritative source for user-visible behavior, validation scenarios, terminal flows, and prohibited behavior.
- `formCSS.md`: Authoritative source for preserved visual-system and style-token detail such as spacing, typography, sizing, density, borders, colors, and layout proportions.

## Output Mapping

### Into `spec.md`

Only business-facing outcomes should be carried forward:

- user-visible fields and actions
- validation expectations visible to the user
- accessibility outcomes described in business language
- responsive expectations described in business language
- scope boundaries, non-goals, and prohibited behaviors

`spec.md` must not include tech stack, framework names, APIs, file paths, CSS declarations, class names, or code structure.

### Into `reference-context.md`

Supplementary implementation-facing context should be preserved here:

- Design & Interaction Signals
- Visual System / Style Tokens
- Technical Observations
- Validation & Testing Signals
- Implementation-Sensitive Assumptions

For a contact-form style reference, `reference-context.md` should preserve token-level signals from `formCSS.md` instead of reducing them to vague phrases like "compact card".

### Into `plan.md`

`@sdd-plan` should treat preserved visual-system and style-token signals as explicit design obligations and manual visual-verification cues.

### Into `tasks.md`

`@sdd-tasks` should convert preserved visual-system and style-token signals into:

- explicit styling tasks
- manual visual-verification tasks
- any accessibility or responsive tasks implied by the validated reference artifacts

## Precedence Rule

- All validated files in the reference folder are authoritative when the folder is used.
- `README.md`, if present, is an organizing aid only.
- If a validated reference artifact conflicts with a generic prompt default, the validated reference artifact wins.
- If validated reference artifacts conflict with each other, preserve that conflict as an open question instead of silently choosing one.
