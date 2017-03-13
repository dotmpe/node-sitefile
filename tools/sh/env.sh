#!/bin/sh

set -e

req_vars scriptname || error "scriptname" 1
req_vars scriptdir || error "scriptdir" 1

req_vars verbosity || export verbosity=7
req_vars DEBUG || export DEBUG=


### Start of build job parameterisation

GIT_CHECKOUT=$(git log --pretty=oneline | head -n 1 | cut -f 1 -d ' ')
BRANCH_NAMES="$(echo $(git ls-remote origin | grep -F $GIT_CHECKOUT \
        | sed 's/.*\/\([^/]*\)$/\1/g' | sort -u ))"

test -n "$ENV" || {

  ENV=testing

  #note "Branch Names: $BRANCH_NAMES"
  #case "$BRANCH_NAMES" in
  #esac
}

case "$ENV" in

    testing )

        # setup selenium server for testing on Travis
        trueish "$SHIPPABLE" || {
          test "$(whoami)" != "travis" || {
            BUILD_STEPS="selenium-server"
          }
        }

        test -x "$(which rst2html)" || {
          mkdir ~/bin && cd ~/bin && ln -s $(which rst2html.py) rst2html;
        }
        rst2html --version
      ;;

    * )
        error "ENV '$ENV'" 1
      ;;

esac



# Defaults
req_vars Build_Deps_Default_Paths ||
  export Build_Deps_Default_Paths=1
req_vars sudo || export sudo=sudo

req_vars BUILD_STEPS || export BUILD_STEPS="\
 check dev test "

req_vars DISPLAY || export DISPLAY=:99.0


test -n "$TRAVIS_COMMIT" || GIT_CHECKOUT=$TRAVIS_COMMIT

### Env of build job parameterisation

note "Build Steps: $BUILD_STEPS"

# Id: node-sitefile/0.0.6-dev tools/sh/env.sh
