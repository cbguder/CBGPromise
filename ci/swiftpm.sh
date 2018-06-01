#!/bin/bash

set -eux

swift build && swift test
