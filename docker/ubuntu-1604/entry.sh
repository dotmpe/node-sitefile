#!/bin/bash

test -n "$1" || set -- "node-sitefile" "$2" "$3"
test -n "$2" || set -- "$1" "master" "$3"

test -d "/src/$1" || {
  test -n "$3" || {
    echo "Missing repo for site '$1'"
    exit 1
  }
}

cd $1

git checkout $2

sitefile

