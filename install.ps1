# Copy or link the Chief of Staff skill into personal skills dirs for supported harnesses.
[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [ValidateSet('auto', 'cursor', 'claude', 'antigravity', 'agents', 'all')]
  [string]$Harness = 'auto',
  [switch]$Link,
  [string]$HomeDir
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Src = Join-Path $Root 'skills\chief-of-staff'
$BaseHome = if ($HomeDir) { $HomeDir } elseif ($env:CHIEF_OF_STAFF_HOME) { $env:CHIEF_OF_STAFF_HOME } else { $HOME }

function Get-TargetDest([string]$Name) {
  switch ($Name) {
    'cursor' { return Join-Path $BaseHome '.cursor\skills\chief-of-staff' }
    'claude' { return Join-Path $BaseHome '.claude\skills\chief-of-staff' }
    'antigravity' { return Join-Path $BaseHome '.gemini\config\skills\chief-of-staff' }
    'agents' { return Join-Path $BaseHome '.agents\skills\chief-of-staff' }
  }
}

$Targets = @()
if ($Harness -eq 'all') {
  $Targets = @('cursor', 'claude', 'antigravity', 'agents')
} elseif ($Harness -eq 'auto') {
  if (Test-Path (Join-Path $BaseHome '.cursor')) { $Targets = @('cursor') }
  elseif (Test-Path (Join-Path $BaseHome '.claude')) { $Targets = @('claude') }
  elseif ((Test-Path (Join-Path $BaseHome '.gemini\antigravity')) -or (Test-Path (Join-Path $BaseHome '.gemini\config'))) { $Targets = @('antigravity') }
  else { $Targets = @('agents') }
} else {
  $Targets = @($Harness)
}

foreach ($t in $Targets) {
  $Dest = Get-TargetDest $t
  $Action = if ($Link) { "Link junction -> $Src" } else { "Copy from $Src" }
  if ($PSCmdlet.ShouldProcess($Dest, $Action)) {
    New-Item -ItemType Directory -Force -Path (Split-Path $Dest) | Out-Null
    if (Test-Path $Dest) {
      $existing = Get-Item $Dest -Force
      if ($existing.LinkType) {
        $existing.Delete()
      } else {
        Remove-Item -Recurse -Force $Dest
      }
    }
    if ($Link) {
      New-Item -ItemType Junction -Path $Dest -Target $Src | Out-Null
      Write-Host "linked $Dest -> $Src"
    } else {
      Copy-Item -Recurse $Src $Dest
      Write-Host "installed $Dest"
    }
  }
}

Write-Host 'enable in a repo by copying templates/cursor-rule.mdc, templates/CLAUDE.md, or templates/AGENTS.md'
