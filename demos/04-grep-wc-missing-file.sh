#!/usr/bin/env bash
# `grep pattern file | wc -l` prints 0 with exit status 0 whether the file exists without matches
# OR does not exist at all. "0 findings" and "not measured" are indistinguishable.
. "$(dirname "$0")/lib.sh"
dir=$(mktemp -d); trap 'rm -r "${dir:?}"' EXIT
: > "$dir/empty.log"                       # exists, no matches
missing="$dir/does-not-exist.log"          # guaranteed absent: fresh private directory
[ -e "$missing" ] && fail "precondition broken: $missing exists"
count_existing=$(bash -c 'grep ERROR "$1" 2>/dev/null | wc -l' _ "$dir/empty.log"); rc_existing=$?
count_missing=$(bash -c 'grep ERROR "$1" 2>/dev/null | wc -l' _ "$missing"); rc_missing=$?
# Positive control: the same command must see a match when there is one.
echo ERROR > "$dir/hit.log"
count_hit=$(bash -c 'grep ERROR "$1" 2>/dev/null | wc -l' _ "$dir/hit.log")
[ "$count_hit" = 1 ] || fail "positive control broken: expected 1, got $count_hit"
if [ "$count_existing" = 0 ] && [ "$count_missing" = 0 ] && [ "$rc_existing" = 0 ] && [ "$rc_missing" = 0 ]; then
  pass "existing file without matches -> 0 (rc 0), missing file -> 0 (rc 0); a real match -> 1"
fi
fail "existing=$count_existing/rc$rc_existing missing=$count_missing/rc$rc_missing"
