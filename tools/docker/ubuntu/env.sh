#!/usr/bin/env bash

true "${X_DCKR_CI_TIME:="` git show -s --format=%cI $GIT_SHA1`"}"
true "${X_DCKR_AI_TIME:="` git show -s --format=%aI $GIT_SHA1`"}"


urlsafe_datetime()
{
  test -n "${1:-}" || set -- "$(date --rfc-3339=seconds)"

  echo "$1" |tr ' ' 'T' |sed 's/+00:00/Z/g' |sed 's/+/%2B/g'
}
