#!/bin/bash

set -eux
set -o pipefail

xcodebuild \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 7,OS=latest' \
  -project 'CBGPromise.xcodeproj' \
  -scheme 'CBGPromise-iOS' \
  clean build test \
  | tee $CIRCLE_ARTIFACTS/xcode-ios.log \
  | xcpretty --color --report junit --output $CIRCLE_TEST_REPORTS/results-ios.xml
