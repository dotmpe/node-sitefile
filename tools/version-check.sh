#!/bin/bash

V_PATH_LIST=$(cat $1)
VER_STR=$2

e=0
for doc in $V_PATH_LIST
do
  grep -i 'version.*'$2 $doc >> /dev/null && {
    echo "Version matches $2 in $doc"
  } || { 
    echo "Version mismatch in $doc"
    e=1
  }
done

# Check for version line in Changelog
grep -i '^'$2 Changelog.rst >> /dev/null && {
  echo "Changelog entry $2"
} || { 
  echo "Changelog no entry $2"
  e=1
}

exit $e
