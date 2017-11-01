#!/bin/bash

mv Package.swift .Package.swift && cp .Package.test.swift Package.swift
swift build && swift test
RETVAL=$?
mv .Package.swift Package.swift
exit $RETVAL
