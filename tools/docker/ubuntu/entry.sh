#!/bin/bash


test -n "$1" || set -- "github.com/bvberkum/node-sitefile" "$2" "$3"

test -d "/src/$1" || {
  test -n "$3" || {
    echo "Missing repo for site '$1'"
    exit 1
  }
  git clone $3 /src/$1
}

cd /src/$1

test -z "$2" || git checkout $2

test ! -e package.json || npm install

sitefile
