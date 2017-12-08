#!/bin/bash
set -e

# Set env, default to arguments

test -n "$site_src" || site_src=github.com/bvberkum/node-sitefile
test -n "$site_repo" || site_repo=
test -n "$site_ver" || site_ver=
test -n "$git_remote" || git_remote=origin

test -z "$1" || site_src=$1
test -z "$2" || site_repo=$2
test -z "$3" || site_ver=$3

stderr()
{
  echo "$1" >&2
  test -z "$2" || exit $2
}

# Use vendorized src-path as 'install dir'

test -d "/src/$site_src" || {
  test -n "$site_repo" || {
    echo "Missing src or repo for site '$site_src'"
    exit 1
  }
  mkdir -vp /src/$(dirname $site_src)
  git clone http://$site_src /src/$site_src
}

cd /src/$site_src

test -d .git && {

  # Update GIT if Site-Version was requested
  test -z "$site_ver" || {

    git show-ref --verify -q refs/tags/$site_ver && {

      # Update if Site-Ver is a tag
      git tag -d $site_ver || exit $?
    }

    git fetch $git_remote || exit $?
    git checkout $site_ver || exit $?

    git show-ref --verify -q refs/heads/$site_ver && {

      # Update if Site-Ver is a branch
      git show-ref --verify -q refs/remotes/$git_remote/$site_ver && {
        git rev-parse --symbolic --abbrev-ref $site_ver@{u} || {
          git branch --set-upstream-to=$git_remote/$site_ver $site_ver
        }
      } || stderr "No remote branch $git_remote/$site_ver"
      git pull || exit $?
    }
  }

} || {

  test -z "$site_ver" ||
    stderr "Dir $site_src exists but is not a repository" 1
}

# One more step
test ! -e package.json || npm install

# Start server
sitefile

# Id: sitefile/0.0.7-dev
