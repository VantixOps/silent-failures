#!/usr/bin/env bash
# `exit` inside a function called via $(...) only ends the subshell. The script keeps running.
. "$(dirname "$0")/lib.sh"
out=$(bash -c 'check() { echo "problem found"; exit 3; }; msg=$(check); echo "still running"')
[ "$out" = "still running" ] && pass "exit 3 in \$(...) did not stop the caller" || fail "output: $out"
