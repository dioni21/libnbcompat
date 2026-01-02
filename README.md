# libnmcompat

This repository contains the Fedora COPR packaging for [libnbcompat](https://github.com/archiecobbs/libnbcompat), a portable NetBSD-compatibility library.

## About libnbcompat

libnbcompat is a portable NetBSD-compatibility library that provides NetBSD-specific functions and utilities for use on other operating systems.

## Files

- `libnbcompat.spec` - RPM spec file for building the package
- `COPR_SETUP.md` - Comprehensive instructions for setting up a COPR repository

## Quick Start

To set up a COPR repository for this package, see the detailed instructions in [COPR_SETUP.md](COPR_SETUP.md).

## Installation (once COPR repo is set up)

```bash
# Enable the COPR repository
sudo dnf copr enable YOUR_USERNAME/libnbcompat

# Install the package
sudo dnf install libnbcompat libnbcompat-devel
```

## Upstream

- Upstream repository: https://github.com/archiecobbs/libnbcompat
- Current packaged version: 2020-08-17
