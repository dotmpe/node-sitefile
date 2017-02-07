#!/bin/sh

test -n "$scriptdir" || export scriptdir="$(pwd -P)/tools"

. $scriptdir/util.lib.sh

lib_load

# Id: node-sitefile/0.0.6-dev tools/sh/init.sh
