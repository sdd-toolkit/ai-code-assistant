# LLM Specification Driven Development Toolkit - Installation Guide

A vendor-neutral installation guide for setting up SDD prompts with GitHub Copilot (primary) and Amazon Q Developer (alternative).

## Quick Install

### GitHub Copilot (Project-Local) — Recommended

**Bash:**

```bash
TEMP_DIR="/tmp/sdd-toolkit-install-$$" && \
git clone --depth 1 https://github.com/sdd-toolkit/ai-code-assistant.git "$TEMP_DIR" && \
mkdir -p .github/prompts && \
for file in "$TEMP_DIR"/prompts/*.md; do \
  sed -e 's/{{SCRIPT_EXT}}/.sh/g' -e 's/{{SCRIPT_LANG}}/bash/g' "$file" > .github/prompts/"$(basename "$file" .md).prompt.md"; \
done && \
if [ ! -d .specify ]; then \
  rsync -av --exclude='memory/git-workflow.yaml' "$TEMP_DIR"/.specify/ .specify/; \
else \
  rsync -av --exclude='memory/' "$TEMP_DIR"/.specify/ .specify/; \
fi && \
mkdir -p .specify/memory specs && \
rm -rf "$TEMP_DIR"
```

**PowerShell:**

```powershell
# Cross-platform temp directory
$tempPath = if ($IsWindows -or $env:OS -eq "Windows_NT") { $env:TEMP } else { if ($env:TMPDIR) { $env:TMPDIR } else { "/tmp" } }
$tempDir = Join-Path $tempPath "sdd-toolkit-install-$(Get-Random)"

# Clone repository
git clone --depth 1 https://github.com/sdd-toolkit/ai-code-assistant.git $tempDir

# Create .github/prompts directory
$githubPromptsDir = Join-Path ".github" "prompts"
New-Item -ItemType Directory -Force -Path $githubPromptsDir | Out-Null

# Process prompts
$promptsDir = Join-Path $tempDir "prompts"
Get-ChildItem (Join-Path $promptsDir "*.md") | ForEach-Object {
  $baseName = $_.BaseName
  $outputPath = Join-Path $githubPromptsDir "$baseName.prompt.md"
  (Get-Content $_.FullName -Raw -Encoding UTF8) `
    -replace '{{SCRIPT_EXT}}','.ps1' `
    -replace '{{SCRIPT_LANG}}','powershell' | `
    Set-Content $outputPath -Encoding UTF8
}

# Handle .specify directory
$sourceSpecifyDir = Join-Path $tempDir ".specify"
if (-not (Test-Path ".specify")) {
  Copy-Item $sourceSpecifyDir ".specify" -Recurse -Force
  $memorySourceDir = Join-Path $sourceSpecifyDir "memory"
  if (Test-Path $memorySourceDir) {
    $memoryDestDir = Join-Path ".specify" "memory"
    New-Item -ItemType Directory -Force -Path $memoryDestDir | Out-Null
    Get-ChildItem $memorySourceDir | Where-Object { $_.Name -ne "git-workflow.yaml" } | Copy-Item -Destination $memoryDestDir -Recurse -Force
  }
  # Remove excluded files from copied directory
  $destMemoryDir = Join-Path ".specify" "memory"
  }

  $excludeFile = Join-Path $destMemoryDir "git-workflow.yaml"
  if (Test-Path $excludeFile) {
} else {
  Get-ChildItem $sourceSpecifyDir | Where-Object { $_.Name -ne "memory" } | Copy-Item -Destination ".specify" -Recurse -Force
}

# Ensure required directories exist
New-Item -ItemType Directory -Force -Path (Join-Path ".specify" "memory") | Out-Null
New-Item -ItemType Directory -Force -Path "specs" | Out-Null

# Cleanup
Remove-Item -Recurse -Force $tempDir
```

**What this does:**

- Clones the latest toolkit from GitHub
- Creates `.github/prompts/` directory in your project
- Replaces placeholders (`{{SCRIPT_EXT}}` and `{{SCRIPT_LANG}}`) with appropriate values for your shell
- Copies all prompt files with `.prompt.md` extension (Copilot requirement)
- `.specify/` folder downloaded and extracted to temporary location
- Copies the complete `.specify/` directory structure to your project (excludes `git-workflow.yaml` on first install, preserves existing `memory/` folder on updates)
- All subsequent prompt invocations will use the local `.specify/` configuration
- Cleans up temporary files

Next: Continue with the Quick Start in the README to generate your first spec: see [README.md#quick-start](./README.md#quick-start).

### Alternative: Amazon Q Developer (Global)

**Bash:**

```bash
mkdir -p ~/.aws/amazonq/prompts && \
cd /tmp && \
git clone --depth 1 https://github.com/sdd-toolkit/ai-code-assistant.git && \
for file in ai-code-assistant/prompts/*.md; do \
  sed -e 's/{{SCRIPT_EXT}}/.sh/g' -e 's/{{SCRIPT_LANG}}/bash/g' "$file" > ~/.aws/amazonq/prompts/"$(basename "$file")"; \
done && \
cd - && \
if [ ! -d .specify ]; then \
  rsync -av --exclude='memory/git-workflow.yaml' /tmp/ai-code-assistant/.specify/ .specify/; \
else \
  rsync -av --exclude='memory/' /tmp/ai-code-assistant/.specify/ .specify/; \
fi && \
rm -rf /tmp/ai-code-assistant && \
echo "✅ Amazon Q prompts and .specify directory installed successfully!"
```

**PowerShell:**

```powershell
$amazonQPath = "$env:USERPROFILE\.aws\amazonq"
New-Item -ItemType Directory -Force -Path "$amazonQPath\prompts" | Out-Null
Set-Location $env:TEMP
git clone --depth 1 https://github.com/sdd-toolkit/ai-code-assistant.git
Get-ChildItem "ai-code-assistant\prompts\*.md" | ForEach-Object {
  (Get-Content $_.FullName -Raw) `
    -replace '{{SCRIPT_EXT}}','.ps1' `
    -replace '{{SCRIPT_LANG}}','powershell' | `
    Set-Content "$amazonQPath\prompts\$($_.Name)"
}
Set-Location -
if (-not (Test-Path ".specify")) {
  robocopy "$env:TEMP\ai-code-assistant\.specify" ".specify" /E /XF git-workflow.yaml /XD memory
} else {
  robocopy "$env:TEMP\ai-code-assistant\.specify" ".specify" /E /XD memory
}
Remove-Item -Recurse -Force "$env:TEMP\ai-code-assistant"
Write-Host "✅ Amazon Q prompts and .specify directory installed successfully!"
```

**What this does:**

- Creates `~/.aws/amazonq/prompts/` directory
- Clones the latest toolkit from GitHub
- Replaces placeholders (`{{SCRIPT_EXT}}` and `{{SCRIPT_LANG}}`) with appropriate values for your shell
- Copies all prompt files (`.md`)
  **What this does:**

- Copies the complete `.specify/` directory structure (excludes `git-workflow.yaml` on first install, preserves existing `memory/` folder on updates)
- Handles both fresh installations and updates gracefully
- Cleans up temporary files

<!-- intentionally blank: Amazon Q is documented above as an alternative in Quick Install -->

## Local Install (From Cloned Repository)

If you've already cloned this repository locally, run these commands from the toolkit repository directory:

### Amazon Q Developer

**Bash:**

```bash
mkdir -p ~/.aws/amazonq/prompts && \
for file in prompts/*.md; do \
  sed -e 's/{{SCRIPT_EXT}}/.sh/g' -e 's/{{SCRIPT_LANG}}/bash/g' "$file" > ~/.aws/amazonq/prompts/"$(basename "$file")"; \
done && \
if [ ! -d ~/.aws/amazonq/.specify ]; then \
  rsync -av --exclude='memory/git-workflow.yaml' .specify/ ~/.aws/amazonq/.specify/; \
else \
  rsync -av --exclude='memory/' .specify/ ~/.aws/amazonq/.specify/; \
fi && \
echo "✅ Amazon Q prompts and .specify directory installed successfully!"
```

**PowerShell:**

```powershell
$amazonQPath = "$env:USERPROFILE\.aws\amazonq"
New-Item -ItemType Directory -Force -Path "$amazonQPath\prompts" | Out-Null
Get-ChildItem "prompts\*.md" | ForEach-Object {
  (Get-Content $_.FullName -Raw) `
    -replace '{{SCRIPT_EXT}}','.ps1' `
    -replace '{{SCRIPT_LANG}}','powershell' | `
    Set-Content "$amazonQPath\prompts\$($_.Name)"
}
if (-not (Test-Path "$amazonQPath\.specify")) {
  robocopy ".specify" "$amazonQPath\.specify" /E /XF git-workflow.yaml /XD memory
} else {
  robocopy ".specify" "$amazonQPath\.specify" /E /XD memory
}
Write-Host "✅ Amazon Q prompts and .specify directory installed successfully!"
```

### GitHub Copilot (Install to Your Project)

Navigate to your target project directory, then run this command (replace `/path/to/sdd-toolkit` with the actual path to this cloned repository):

**Bash:**

```bash
TOOLKIT_PATH="/path/to/sdd-toolkit" && \
mkdir -p .github/prompts && \
for file in "$TOOLKIT_PATH"/prompts/*.md; do \
  sed -e 's/{{SCRIPT_EXT}}/.sh/g' -e 's/{{SCRIPT_LANG}}/bash/g' "$file" > .github/prompts/"$(basename "$file" .md).prompt.md"; \
done && \
if [ ! -d .specify ]; then \
  rsync -av --exclude='memory/git-workflow.yaml' "$TOOLKIT_PATH/.specify/" .specify/; \
else \
  rsync -av --exclude='memory/' "$TOOLKIT_PATH/.specify/" .specify/; \
fi && \
echo "✅ GitHub Copilot prompts and .specify directory installed successfully!"
```

**PowerShell:**

```powershell
$toolkitPath = "C:\path\to\sdd-toolkit"  # Replace with actual path
New-Item -ItemType Directory -Force -Path ".github\prompts" | Out-Null
Get-ChildItem "$toolkitPath\prompts\*.md" | ForEach-Object {
  $baseName = $_.BaseName
  (Get-Content $_.FullName -Raw) `
    -replace '{{SCRIPT_EXT}}','.ps1' `
    -replace '{{SCRIPT_LANG}}','powershell' | `
    Set-Content ".github\prompts\$baseName.prompt.md"
}
if (-not (Test-Path ".specify")) {
  robocopy "$toolkitPath\.specify" ".specify" /E /XF git-workflow.yaml /XD memory
} else {
  robocopy "$toolkitPath\.specify" ".specify" /E /XD memory
}
Write-Host "✅ GitHub Copilot prompts and .specify directory installed successfully!"
```

**Note:**

- Replace `/path/to/sdd-toolkit` (Bash) or `C:\path\to\sdd-toolkit` (PowerShell) with the actual path to the cloned toolkit repository
- This installs prompts to `.github/prompts/` (Copilot requirement) and `.specify/` in your project
- Excludes `git-workflow.yaml` on first install, preserves existing `.specify/memory/` directory on updates
- Updates templates and commands while keeping your project-specific memory files
- Placeholders are replaced with appropriate values for your shell

## Verify Installation

**GitHub Copilot:**

```bash
ls -la .github/prompts/
```

**Amazon Q Developer:**

```bash
ls -la ~/.aws/amazonq/prompts/
```

You should see the following prompts: `sdd-audit.md`, `sdd-init.md`, `sdd-drift.md`, `sdd-implement.md`, `sdd-plan.md`, `sdd-specify.md`, `sdd-tasks.md`

(Note: GitHub Copilot prompts will have `.prompt.md` extension)

## Quick Test

**Get started by running `@sdd-init` in your IDE to set up your project governance:**

Type `@sdd-init` in your IDE to test the installation and create your project constitution.

**What this does:**

- Tests that the prompts are properly installed and accessible
- Creates or updates your project's constitution with best practices
- Guides you through setting up coding standards, architecture principles, and project governance

**Reference the examples:**

- Check the `examples/` folder for sample constitutions (e.g., `examples/constitution-react.md`)
- Use these as templates for different project types and technology stacks
- Customize the generated constitution based on your project's specific needs

**Expected behavior:**

- The prompt loads successfully in your IDE
- You can interact with `@sdd-init` to generate project-specific governance
- On first run, template files are copied from `.specify/templates/constitution/*-template.md` to `.specify/memory/constitution/*.md`
- The modular constitution working files are saved to `.specify/memory/constitution/` (core.md, architecture.md, testing.md, security.md, observability.md, user-interface.md) for future reference and selective loading
- Templates remain pristine in `.specify/templates/constitution/` for future projects

## Available Prompts

- `@sdd-audit` - Generate compliance audit and TODO list
- `@sdd-init` - Update project constitution with versioning
- `@sdd-drift` - Detect specification drift and validate implementation
- `@sdd-specify` - Create feature specifications from descriptions
- `@sdd-plan` - Generate implementation plans and design artifacts
- `@sdd-tasks` - Create dependency-ordered task breakdowns
- `@sdd-implement` - Execute implementation following task plan

## Prerequisites

- GitHub Copilot or Amazon Q Developer extension installed in your IDE
- Project with `.specify/` directory structure
- macOS, Linux, or WSL environment with zsh/bash shell access

## Project Structure

This toolkit requires the following directory structure:

```
.specify/
├── memory/              # Constitution and audit logs
├── reference/           # Domain context files (used via @sdd-specify -ref <folder>)
├── scripts/bash/        # Helper scripts
└── templates/           # Markdown templates for prompts
```

The `.specify/` directory is automatically created when you first use the prompts.

## Next Steps

1. Read [PROMPTS_HOWTO.md](./PROMPTS_HOWTO.md) for detailed usage guide
2. Review [PROMPTS_SUMMARY.md](./PROMPTS_SUMMARY.md) for a quick reference
3. Start with: `@sdd-init` to set up project governance (optional)
4. Then: `@sdd-specify <your feature description>` to begin feature development
5. Follow the workflow: specify → plan → tasks → implement → audit

## Troubleshooting

**Prompts not found in GitHub Copilot:**

- Ensure prompts are in `.github/prompts/` (project-local, not global)
- Verify files have `.prompt.md` extension
- Restart your IDE after installation

**Prompts not found in Amazon Q:**

- Verify `~/.aws/amazonq/prompts/` directory exists
- Check file permissions: `chmod 644 ~/.aws/amazonq/prompts/*.md`
- Restart your IDE after installation

**Script errors:**

- Ensure you're in the project root directory
- Make scripts executable: `chmod +x .specify/scripts/bash/*.sh`
- Verify zsh or bash is available: `echo $SHELL`

**Permission denied:**

- Check directory permissions: `ls -la ~/.aws/amazonq/` or `ls -la .github/`
- Ensure you have write access to the target directories

## Uninstallation

**Remove GitHub Copilot prompts:**

```bash
rm -rf .github/prompts
```

**Remove Amazon Q prompts:**

```bash
rm -rf ~/.aws/amazonq/prompts
```

## Updating to Latest Version

### Using Update Scripts (Recommended)

The easiest way to update is using the automated update scripts. These scripts will be available once PowerShell versions are created.

### Manual Update (From GitHub Repository)

#### GitHub Copilot (Project-Local)

**Bash:**

```bash
cd /tmp && \
git clone --depth 1 https://github.com/sdd-toolkit/ai-code-assistant.git && \
rm -rf ~/.aws/amazonq/prompts/*.md && \
for file in ai-code-assistant/prompts/*.md; do \
  sed -e 's/{{SCRIPT_EXT}}/.sh/g' -e 's/{{SCRIPT_LANG}}/bash/g' "$file" > ~/.aws/amazonq/prompts/"$(basename "$file")"; \
done && \
if [ ! -d ~/.aws/amazonq/.specify ]; then \
  rsync -av --exclude='memory/git-workflow.yaml' ai-code-assistant/.specify/ ~/.aws/amazonq/.specify/; \
else \
  rsync -av --exclude='memory/' ai-code-assistant/.specify/ ~/.aws/amazonq/.specify/; \
fi && \
rm -rf ai-code-assistant && \
cd - && \
echo "✅ Amazon Q prompts and .specify directory updated successfully!"
```

**PowerShell:**

```powershell
$amazonQPath = "$env:USERPROFILE\.aws\amazonq"
Set-Location $env:TEMP
git clone --depth 1 https://github.com/sdd-toolkit/ai-code-assistant.git
Remove-Item "$amazonQPath\prompts\*.md" -Force -ErrorAction SilentlyContinue
Get-ChildItem "ai-code-assistant\prompts\*.md" | ForEach-Object {
  (Get-Content $_.FullName -Raw) `
    -replace '{{SCRIPT_EXT}}','.ps1' `
    -replace '{{SCRIPT_LANG}}','powershell' | `
    Set-Content "$amazonQPath\prompts\$($_.Name)"
}
robocopy "ai-code-assistant\.specify" "$amazonQPath\.specify" /E /XD memory
Set-Location -
Remove-Item -Recurse -Force "$env:TEMP\ai-code-assistant"
Write-Host "✅ Amazon Q prompts and .specify directory updated successfully!"
```

#### Amazon Q Developer (Global)

**Bash:**

```bash
cd /tmp && \
git clone --depth 1 https://github.com/sdd-toolkit/ai-code-assistant.git && \
cd - && \
rm -rf .github/prompts/*.prompt.md && \
mkdir -p .github/prompts && \
for file in /tmp/ai-code-assistant/prompts/*.md; do \
  sed -e 's/{{SCRIPT_EXT}}/.sh/g' -e 's/{{SCRIPT_LANG}}/bash/g' "$file" > .github/prompts/"$(basename "$file" .md).prompt.md"; \
done && \
rm -rf .specify/templates .specify/scripts && \
cp -r /tmp/ai-code-assistant/.specify/templates .specify/ && \
cp -r /tmp/ai-code-assistant/.specify/scripts .specify/ && \
rm -rf /tmp/ai-code-assistant && \
echo "✅ GitHub Copilot prompts and .specify directory updated successfully!"
```

**PowerShell:**

```powershell
Set-Location $env:TEMP
git clone --depth 1 https://github.com/sdd-toolkit/ai-code-assistant.git
Set-Location -
Remove-Item ".github\prompts\*.prompt.md" -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path ".github\prompts" | Out-Null
Get-ChildItem "$env:TEMP\ai-code-assistant\prompts\*.md" | ForEach-Object {
  $baseName = $_.BaseName
  (Get-Content $_.FullName -Raw) `
    -replace '{{SCRIPT_EXT}}','.ps1' `
    -replace '{{SCRIPT_LANG}}','powershell' | `
    Set-Content ".github\prompts\$baseName.prompt.md"
}
Remove-Item -Recurse -Force ".specify\templates",".specify\scripts" -ErrorAction SilentlyContinue
Copy-Item -Recurse -Force "$env:TEMP\ai-code-assistant\.specify\templates" ".specify\"
Copy-Item -Recurse -Force "$env:TEMP\ai-code-assistant\.specify\scripts" ".specify\"
Remove-Item -Recurse -Force "$env:TEMP\ai-code-assistant"
Write-Host "✅ GitHub Copilot prompts and .specify directory updated successfully!"
```

**Note:** The update commands will:

- Remove existing prompt files to avoid conflicts
- Pull the latest version from the repository
- Replace placeholders with appropriate values for your shell
- **Preserve** your `.specify/memory/` directory (constitution and audits)
- Update `.specify/templates/` and `.specify/scripts/` to the latest versions

**⚠️ Warning:** If you've customized any templates in `.specify/templates/`, back them up before updating, as they will be overwritten.

## Source Files

Prompt files are located at: `prompts/*.md`

All prompts are vendor-neutral markdown files that work with multiple AI assistants.

## Attribution

This toolkit is inspired by and derived from [github/spec-kit](https://github.com/github/spec-kit), adapted for multi-vendor support and portability.
