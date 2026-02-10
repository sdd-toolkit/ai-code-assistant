# Load Constitution Sections
# Automatically loads all constitution files from .specify/memory/constitution/ or .specify/templates/constitution/
# Cross-platform compatible PowerShell script
#Requires -Version 5.1

$ErrorActionPreference = "Stop"

# Set consistent encoding for cross-platform compatibility
# PowerShell 5.1 compatible encoding setup with error handling
try {
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        # PowerShell Core (6+) handles this automatically
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
        $OutputEncoding = [Console]::OutputEncoding
    } else {
        # PowerShell 5.1 on Windows
        if ($PSVersionTable.Platform -eq $null -or $PSVersionTable.Platform -eq 'Win32NT') {
            [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
            $OutputEncoding = [Console]::OutputEncoding
        } else {
            # Fallback for older versions or non-Windows
            $OutputEncoding = [System.Text.Encoding]::UTF8
        }
    }
} catch {
    # Fallback if console encoding fails
    $OutputEncoding = [System.Text.Encoding]::UTF8
}

# Cross-platform path helper function
function Join-CrossPlatformPath {
    param([string[]]$PathParts)
    
    if ($PathParts.Count -eq 0) {
        return ""
    }
    
    $result = $PathParts[0]
    for ($i = 1; $i -lt $PathParts.Count; $i++) {
        $result = Join-Path $result $PathParts[$i]
    }
    
    return $result
}

$templateDir = (Join-CrossPlatformPath @(".specify", "templates", "constitution"))
$memoryDir = (Join-CrossPlatformPath @(".specify", "memory"))
$memoryConstitutionDir = (Join-CrossPlatformPath @($memoryDir, "constitution"))

# Determine which constitution directory to use (memory first, then templates)
$constitutionDir = ""
$location = ""

if ((Test-Path $memoryConstitutionDir) -and ((Get-ChildItem -Path $memoryConstitutionDir -File -ErrorAction SilentlyContinue).Count -gt 0)) {
    $constitutionDir = $memoryConstitutionDir
    $location = "memory (project-specific)"
} else {
    $constitutionDir = $templateDir
    $location = "templates (default)"
}

# Function to load a constitution section (supports any file type)
function Load-Section {
    param(
        [string]$Section,
        [string]$FileName
    )
    
    if (Test-Path $FileName) {
        $ext = [System.IO.Path]::GetExtension($FileName).TrimStart('.')
        Write-Output ""
        Write-Output "<!-- Constitution Section: $Section -->"
        Write-Output ""
        switch ($ext) {
            'md' {
                Get-Content $FileName -Encoding UTF8 | Write-Output
            }
            { $_ -in 'yaml', 'yml' } {
                Write-Output '```yaml'
                Get-Content $FileName -Encoding UTF8 | Write-Output
                Write-Output '```'
            }
            'json' {
                Write-Output '```json'
                Get-Content $FileName -Encoding UTF8 | Write-Output
                Write-Output '```'
            }
            default {
                Write-Output '```'
                Get-Content $FileName -Encoding UTF8 | Write-Output
                Write-Output '```'
            }
        }
        Write-Output ""
        Write-Output "---"
        Write-Output ""
    } else {
        Write-Warning "Warning: Missing section '$Section' (expected at $FileName)"
    }
}

# Discover all constitution files
$sections = @()
$filenames = @()
if (Test-Path $constitutionDir) {
    $files = Get-ChildItem -Path $constitutionDir -File | Sort-Object Name
    foreach ($file in $files) {
        # Derive section name: strip extension, then strip -template suffix
        $section = $file.BaseName
        $section = $section -replace '-template$', ''
        $sections += $section
        $filenames += $file.FullName
    }
}

# Print header
Write-Output "# Constitutional Standards"
Write-Output ""
Write-Output "**Loading Mode**: Auto-discovery"
Write-Output "**Location**: $location"
Write-Output "**Sections Found**: $($sections.Count)"
Write-Output ""
Write-Output "---"
Write-Output ""

# Load each discovered section
for ($i = 0; $i -lt $sections.Count; $i++) {
    Load-Section -Section $sections[$i] -FileName $filenames[$i]
}

# Always load branching from git-workflow.yaml with YAML code fencing
$gitWorkflowFile = (Join-CrossPlatformPath @($memoryDir, "git-workflow.yaml"))
if (Test-Path $gitWorkflowFile) {
    Write-Output ""
    Write-Output "<!-- Constitution Section: branching -->"
    Write-Output ""
    Write-Output '```yaml'
    Get-Content $gitWorkflowFile -Encoding UTF8 | Write-Output
    Write-Output '```'
    Write-Output ""
    Write-Output "---"
    Write-Output ""
} else {
    Write-Warning "Warning: Missing git-workflow.yaml (expected at $gitWorkflowFile)"
}

# Print footer with metadata
Write-Output ""
Write-Output "<!-- End of Constitution Loading -->"
Write-Output "<!-- Loaded $($sections.Count) constitution sections + branching (git-workflow.yaml) -->"
