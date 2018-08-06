#!/bin/bash
set -e

# Set env, use first three arguments for src-path/repo/version

test -z "$1" || site_src=$1
test -z "$2" || site_repo=$2
test -z "$3" || site_ver=$3

test -n "$site_src" || site_src=github.com/bvberkum/node-sitefile
test -n "$site_repo" || site_repo=http://$site_src
test -n "$site_ver" || site_ver=master

test -n "$git_remote" || git_remote=origin
# Ether to update SCM/NPM before starting server
test -n "$site_update" || site_update=1


stderr()
{
  echo "$1" >&2
  test -z "$2" || exit $2
}

# Use vendorized src-path as 'install dir'

test -d "/src/$site_src" || {
  mkdir -vp /src/$(dirname $site_src) &&
  git clone $site_repo /src/$site_src
}

cd /src/$site_src

test -w . -a "$src_site_update" = "1" && {

  test -d .git && {

    # Update GIT if Site-Version was requested
    test -z "$site_ver" &&
      stderr "No SCM updates" || {

      git show-ref --verify -q refs/tags/$site_ver && {

        # Update if Site-Ver is a tag
        git tag -d $site_ver || exit $?
      }

      git fetch $git_remote || stderr "Fetch error $?" 1
      git checkout $site_ver || stderr "Checkout error $?" 1

      git show-ref --verify -q refs/heads/$site_ver && {

        # Update if Site-Ver is a branch
        git show-ref --verify -q refs/remotes/$git_remote/$site_ver && {
          git rev-parse --symbolic --abbrev-ref $site_ver@{u} || {
            git branch --set-upstream-to=$git_remote/$site_ver $site_ver
          }
        } || stderr "No remote branch $git_remote/$site_ver"

        git pull || stderr "Pull error $?" 1
      }
    }

  } || {

    test -z "$site_ver" ||
      stderr "Dir $site_src exists but is not a repository, cannot update SCM to version" 1
  }

  # One more env preparation step
  test ! -e package.json || {
    npm install || stderr "NPM install error $?" 1
  }

} || {

  test "$src_site_update" = "1" &&
    stderr "Source dir is not writable to server, skipped env preparation" || {

    real_ver="$(git show-ref --head HEAD -s)" # XXX: misses tags
    test -z "$site_ver" -o "$real_ver" = "$site_ver" &&
      stderr "No update requested, version $site_ver OK" ||
      stderr "No update requested, version $real_ver does not match requested $site_ver"
  }
}

# Start server
sitefile

# Id: sitefile/0.0.7-dev
