#!/bin/bash

set -eux
set -o pipefail

apt update
apt install -yqq lsb-release curl git cmake ninja-build clang python uuid-dev libicu-dev icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig libpython-dev libncurses5-dev pkg-config

set +u
eval "$(curl -sL https://swiftenv.fuller.li/install.sh)"
set -u

swiftenv install 4.1.2
swiftenv global 4.1.2
