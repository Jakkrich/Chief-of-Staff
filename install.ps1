# Copy the Chief of Staff skill into the personal skills dir for this harness.
param(
  [ValidateSet('auto', 'cursor', 'claude', 'agents')]
  [string]$Harness = 'auto'
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Src = Join-Path $Root 'skills\chief-of-staff'

switch ($Harness) {
  'cursor' { $Dest = Join-Path $HOME '.cursor\skills\chief-of-staff' }
  'claude' { $Dest = Join-Path $HOME '.claude\skills\chief-of-staff' }
  'agents' { $Dest = Join-Path $HOME '.agents\skills\chief-of-staff' }
  default {
    if (Test-Path (Join-Path $HOME '.cursor')) { $Dest = Join-Path $HOME '.cursor\skills\chief-of-staff' }
    elseif (Test-Path (Join-Path $HOME '.claude')) { $Dest = Join-Path $HOME '.claude\skills\chief-of-staff' }
    else { $Dest = Join-Path $HOME '.agents\skills\chief-of-staff' }
  }
}

New-Item -ItemType Directory -Force -Path (Split-Path $Dest) | Out-Null
if (Test-Path $Dest) { Remove-Item -Recurse -Force $Dest }
Copy-Item -Recurse $Src $Dest
Write-Host "installed $Dest"
Write-Host 'enable in a repo by copying templates/cursor-rule.mdc, templates/CLAUDE.md, or templates/AGENTS.md'
