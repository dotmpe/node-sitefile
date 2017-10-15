#!/bin/sh
set -e

test -x "$(which tap-json)" || npm install -g tap-json
test -e node_modules/nano || npm install nano

CI_BUILD_RESULTS=mocha-results.json
cat mocha-results.tap | tap-json > $CI_BUILD_RESULTS
test -s "$CI_BUILD_RESULTS" || {
  echo No results
  exit 1
}

echo '----dig'
dig +short myip.opendns.com @resolver1.opendns.com || true
echo '----ifc.co'
curl ifconfig.co
echo '----env'
env | grep TRAVIS
echo '-----------'
echo
CI_BUILD_RESULTS=$CI_BUILD_RESULTS \
CI_DB_HOST="$CI_DB_HOST" \
CI_DB_INFO="$CI_DB_INFO" \
CI_DB_NAME='build-log' \
CI_DB_KEY="$TRAVIS_REPO_SLUG" \
  node ./tools/update-couchdb-testlog.js
#rm mocha-results.tap $CI_BUILD_RESULTS
