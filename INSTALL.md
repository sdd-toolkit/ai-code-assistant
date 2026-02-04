# Cross-platform temp directory
$tempPath = if ($IsWindows -or $env:OS -eq "Windows_NT") { 
    $env:TEMP 
} else { 
    if ($env:TMPDIR) { $env:TMPDIR } else { "/tmp" } 
}
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
    $excludeFile = Join-Path $destMemoryDir "git-workflow.yaml"
    if (Test-Path $excludeFile) {
        Remove-Item -Force $excludeFile
    }
} else {
    Get-ChildItem $sourceSpecifyDir | Where-Object { $_.Name -ne "memory" } | Copy-Item -Destination ".specify" -Recurse -Force
}

# Ensure required directories exist
New-Item -ItemType Directory -Force -Path (Join-Path ".specify" "memory") | Out-Null
New-Item -ItemType Directory -Force -Path "specs" | Out-Null

# Cleanup
Remove-Item -Recurse -Force $tempDir

Write-Host "✅ SDD Toolkit installation complete!" -ForegroundColor Green