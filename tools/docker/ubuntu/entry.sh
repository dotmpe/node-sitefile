#!/bin/bash
set -e

# Set env, use first three arguments for src-path/repo/version

test -z "$1" || site_src=$1
test -z "$2" || site_repo=$2
test -z "$3" || site_ver=$3

test -n "$site_src" || site_src=github.com/bvberkum/node-sitefile
test -n "$site_repo" || site_repo=http://$site_src
test -n "$site_ver" || site_ver=r0.0.7

test -n "$git_remote" || git_remote=origin
# Ether to update SCM/NPM before starting server
test -n "$src_update" || src_update=1
test -n "$src_submodules" || src_submodules=1

user=$(whoami)
host=$(hostname -s)

stderr()
{
  echo "[$user@$host:$(date)] $1" >&2
  test -z "$2" || exit $2
}

stderr "Sitefile container starting at /src/$site_src <$site_repo> $site_ver"


# Use vendorized src-path as 'install dir'

test -d "/src/$site_src" || {

  test -w /src/ -o "$src_update" = "0" || {
    sudo -n chown -R $user:staff /src/
    test -w /src/ || stderr "Cannot write to /src/" 1
  }

  mkdir -vp /src/$(dirname $site_src) &&
  git clone $site_repo /src/$site_src &&
  cd /src/$site_src &&
  test -z "$site_ver" -o "$site_ver" = "master" || {
    git checkout -t origin/$site_ver -b $site_ver || stderr "Checkout error $?" 1
  }
}

test -w /src/$site_src -o "$src_update" = "0" ||
  stderr "Cannot write to /src/$site_src" 1

cd /src/$site_src

stderr "Sitefile container now in $(pwd) site root"


# Update from GIT if needed FIXME: install

test -w . -a "$src_update" = "1" && {
  stderr "Sitefile src-update requested"

  test -d .git && {

    # Update GIT if Site-Version was requested
    test -z "$site_ver" &&
      stderr "No SCM updates" || {
      stderr "Running SCM updates..."

      git show-ref --verify refs/tags/$site_ver && {

        # Update if Site-Ver is a tag
        git tag -d $site_ver || exit $?
      } || true

      git fetch $git_remote || stderr "Fetch error $?" 1

      git show-ref --verify refs/heads/$site_ver && {
        git checkout $site_ver -- || stderr "Checkout error $?" 1
      } || {
        git checkout -t origin/$site_ver -b $site_ver || stderr "Checkout error $?" 1
      }

      git show-ref --verify refs/heads/$site_ver && {

        # Update if Site-Ver is a branch
        git show-ref --verify refs/remotes/$git_remote/$site_ver && {
          git rev-parse --symbolic --abbrev-ref $site_ver@{u} || {
            git branch --set-upstream-to=$git_remote/$site_ver $site_ver
          }
        } || stderr "No remote branch $git_remote/$site_ver"

        stderr "Pulling..."
        git pull || stderr "Pull error $?" 1
      }
    }

    test ! -e .gitmodules -o $src_submodules -eq 0 || {
      stderr "Updating submodules..."
      git submodule update --init || stderr "GIT submodules error $?" 1
    }
  } || {

    test -z "$site_ver" ||
      stderr "Dir $site_src exists but is not a repository, cannot update SCM to version" 1
  }

  # One more env preparation step
  test ! -e package.json || {
    stderr "Installing local node packages..."
    npm install || stderr "NPM install error $?" 1
  }

  stderr "Sitefile src-update done"

} || {

  # No-op but some verbosity about src-update=0
  test "$src_update" = "1" &&
    stderr "Source dir is not writable to server, skipped env preparation" || {
    test ! -d .git || {
      real_ver="$(git show-ref --head HEAD -s)"

      test -z "$site_ver" -o "$real_ver" = "$site_ver" &&
        stderr "No update requested, version $site_ver OK" ||
        stderr "No update requested, version $real_ver does not match requested $site_ver"
    }
  }
}


stderr "OS release info:"
cat /etc/os-release

stderr 'Server env'
env | grep -i sitefile

stderr 'Checkout status'
git status

# Start server
stderr 'Sitefile server starting'
sitefile


# Id: sitefile/0.0.7-dev
