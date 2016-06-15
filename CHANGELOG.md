# Change Log

## [0.3.1] - 2016-06-15
### Added
- Can now map futures

### Changed
- Future.wait() now returns the future's value
- Minimum deploy targets are lowered to iOS 8 and macOS 10.11

## [0.3.0] - 2016-04-17
### Changed
- Promises now resolve with a single type
- Changed OS X deployment target to 10.10
- Trying to resolve a promise more than once raises an exception

## [0.2.0] - 2016-01-12
### Added
- Can now chain callbacks
- Can now add multiple success/error callbacks
- Changed iOS deployment target to 8.0

### Changed
- The error type is now parameterized

## [0.1.1] - 2015-11-21
### Added
- Can now wait for promises to resolve by calling `.wait()` on a `Future`

## 0.1.0 - 2015-11-18
- Initial release

[0.1.1]: https://github.com/cbguder/CBGPromise/compare/v0.1.0...v0.1.1
[0.2.0]: https://github.com/cbguder/CBGPromise/compare/v0.1.1...v0.2.0
[0.3.0]: https://github.com/cbguder/CBGPromise/compare/v0.2.0...v0.3.0
[0.3.1]: https://github.com/cbguder/CBGPromise/compare/v0.3.0...v0.3.1
