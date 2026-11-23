# Installer Smoke and Isolation

## Sub-features

- Auto-detection and explicit harness selection (`cursor`, `claude`, `antigravity`, `agents`, `all`)
- Dry-run (`-WhatIf` / `--dry-run`) writes zero files
- Copy mode and link mode (`-Link` / `--link`) deploy `SKILL.md` and `harness.md` cleanly

## How to get to it (user POV)

Run the installer with `HOME` and `USERPROFILE` pointed to a temporary directory so personal user skills are untouched during testing.

## Driving it with PowerShell or Bash

```powershell
$tmp = Join-Path $env:TEMP ("cos-test-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
try {
  .\install.ps1 -Harness all -HomeDir $tmp -WhatIf
  .\install.ps1 -Harness all -HomeDir $tmp
  Get-ChildItem -Recurse $tmp
} finally {
  Remove-Item -Recurse -Force $tmp
}
```

## Gotchas

- Never test installers against the real `$HOME` when verifying unreviewed changes; always isolate `$HOME` and `$USERPROFILE`.
- In Windows PowerShell 5.1, `~` resolves via `$env:USERPROFILE` / `[Environment]::GetFolderPath('UserProfile')` unless `$HOME` is explicitly used by the script. Use `$env:USERPROFILE` or overridden target root cleanly.
