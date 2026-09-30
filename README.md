# silent-failures

Shell and Linux pitfalls that **fail without failing**: no red test, no error message, exit code 0 – and the problem shows up days later. Every entry here cost us real time in production.

Each lesson is a small runnable script that **proves** the behavior on your machine. GitHub Actions runs all of them on every push, so the badge below tells you whether each lesson still holds on current Ubuntu.

[![lessons still true](https://github.com/VantixOps/silent-failures/actions/workflows/check.yml/badge.svg)](https://github.com/VantixOps/silent-failures/actions/workflows/check.yml)

```bash
git clone https://github.com/VantixOps/silent-failures && cd silent-failures
bash run_all.sh
```

`PASS` means the pitfall still exists exactly as described. `FAIL` means the behavior changed and the lesson needs an update – please open an issue. `SKIP` means your environment cannot show it (for example no passwordless `sudo`); a skip never counts as a pass.

## The lessons

| # | Pitfall | What to do instead |
|---|---|---|
| [01](demos/01-set-e-assignment.sh) | Under `set -e`, `x=$(failing_cmd)` kills the script – a `$?` check on the next line never runs. | `if x=$(cmd); then …; else rc=$?; fi` |
| [02](demos/02-if-without-else.sh) | `if cmd; then …; fi; rc=$?` is always `0`: an `if` without `else` returns 0 when the condition fails. | Capture the status inside the `if`/`else`. |
| [03](demos/03-pipe-status.sh) | `cmd \| tail` reports the status of `tail`, not of `cmd`. | `set -o pipefail` or `${PIPESTATUS[0]}` |
| [04](demos/04-grep-wc-missing-file.sh) | `grep pattern file \| wc -l` prints `0` with status 0 both for an existing file without matches **and** for a file that does not exist. "0 findings" and "never measured" look the same. | Check that the input exists; test every zero against a case that must match. |
| [05](demos/05-set-u-no-err-trap.sh) | An unset variable under `set -u` kills bash **without** running the `ERR` trap. In cron that looks like success. | Add an `EXIT` trap that checks for an end marker. |
| [06](demos/06-exit-in-subshell.sh) | `exit` in a function called via `$(…)` only ends the subshell; the script keeps running. | `return` a status and check it at the caller. |
| [07](demos/07-grep-c-zero-kills-script.sh) | With `set -e -o pipefail`, `X=$(… \| grep -c pattern)` kills the script on **zero** matches (`grep -c` prints 0 and exits 1). "0 errors is good" checks die mid-run. | Treat exit 1 as a valid "no match", exit >1 as a real error. |
| [08](demos/08-systemd-oncalendar-step.sh) | `OnCalendar=04:00..09:45/5` is not "every 5 minutes from 4:00 to 9:45" – the step applies to the **seconds**. | Always check with `systemd-analyze calendar`. |
| [09](demos/09-systemctl-show-unknown-unit.sh) | `systemctl show` on a unit that does not exist returns status 0 and default values. | Always read `LoadState`. |
| [10](demos/10-gitignore-tracked-file.sh) | `.gitignore` only affects untracked files. An already committed file stays tracked – the rule is there and does nothing. | `git rm --cached <file>`. Note: `git check-ignore -v file` says nothing for tracked files – use `git check-ignore -v --no-index file`. |
| [11](demos/11-glob-before-sudo.sh) | In `sudo ls /protected/file-*`, **your** shell expands the glob. Without read access the `*` stays literal and `ls` says "No such file" although the files exist. | `sudo sh -c 'ls /protected/file-*'` |

## The rule behind all of them

**A zero needs a positive control.** Before you trust "0 findings", "exit 0" or "active", run the same check against something that must be found. Most of the failures above were only discovered that way.

## Contributing

Found another silent failure? Open an issue or a pull request with a demo script in the same style: it must `pass` while the pitfall exists and `fail` when the behavior changes.

## License

MIT – see [LICENSE](LICENSE). Made by [VantixOps](https://vantix-ops.de), Bremen, Germany.
