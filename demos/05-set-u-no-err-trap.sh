#!/usr/bin/env bash
# An unset variable under `set -u` kills bash WITHOUT running the ERR trap.
# In cron this looks like success. Only an EXIT trap with an end marker notices.
. "$(dirname "$0")/lib.sh"
out=$(bash -c 'set -u; trap "echo ERR-TRAP" ERR; echo "$undefined_var"; echo reached' 2>/dev/null)
[ -z "$out" ] && pass "script died, ERR trap stayed silent" || fail "output: $out"
