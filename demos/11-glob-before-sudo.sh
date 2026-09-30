#!/usr/bin/env bash
# In `sudo ls /protected/file-*` YOUR shell expands the glob, not root. If you cannot read the
# directory, the * stays literal and ls reports "No such file" although the files exist.
. "$(dirname "$0")/lib.sh"
sudo -n true 2>/dev/null || skip "needs passwordless sudo"
[ "$(id -u)" = 0 ] && skip "runs as root already - the effect needs an unprivileged caller"
dir=$(sudo -n mktemp -d /tmp/sf-protected.XXXXXX) || fail "could not create a root-owned directory"
trap 'sudo -n rm -r -- "${dir:?}"' EXIT
sudo -n chmod 700 "$dir" && sudo -n touch "$dir/backup-1"
[ -r "$dir" ] && fail "precondition broken: caller can read $dir"
sudo -n ls "$dir"/backup-* >/dev/null 2>&1; wrong=$?
sudo -n sh -c "ls $dir/backup-*" >/dev/null 2>&1; right=$?
[ "$wrong" != 0 ] && [ "$right" = 0 ] && pass "sudo ls <glob> fails (rc=$wrong), sudo sh -c 'ls <glob>' finds the file"
fail "wrong=$wrong right=$right"
