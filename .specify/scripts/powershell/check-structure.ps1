#Requires -Version 5.1

$ErrorActionPreference = "Stop"

try {
    $rootDir = git rev-parse --show-toplevel 2>$null
} catch {
    $rootDir = "."
}

$pass = $true

$requiredPaths = @(
    ".specify/templates/constitution",
    ".specify/templates/spec-template.md",
    ".specify/templates/plan-template.md",
    ".specify/templates/tasks-template.md",
    ".specify/templates/commands/sdd-specify.md",
    ".specify/templates/commands/sdd-plan.md",
    ".specify/templates/commands/sdd-tasks.md",
    "prompts/sdd-specify.md",
    "prompts/sdd-plan.md",
    "prompts/sdd-tasks.md"
)

Write-Output "[spec:check] Validating required structure..."

foreach ($p in $requiredPaths) {
    $fullPath = Join-Path $rootDir $p
    if (-not (Test-Path $fullPath)) {
        Write-Error "[MISSING] $p"
        $pass = $false
    } else {
        Write-Output "[OK] $p"
    }
}

if ($pass) {
    Write-Output "[spec:check] SUCCESS"
    exit 0
} else {
    Write-Error "[spec:check] FAIL"
    exit 1
}
