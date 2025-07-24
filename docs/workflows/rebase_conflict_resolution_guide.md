# Git Rebase Conflict-Resolution – Cursor Workflow (2025)

This markdown explains the proven step-by-step routine we follow inside Cursor when an **interactive rebase** stops due to merge conflicts or a lingering swap-file.

## 1  Always start in the appdir
```bash
cd ~/VOABTEAMAPP2/jo17_tactical_manager   # 🔑 repository root (appdir rule)
```

## 2  Typical blockers & quick fixes
| Symptom | Cause | Fix |
|---------|-------|-----|
| `.COMMIT_EDITMSG.swp` prompt in Vim | Previous commit message left a swap-file | `rm .git/.COMMIT_EDITMSG.swp` |
| Conflict markers (`<<<<<<<`) in files | Merge conflict during rebase | Open file → keep *ours* or *theirs* → remove markers → `git add <file>` |
| Analyzer errors after conflict fix | Missing imports / duplicate code | `dart format .` → `flutter analyze --fatal-infos` |

## 3  Canonical command sequence
```bash
# 1. Remove swapfile if present
rm -f .git/.COMMIT_EDITMSG.swp

# 2. Save (no-edit) commit message & continue rebase
git commit --no-edit
git rebase --continue

# 3. Auto-format & static analysis
dart format -o write .
flutter analyze --fatal-infos

# 4. Run full test-suite (with coverage)
flutter test --coverage

# 5. Push the rebased branch
BR=flavour-slice-ui-refine   # example
git push --force-with-lease origin $BR
```

## 4  After push – CI & merge
1. `gh pr checks $BR --watch` – wait until critical jobs are ✅.
2. Merge (normal or admin):
   ```bash
   echo "y" | gh pr merge $BR --merge --delete-branch
   ```

This routine keeps the branch history linear, passes Lefthook gates, and avoids editor lockups. Keep it handy for every slice during the Flavour-merge plan.
