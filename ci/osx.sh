#!/bin/bash

set -eux
set -o pipefail

xcodebuild \
  -project 'CBGPromise.xcodeproj' \
  -scheme 'CBGPromise-OSX' \
  clean build test \
  | tee $CIRCLE_ARTIFACTS/xcode-osx.log \
  | xcpretty --color --report junit --output $CIRCLE_TEST_REPORTS/results-osx.xml
