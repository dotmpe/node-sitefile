#!/usr/bin/env bash

set -e -o pipefail -o nounset

true "${X_DCKR_CI_TIME:="` git show -s --format=%cI $GIT_SHA1`"}"
true "${X_DCKR_AI_TIME:="` git show -s --format=%aI $GIT_SHA1`"}"


urlsafe_datetime()
{
  test -n "${1:-}" || set -- "$(date --rfc-3339=seconds)"

  echo "$1" |tr ' ' 'T' |sed 's/+00:00/Z/g' |sed 's/+/%2B/g'
}

abort_build()
{
  e=$?
  test $e -eq 0 && return
  { cat <<EOM
Error $e at $BASH_COMMAND :$BASH_LINENO
EOM
} >&2
  curl -sSf -X POST \
    "https://dotmpe.com/build.php?i=${BUILD_KEY}&c=3&e=${e}&BUILD_ID=${BUILD_CODE}&ABORT=$(urlsafe_datetime)"
  return $e
}

trap abort_build EXIT
