#!/usr/bin/env bash
# Validate a pull request title against the Conventional Commits subject rules.
set -euo pipefail

readonly MAX_LENGTH=72
readonly TYPES="feat|fix|perf|refactor|test|docs|chore|ci|style|revert"
readonly PATTERN="^(${TYPES})(\([a-z0-9][a-z0-9._/-]*\))?!?: .+"

fail() {
  echo "invalid pr title \"${title}\": $1" >&2
  exit 1
}

if [ "$#" -ne 1 ]; then
  echo "usage: $0 <title>" >&2
  exit 2
fi
title="$1"

[[ "$title" =~ $PATTERN ]] \
  || fail "expected 'type(scope): subject' with type one of ${TYPES//|/, }"
[ "${#title}" -le "$MAX_LENGTH" ] \
  || fail "${#title} characters, the limit is ${MAX_LENGTH}"

subject="${title#*: }"
[[ "$subject" != *. ]] || fail "subject must not end with a period"
[[ "$subject" != [[:upper:]]* ]] || fail "subject must start in lower case"
[[ "$subject" != " "* ]] || fail "subject must not start with whitespace"

echo "ok: ${title}"
