# Quick Reference: COPR Setup for libnbcompat

This is a condensed reference for quickly setting up a COPR repository. For detailed instructions, see [COPR_SETUP.md](COPR_SETUP.md).

## Prerequisites

- Fedora Account (create at https://accounts.fedoraproject.org/)
- Access to COPR (https://copr.fedorainfracloud.org/)

## Quick Setup via Web Interface

1. **Login**: Visit https://copr.fedorainfracloud.org/ and sign in

2. **Create Project**: 
   - Click "New Project"
   - Name: `libnbcompat`
   - Description: `Portable NetBSD compatibility library`
   - Select Fedora versions (e.g., Fedora 39, 40, Rawhide)
   - Click "Create"

3. **Build Package**:
   - Go to "Builds" → "New Build"
   - Select "SCM" tab
   - Clone URL: `https://github.com/dioni21/libnmcompat.git`
   - Spec file: `libnbcompat.spec`
   - Click "Build"

4. **Wait for Build**: Monitor build progress (typically 5-20 minutes)

## Quick Setup via CLI

```bash
# Install COPR CLI
sudo dnf install copr-cli

# Configure (get token from https://copr.fedorainfracloud.org/api/)
# Save to ~/.config/copr

# Create project
copr-cli create libnbcompat \
  --chroot fedora-39-x86_64 \
  --chroot fedora-40-x86_64 \
  --description "Portable NetBSD compatibility library"

# Build from SCM
copr-cli buildscm libnbcompat \
  --clone-url https://github.com/dioni21/libnmcompat.git \
  --spec libnbcompat.spec \
  --type git
```

## Installation (End Users)

Once your COPR is set up, users can install with:

```bash
sudo dnf copr enable YOUR_USERNAME/libnbcompat
sudo dnf install libnbcompat libnbcompat-devel
```

## Files in This Repository

- `libnbcompat.spec` - RPM spec file (required for building)
- `COPR_SETUP.md` - Detailed setup instructions
- `README.md` - Project overview

## Upstream Source

The package builds directly from the upstream GitHub release:
- Repository: https://github.com/archiecobbs/libnbcompat
- Source: https://github.com/archiecobbs/libnbcompat/archive/refs/tags/2020-08-17.tar.gz

No source files are copied to this repository - the spec file downloads them during build.
