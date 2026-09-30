#!/usr/bin/env bash
# `cmd | tail` reports the status of tail, not of cmd. Fix: `set -o pipefail` or ${PIPESTATUS[0]}.
. "$(dirname "$0")/lib.sh"
plain=$(bash -c 'false | true; echo $?')
fixed=$(bash -c 'set -o pipefail; false | true; echo $?')
[ "$plain" = 0 ] && [ "$fixed" = 1 ] && pass "without pipefail the failure is hidden (0), with pipefail it shows (1)" \
                                     || fail "plain=$plain pipefail=$fixed"
