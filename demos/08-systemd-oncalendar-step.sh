#!/usr/bin/env bash
# `OnCalendar=04:00..09:45/5` is NOT "every 5 minutes from 4:00 to 9:45".
# The step applies to the SECONDS field: it fires at 04:00:45, 04:00:50, ...
. "$(dirname "$0")/lib.sh"
command -v systemd-analyze >/dev/null || skip "systemd-analyze not available"
# TZ=UTC makes the output independent of the machine's time zone; only the local-time lines count.
raw=$(TZ=UTC systemd-analyze calendar --iterations=3 '04:00..09:45/5' 2>&1); rc=$?
[ "$rc" = 0 ] || fail "systemd-analyze exited $rc: $raw"
next=$(printf '%s\n' "$raw" | grep -E 'Next elapse|Iteration #' | grep -Eo '[0-9]{2}:[0-9]{2}:[0-9]{2}' | tr '\n' ' ')
[ "$next" = "04:00:45 04:00:50 04:00:55 " ] && pass "next elapses: $next(seconds, not minutes)"
fail "next elapses: '$next'"
