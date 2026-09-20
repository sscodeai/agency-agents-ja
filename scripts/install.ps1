# install.ps1 - PowerShell entrypoint for installing agency-agents-ja agents.
#
# This wrapper delegates to scripts/install.sh so PowerShell users get the same
# tool contract and safety checks as the bash installer.
#
# Usage:
#   pwsh scripts/install.ps1 [-Tool all] [-Division marketing] [-Agent slug] [-Path dir] [-Parallel] [-NoInteractive]

param(
    [string]$Tool = "all",
    [string]$Division = "",
    [string]$Agent = "",
    [string]$Path = "",
    [switch]$Parallel,
    [int]$Jobs = 4,
    [switch]$NoInteractive,
    [switch]$NoConvert,
    [switch]$ListTools,
    [switch]$ListDivisions,
    [switch]$ListAgents,
    [switch]$DryRun,
    [switch]$Help
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$InstallSh = Join-Path $ScriptDir "install.sh"

if ($Help) {
    Get-Content $MyInvocation.MyCommand.Path | Select-Object -First 12 |
        ForEach-Object { $_ -replace '^# ?','' }
    exit 0
}

$bash = Get-Command bash -ErrorAction SilentlyContinue
if (-not $bash) {
    throw "bash is required. Install Git for Windows, use WSL, or run scripts/install.sh directly in a POSIX shell."
}

$argsList = @($InstallSh)
if ($Tool) { $argsList += @("--tool", $Tool) }
if ($Division) { $argsList += @("--division", $Division) }
if ($Agent) { $argsList += @("--agent", $Agent) }
if ($Path) { $argsList += @("--path", $Path) }
if ($Parallel) { $argsList += @("--parallel", "--jobs", "$Jobs") }
if ($NoInteractive) { $argsList += "--no-interactive" }
if ($NoConvert) { $argsList += "--no-convert" }
if ($DryRun) { $argsList += "--dry-run" }
if ($ListTools) { $argsList += @("--list", "tools") }
if ($ListDivisions) { $argsList += @("--list", "divisions") }
if ($ListAgents) { $argsList += @("--list", "agents") }

Push-Location $RepoRoot
try {
    & $bash.Source @argsList
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
} finally {
    Pop-Location
}
