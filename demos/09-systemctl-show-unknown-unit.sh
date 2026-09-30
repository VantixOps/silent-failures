#!/usr/bin/env bash
# `systemctl show` on a unit that does not exist returns exit status 0 and default values.
# Always read LoadState.
. "$(dirname "$0")/lib.sh"
command -v systemctl >/dev/null || skip "systemctl not available"
unit="does-not-exist-$RANDOM$RANDOM.service"
out=$(systemctl show "$unit" -p LoadState 2>/dev/null); rc=$?
[ -z "$out" ] && skip "systemctl could not talk to systemd here"
[ "$rc" = 0 ] && [ "$out" = "LoadState=not-found" ] && pass "rc=0 for a missing unit, only LoadState tells: $out" \
                                                    || fail "rc=$rc out=$out"
