param(
  [string[]]$TargetDirs = @(
    "$env:USERPROFILE\.github\agents",
    "$env:USERPROFILE\.copilot\agents"
  )
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$MapPath = Join-Path $ScriptDir "agent-names-ja.json"

if (!(Test-Path $MapPath)) {
  Write-Error "Mapping file not found: $MapPath"
  exit 1
}

$Map = Get-Content $MapPath -Raw -Encoding UTF8 | ConvertFrom-Json

foreach ($Dir in $TargetDirs) {
  if (!(Test-Path $Dir)) {
    Write-Host "Skip missing directory: $Dir"
    continue
  }

  Get-ChildItem -Path $Dir -Filter "*.md" -File | ForEach-Object {
    $Path = $_.FullName
    $Text = Get-Content $Path -Raw -Encoding UTF8
    $NameMatch = [regex]::Match($Text, "(?m)^name:\s*(.+)$")

    if (!$NameMatch.Success) {
      return
    }

    $CurrentName = $NameMatch.Groups[1].Value.Trim().Trim('"').Trim("'")
    $Entry = $Map.PSObject.Properties[$CurrentName]

    if ($null -eq $Entry) {
      return
    }

    $LocalizedName = $Entry.Value.name
    $LocalizedDescription = $Entry.Value.description

    $Text = [regex]::Replace($Text, "(?m)^name:\s*.+$", "name: $LocalizedName", 1)
    $Text = [regex]::Replace($Text, "(?m)^description:\s*.+$", "description: $LocalizedDescription", 1)

    Set-Content -Path $Path -Value $Text -Encoding UTF8
    Write-Host "Localized: $Path"
  }
}
