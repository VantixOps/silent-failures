#!/usr/bin/env bash
# `set -e` exits on `x=$(failing command)`. A `$?` check in the next line never runs.
. "$(dirname "$0")/lib.sh"
out=$(bash -e -c 'x=$(exit 3); echo "reached the next line"')
[ -z "$out" ] && pass "script died at the assignment, the next line never ran" \
             || fail "the next line ran: $out"
