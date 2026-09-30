# shellcheck shell=bash
# Shared helpers. Each demo asserts that a surprising behavior is STILL true.
# PASS = the pitfall still exists as described. FAIL = behavior changed, the lesson needs an update.
# SKIP = the environment cannot show it (missing tool or permission) - never counted as PASS.
pass() { echo "PASS  $DEMO: $*"; exit 0; }
fail() { echo "FAIL  $DEMO: $*"; exit 1; }
skip() { echo "SKIP  $DEMO: $*"; exit 77; }
DEMO=$(basename "$0" .sh)
