#!/bin/bash

# Id: git-versioning/0.0.16-dev-master+20150504-0251 tools/version-check.sh

V_PATH_LIST=$(cat $1)
VER_STR=$2

e=0
for doc in $V_PATH_LIST
do
  # XXX: should want to know if any mismatches, regardless wether one matches

  if [ "$doc" = ".sitefilerc" ]
  then
    grep '"sitefilerc":.*'$2 $doc >> /dev/null && {
      echo "Version match in $doc"
    } || {
      echo "Version mismatch in $doc" 1>&2
      e=$(( $e + 1 ))
    }
    continue
  fi

  if [ "$doc" = "Sitefile.yaml" ]
  then
    grep '^sitefile:.*'$2 $doc >> /dev/null && {
      echo "Version match in $doc"
    } || {
      echo "Version mismatch in $doc" 1>&2
      e=$(( $e + 1 ))
    }
    continue
  fi

  # generic
  ( grep -i 'version.*'$2 $doc || grep -i 'Id:.*'$2 $doc ) >> /dev/null && {
    echo "Version match in $doc"
  } || {
    echo "Version mismatch in $doc" 1>&2
    e=$(( $e + 1 ))
  }
done

# Check for version line in Changelog
grep -i '^'$2 Changelog.rst >> /dev/null && {
  echo "Changelog entry $2"
} || { 
  echo "Changelog no entry $2" 1>&2
  e=$(( $e + 1 ))
}

exit $e
