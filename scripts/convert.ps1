# convert.ps1 - PowerShell entrypoint for converting agency-agents-ja integrations.
#
# This wrapper delegates to scripts/convert.sh so Windows users can start from
# PowerShell while keeping one conversion implementation. It works in Git Bash,
# WSL, or any Windows environment where bash is available on PATH.
#
# Usage:
#   pwsh scripts/convert.ps1 [-Tool all] [-Out integrations] [-Parallel] [-Jobs 4]

param(
    [string]$Tool = "all",
    [string]$Out = "",
    [switch]$Parallel,
    [int]$Jobs = 4,
    [switch]$Help
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$ConvertSh = Join-Path $ScriptDir "convert.sh"

if ($Help) {
    Get-Content $MyInvocation.MyCommand.Path | Select-Object -First 12 |
        ForEach-Object { $_ -replace '^# ?','' }
    exit 0
}

$bash = Get-Command bash -ErrorAction SilentlyContinue
if (-not $bash) {
    throw "bash is required. Install Git for Windows, use WSL, or run scripts/convert.sh directly in a POSIX shell."
}

$argsList = @($ConvertSh, "--tool", $Tool)
if ($Out) {
    $argsList += @("--out", $Out)
}
if ($Parallel) {
    $argsList += @("--parallel", "--jobs", "$Jobs")
}

Push-Location $RepoRoot
try {
    & $bash.Source @argsList
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
} finally {
    Pop-Location
}
