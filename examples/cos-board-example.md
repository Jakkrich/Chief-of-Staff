---
date: 2026-11-23
project: example-app
tags:
 - example-app
 - chief-of-staff
---

# Chief of Staff board

## Latest summary

Nothing blocks you right now. Export row fix landed on `fix/csv-last-row` with verified counts. Two queue items are running in isolated worktrees, and the billing refactor PR is ready for your morning merge decision (`Autopilot-stack`, PR #42, low risk).

## Active

| ID | Goal | Done-check | Playbook | Owner | Status | Next | Evidence |
|---|---|---|---|---|---|---|---|
| COS-12 | Fix missing last row in 60k CSV export | `verify-app` exports 60000 rows matching fixture | Bug fix | worker-csv (`worktree: ../wt-csv`) | review | Coordinator audits diff and `verify-app` log | branch `fix/csv-last-row`, `.context/evidence/csv-60k.txt` |
| COS-13 | Add `--json` flag to CLI export | Text output byte-identical, JSON parses cleanly | Feature | worker-cli (`worktree: ../wt-cli`) | running | Await worker report and `/interrogate` | `.audit/cli-json.tsv` |
| COS-14 | Migrate billing webhooks to queue | Verified green PR stacked for operator review | Autopilot-stack | worker-billing (`cloud`) | waiting-on-you | Operator merges PR #42 | PR #42, `PASS` verdict, `.audit/billing-queue.tsv` |

## Archive

| ID | Goal | Outcome | Evidence |
|---|---|---|---|
| COS-11 | Profile startup latency and remove duplicate DB init | Merged; median startup reduced from 1.82s to 0.41s | PR #39, `/benchmark-checklist` pass |
