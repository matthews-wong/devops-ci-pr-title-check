#!/usr/bin/env bash
# Table-driven tests for scripts/check-pr-title.sh.
set -uo pipefail

CHECK="$(dirname "$0")/../scripts/check-pr-title.sh"
readonly CHECK
failures=0

expect() {
  local want="$1" title="$2" got=0
  "$CHECK" "$title" >/dev/null 2>&1 || got=$?
  if [ "$got" -ne "$want" ]; then
    echo "FAIL: \"${title}\" exited ${got}, wanted ${want}" >&2
    failures=$((failures + 1))
  fi
}

expect 0 "feat: add retry budget"
expect 0 "fix(api): handle empty body"
expect 0 "feat(engine)!: drop the v1 config format"
expect 0 "ci: pin actions by sha"
expect 1 "added retry budget"
expect 1 "wip: add retry budget"
expect 1 "Feat: add retry budget"
expect 1 "feat(Api): add retry budget"
expect 1 "feat: Add retry budget"
expect 1 "feat: add retry budget."
expect 1 "feat:add retry budget"
expect 1 "feat:  add retry budget"
expect 1 "feat: $(printf 'x%.0s' {1..70})"
expect 0 "feat: $(printf 'x%.0s' {1..66})"
expect 1 ""

if [ "$failures" -gt 0 ]; then
  echo "${failures} test(s) failed" >&2
  exit 1
fi
echo "all pr title tests passed"
