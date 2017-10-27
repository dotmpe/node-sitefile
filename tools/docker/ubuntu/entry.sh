#!/bin/bash

# Set env, default to arguments

test -n "$site_src" || site_src=github.com/bvberkum/node-sitefile
test -n "$site_repo" || site_repo=
test -n "$site_ver" || site_ver=

test -z "$1" || site_src=$1
test -z "$2" || site_repo=$2
test -z "$3" || site_ver=$3

test -d "/src/$site_src" || {
  test -n "$ver" || {
    echo "Missing src or repo for site '$site_src'"
    exit 1
  }
  git clone $ver /src/$site_src
}


cd /src/$site_src

test -z "$repo" || git checkout $repo

test ! -e package.json || npm install

sitefile

# Id: sitefile/0.0.7-dev
