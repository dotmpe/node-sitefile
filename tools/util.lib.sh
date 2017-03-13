#!/bin/sh

set -e


lib_load()
{
  test -n "$1" || set -- sys os std str
  while test -n "$1"
  do
    . $scriptdir/$1.lib.sh load-ext
    shift
  done
}

# Id: node-sitefile/0.0.6-dev tools/util.lib.sh
