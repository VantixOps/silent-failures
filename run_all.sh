#!/usr/bin/env bash
# Runs every demo. Exit 1 if any demo FAILs (a lesson no longer holds) or if too few demos
# actually ran - a run where everything was skipped proves nothing.
set -u
cd "$(dirname "$0")" || exit 1
passed=0 failed=0 skipped=0
for demo in demos/[0-9]*.sh; do
  bash "$demo"
  case $? in
    0) passed=$((passed + 1)) ;;
    77) skipped=$((skipped + 1)) ;;
    *) failed=$((failed + 1)) ;;
  esac
done
total=$((passed + failed + skipped))
echo "---"
echo "$passed passed, $failed failed, $skipped skipped of $total demos"
[ "$total" -gt 0 ] || { echo "no demos found"; exit 1; }
[ "$failed" -eq 0 ] || exit 1
[ "$passed" -ge 7 ] || { echo "too few demos ran to mean anything (minimum 7)"; exit 1; }
