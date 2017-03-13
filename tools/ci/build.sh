#!/bin/sh

note "Entry for CI build phase: '$BUILD_STEPS'"

for BUILD_STEP in $BUILD_STEPS
do case "$BUILD_STEP" in

    check )
        git-versioning check
      ;;

    selenium-server )
        test "$TRAVIS_NODE_VERSION" != "0.12" || {
          npm uninstall selenium-webdriver; npm install selenium-webdriver@2.53.3;
        }
        sh -e /etc/init.d/xvfb start
        wget http://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.0.jar
        sleep 3
        java -jar selenium-server-standalone-2.53.0.jar > /dev/null &
      ;;

    dev )
        NODE_ENV=development npm install
        #lib_load main; main_debug
      ;;

    test )
        #lib_load build
        ./configure
        grunt test
      ;;

    noop )
        # TODO: make sure nothing, or as little as possible has been installed
        note "Empty step ($BUILD_STEP)" 0
      ;;

    * )
        error "Unknown step '$BUILD_STEP'" 1
      ;;

  esac

  note "Step '$BUILD_STEP' done"
done

note "Done"

# Id: node-sitefile/0.0.6-dev tools/ci/build.sh
