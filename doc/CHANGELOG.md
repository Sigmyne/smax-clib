# Changelog

All notable changes to the [Sigmyne/smax-clib](https://github.com/Sigmyne/smax-clib) library will be 
documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to 
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [1.0.1] - 2026-06-21

Maintenance release, with bug fixes and various improvements.

### Fixed

 - Fixed `smaxStringToValues()` for `XLLONG` type.
 
 - Conditional assignment of optional arg in `smaxParseTime()`.
 
 - Fix name matching in `smaxGetCoordinateAxis()`. Previously, the conditions for matching were inverted.

 - Various issues fixed that were potted by Facebook's infer v1.3.
 
 - Various issues fixed that were spotted by GitHub Copilot AI.

### Changed

 - Hash algorithms switched to FNV-1a.

 - Use `x_snprintf()` instead of `sprintf()` when possible.

 - Printing of `size_t` values (in debug mode).
 
 - Bumbed default internal lookup cache size to 1024 slots (from 256).
 
 - Uses `xIsDebug()` global function instead of `xDebug` global var, for better compatibility with Windows DLLs.
 
 - Various `Makefile` improvements.
 
 - Changed progress message format, with fixed width percentage in square brackets and '%' at end, e.g. "[100.0%] "
   before the message body.
 
 - On older platforms without `vsnprintf()`, progress messages of up to 8 kB are supported. Attempt to send longer 
   progress messages will result in program exit with an error. (Platforms with `vsnprintf()` support can send 
   progress messages of arbitrary size.
   
 - Progress messages enforce progress fraction in the [0.0:1.0] range. Out-of-bound input values are automatically 
   changed to the nearest bounding value (e.g. -1.0 to 0.0; 1.1 to 1.0).
 

## [1.0.0] - 2026-02-16

Initial public release.
