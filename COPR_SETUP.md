# Fedora COPR Setup Instructions for libnbcompat

This document provides step-by-step instructions for creating a Fedora COPR repository to build and distribute the libnbcompat package.

## What is COPR?

COPR (Cool Other Package Repo) is a build system and repository hosting service for Fedora and other RPM-based distributions. It allows you to build and distribute custom RPM packages.

## Prerequisites

1. A Fedora Account System (FAS) account
2. Basic knowledge of RPM packaging
3. The spec file (`libnbcompat.spec`) from this repository

## Step 1: Create a COPR Account

1. Go to <https://copr.fedorainfracloud.org/>
2. Click "Sign In" in the top right corner
3. Sign in with your Fedora Account (or create one at <https://accounts.fedoraproject.org/>)
4. Accept the COPR terms of service

## Step 2: Create a New COPR Project

1. After logging in, click on "New Project" in the top menu
2. Fill in the project details:
   - **Project name**: `libnbcompat` (or your preferred name)
   - **Description**: `Portable NetBSD compatibility library`
   - **Instructions**: Add any usage instructions you want users to see
   - **Homepage**: `https://github.com/archiecobbs/libnbcompat`
   - **Contact**: Your email or contact information

3. Select the Chroots (build targets):
   - Check the Fedora versions you want to support (e.g., Fedora 39, Fedora 40, Fedora Rawhide)
   - Optionally check EPEL versions if you want RHEL/CentOS compatibility
   - Recommended: At least the latest stable Fedora and Fedora Rawhide

4. Click "Create" to create the project

## Step 3: Upload the Spec File

### Option A: Using the Web Interface

1. In your COPR project page, click on "Builds" tab
2. Click "New Build"
3. Select "Upload" tab
4. Upload the `libnbcompat.spec` file
5. In the "Source" section, you can either:
   - Upload a source tarball (if you have one)
   - Or specify the source URL in the spec file (recommended)
6. Click "Build" to start the build process

### Option B: Using SCM Integration (Recommended)

1. In your COPR project page, click on "Settings"
2. Scroll to "Source Type" and select "SCM"
3. Configure the SCM source:
   - **Clone URL**: `https://github.com/dioni21/libnbcompat.git`
   - **Committish**: `main` (or your branch name)
   - **Spec File Path**: `libnbcompat.spec`
   - **Type**: `git`
4. Save the settings
5. Go to "Builds" tab and click "Rebuild"
6. The system will automatically fetch from your Git repository and build

### Option C: Using the copr-cli Command Line Tool

1. Install the COPR CLI tool:

   ```bash
   sudo dnf install copr-cli
   ```

2. Configure authentication:

   ```bash
   # Go to https://copr.fedorainfracloud.org/api/
   # Copy your API token
   # Save it to ~/.config/copr
   ```

3. Create the project (if not created via web interface):

   ```bash
   copr-cli create libnbcompat \
     --chroot fedora-39-x86_64 \
     --chroot fedora-40-x86_64 \
     --chroot fedora-rawhide-x86_64 \
     --description "Portable NetBSD compatibility library" \
     --instructions "https://github.com/archiecobbs/libnbcompat"
   ```

4. Submit a build from the spec file:

   ```bash
   copr-cli build libnbcompat https://github.com/archiecobbs/libnbcompat/archive/refs/tags/1.0.2.tar.gz \
     --spec libnbcompat.spec
   ```

   Or if you have both the spec and source locally:

   ```bash
   copr-cli buildscm libnbcompat \
     --clone-url https://github.com/dioni21/libnbcompat.git \
     --spec libnbcompat.spec \
     --type git
   ```

## Step 4: Monitor the Build

1. After submitting the build, you'll be redirected to the build status page
2. The build process typically takes 5-20 minutes depending on the package complexity
3. Monitor the build logs for any errors
4. Common issues:
   - Missing BuildRequires dependencies
   - Incorrect file paths in %files section
   - Configuration errors in %build section

## Step 5: Testing the Built Package

Once the build succeeds:

1. Enable the COPR repository on a Fedora system:

   ```bash
   sudo dnf copr enable YOUR_USERNAME/libnbcompat
   ```

2. Install the package:

   ```bash
   sudo dnf install libnbcompat libnbcompat-devel
   ```

3. Test the installation:

   ```bash
   # Check installed files
   rpm -ql libnbcompat
   rpm -ql libnbcompat-devel

   # Verify library is loadable
   ldconfig -p | grep libnbcompat
   ```

## Step 6: Updating the Package

When upstream releases a new version:

1. Update the spec file:
   - Change the `Version:` field
   - Update the `Source0:` URL to point to the new tag
   - Add a changelog entry

2. Rebuild:
   - Via web interface: Click "New Build" and upload the updated spec
   - Via CLI: Run the `copr-cli build` command again with the new spec

## Maintenance Tips

1. **Enable auto-rebuild**: In COPR project settings, you can enable automatic rebuilds when dependencies are updated
2. **Monitor build failures**: Subscribe to email notifications for build status
3. **Keep spec file updated**: Maintain the spec file in your Git repository for easy version control
4. **Test before releasing**: Use scratch builds to test changes before making them available to users

## Additional Resources

- COPR Documentation: <https://docs.pagure.org/copr.copr/>
- RPM Packaging Guide: <https://rpm-packaging-guide.github.io/>
- Fedora Packaging Guidelines: <https://docs.fedoraproject.org/en-US/packaging-guidelines/>
- Upstream Project: <https://github.com/archiecobbs/libnbcompat>

## Troubleshooting

### Build fails with "configure: error"

Check the BuildRequires in the spec file. You may need to add additional development packages.

### Files not found in %files section

Review the build log to see where files are actually installed, then update the %files section accordingly.

### Library version conflicts

Ensure the library soname version in %files matches what's actually built. You may need to use wildcards like `libnbcompat.so.*`.

## Support

For issues with the upstream library, report them at: <https://github.com/archiecobbs/libnbcompat/issues>
For COPR-specific issues, visit: <https://pagure.io/copr/copr>
