# Changelog

All notable changes to the [Sigmyne/smax-clib](https://github.com/Sigmyne/smax-clib) library will be 
documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to 
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [1.0.1-rc1] - 2026-05-31

Release candidate for the upcoming maintenance release, expected around 15 July 2026.

### Fixed

 - Fixed `smaxStringToValues()` for `XLLONG` type.
 
 - Conditional assignment of optional arg in `smaxParseTime()`.
 
 - Fix name matching in `smaxGetCoordinateAxis()`. Previously, the conditions for matching were inverted.

 - Various issues fixed that were potted by Facebook's infer v1.3.
 
 - Various issues fixed that were spotted by GitHub Copilot AI.

### Changed

 - Hash algorithms switched to FNV-1a.

 - Use `snprintf()` instead of `sprintf()` when possible.

 - Printing of `size_t` values (in debug mode).
 
 - Bumbed default internal lookup cache size to 1024 slots (from 256).
 
 - Various `Makefile` improvements.
 

## [1.0.0] - 2026-02-16

Initial public release.
