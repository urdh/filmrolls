# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- The minimum required ruby version is now 3.0.0

## [0.2.1] - 2019-06-02
### Changed
- Prefer `DateTimeOriginal` over `DateTimeCreated` when writing copyright metadata

## [0.2.0] - 2019-06-01
### Added
- Support for writing author metadata (copyright, license, etc.)

## [0.1.3] - 2019-05-30
### Fixed
- Write APEX shutter speed values and non-APEX aperture values

## [0.1.2] - 2019-05-29
### Fixed
- Write correct values to GPS latitude/longitude reference fields
- Set `ISOSpeed` and `SensitivityType` EXIF tags

## [0.1.1] - 2019-05-26
### Fixed
- Write `ExposureTime` EXIF tag rather than `ShutterSpeedValue`
- Trim spaces from camera and lens make/model EXIF tags

## [0.1.0] - 2019-05-24
### Added
- First release of the `filmrolls` tool

[Unreleased]: https://github.com/urdh/filmrolls/compare/v0.2.1...HEAD
[0.2.1]: https://github.com/urdh/filmrolls/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/urdh/filmrolls/compare/v0.1.3...v0.2.0
[0.1.3]: https://github.com/urdh/filmrolls/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/urdh/filmrolls/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/urdh/filmrolls/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/urdh/filmrolls/releases/tag/v0.1.0
