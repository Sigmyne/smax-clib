---
excerpt: C/C++ client library for SMA-X structured data exchange.
---

<img src="/smax-clib/resources/Sigmyne-logo-200x44.png" alt="Sigmyne logo" width="200" height="44" align="right"><br clear="all">

<img src="https://img.shields.io/github/v/release/Sigmyne/smax-clib?label=github" class="badge" alt="GitHub release version" align="left">
<img src="https://img.shields.io/vcpkg/v/smax-clib" class="badge" alt="vcpkg version">
<img src="https://img.shields.io/badge/dynamic/json.svg?url=https://raw.githubusercontent.com/attipaci/homebrew-pub/pkginfo/smax-clib.json&query=$.versions.stable&label=homebrew" class="badge" alt="Homebrew package version" align="left">


The SMA information eXchange (SMA-X) is a high performance and versatile data sharing platform for distributed software
systems. It is built around a central Redis database, and provides atomic access to structured data, including 
specific branches and/or leaf nodes, with associated metadadata. The lead architect of SMA-X is Attila Kovács at the 
Center for Astrophysics \| Harvard &amp; Sigmyne.

The __smax-clib__ C/C++ client library was created, and is maintained, by Attila Kovács at the Center for Astrophysics 
\| Harvard &amp; Sigmyne, and it is available through the 
[Sigmyne/redisx](https://github.com/Sigmyne/smax-clib) repository on GitHub. 

If you use SMA-X for your project, please cite as: 

 - Kovács, Attila, Grimes, Paul K., Moriarty, Christopher, and Wilson, Robert, Journal of Astronomical Telescopes, 
   Instruments, and Systems, Volume 11, id. 017001 (2025). (DOI:
   [10.1117/1.JATIS.11.1.017001](https://ui.adsabs.harvard.edu/link_gateway/2025JATIS..11a7001K/doi:10.1117/1.JATIS.11.1.017001)). 

This site contains various online resources that support the library:

__Documentation__

 - [User's guide](doc/README.md) (`README.md`)
 - [API Documentation](apidoc/html/files.html)
 - [History of changes](doc/CHANGELOG.md) (`CHANGELOG.md`)
 - [Issues](https://github.com/Sigmyne/smax-clib/issues) affecting __smax-clib__ releases (past and/or present)
 - [Community Forum](https://github.com/Sigmyne/smax-clib/discussions) &ndash; ask a question, provide feedback, or 
   check announcements.

__Dependencies__

 - [Sigmyne/xchange](https://github.com/Sigmyne/xchange) -- structured data exchange framework
 - [Sigmyne/redisx](https://github.com/Sigmyne/redisx) -- A C/C++ Redis client library
 - [Smithsonian/smax-server](https://github.com/Smithsonian/smax-server) -- SMA-X server configuration kit
 
__Downloads__

 - [Releases](https://github.com/Sigmyne/smax-clib/releases) from GitHub
 
__vcpkg Registry__

You can also install the __smax-clib__ library with `vcpkg` on Linux, MacOS, Windows, and Android as:

```bash
  $ vcpkg install smax-clib
```

Or, with the optional `tls` components (for TLS encryption support) as:

```bash
  $ vcpkg install smax-clib[core,tls]
```

__Homebrew__ 

Or, install via the Homebrew package manager (MacOS and Linux) through the maintainer's own Tap:

```bash
  $ brew tap attipaci/pub
  $ brew install smax-clib
```

For more customized installations, you can add the following options also:

 | Option                 | Description                                                                    |
 |:---------------------- |:------------------------------------------------------------------------------ |
 | `--without-openssl`    | Build without TLS support.                                                     | 
 | `--with-doxygen`       | Install with local HTML documentation.                                         |
 

