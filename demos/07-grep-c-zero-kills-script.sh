#!/usr/bin/env bash
# Under `set -e -o pipefail`, `X=$(... | grep -c pattern)` kills the script when there are 0 matches,
# because grep -c prints 0 AND exits 1. Checks like "0 errors is good" die mid-run.
. "$(dirname "$0")/lib.sh"
# 1) The mechanism: grep -c prints 0 and exits 1 on zero matches.
out=$(echo "all fine" | grep -c ERROR); rc=$?
[ "$out" = 0 ] && [ "$rc" = 1 ] || fail "grep -c on zero matches printed '$out' with rc=$rc (expected 0 and 1)"
# 2) The consequence: the script stops at the assignment. Marker lines prove how far it got.
trace=$(bash -c 'set -e -o pipefail; echo before; X=$(echo "all fine" | grep -c ERROR); echo "after: $X"'); srv=$?
# 3) Control: with a match the same script runs to the end.
control=$(bash -c 'set -e -o pipefail; echo before; X=$(echo "ERROR" | grep -c ERROR); echo "after: $X"')
[ "$control" = "before
after: 1" ] || fail "control run did not complete: $control"
[ "$trace" = before ] && [ "$srv" = 1 ] && pass "zero matches: script stopped after 'before' (rc=$srv); one match: ran to the end"
fail "trace='$trace' rc=$srv"
