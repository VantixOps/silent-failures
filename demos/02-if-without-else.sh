#!/usr/bin/env bash
# `if cmd; then ...; fi; rc=$?` is always 0 - an `if` without `else` returns 0 when the condition fails.
. "$(dirname "$0")/lib.sh"
rc=$(bash -c 'if false; then :; fi; echo $?')
[ "$rc" = 0 ] && pass "rc after a failed if-condition is 0, the failure is invisible" \
              || fail "rc is $rc"
