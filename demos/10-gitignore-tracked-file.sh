#!/usr/bin/env bash
# .gitignore only affects untracked files. A file that is already committed stays tracked -
# the rule is there and does nothing. Fix: `git rm --cached <file>`.
. "$(dirname "$0")/lib.sh"
command -v git >/dev/null || skip "git not available"
repo=$(mktemp -d); trap 'rm -r "${repo:?}"' EXIT
cd "$repo" && git init -q && git config user.email demo@example.invalid && git config user.name demo
echo secret > customers.csv && git add customers.csv && git commit -qm add
echo customers.csv > .gitignore
echo changed > customers.csv
status=$(git status --porcelain customers.csv)
[ "$status" = " M customers.csv" ] && pass "file is in .gitignore and still tracked: '$status'" || fail "status: '$status'"
