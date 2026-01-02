# Makefile for packaging tasks
# Usage:
#   make srpm        # download upstream tag tarball and build SRPM
#   make copr        # submit upstream tag URL build to COPR (requires copr-cli)
#   make copr-srpm    # build SRPM locally then upload SRPM to COPR
#   make clean-sources # remove downloaded source tarball

RPMBUILD ?= $(HOME)/rpmbuild
SOURCES := $(RPMBUILD)/SOURCES
SRPMS := $(RPMBUILD)/SRPMS

# Try to detect buildtag from the spec, allow override: make srpm BUILD_TAG=1.0.2
BUILD_TAG ?= $(shell awk '/%global[[:space:]]+buildtag/ {print $$3; exit}' libnbcompat.spec)

# Upstream source URL (defaults to archiecobbs tag tarball)
SOURCE_URL ?= https://github.com/archiecobbs/libnbcompat/archive/refs/tags/$(BUILD_TAG).tar.gz
SOURCETARBALL := $(SOURCES)/libnbcompat-$(BUILD_TAG).tar.gz

.PHONY: all srpm rpm prepare-dirs download-sources clean-sources copr copr-srpm help
all: help

help:
	@echo "Makefile targets:"
	@echo "  srpm        - download tag $(BUILD_TAG) and build SRPM (rpmbuild -bs)"
	@echo "  rpm         - build binary RPMs (rpmbuild -ba) and collect main RPM + SRPM into releases/"
	@echo "  copr        - submit upstream tag URL build to COPR (requires copr-cli)"
	@echo "  copr-srpm   - build SRPM locally then upload the SRPM to COPR (requires copr-cli)"
	@echo "  clean-sources - remove downloaded source tarball"

prepare-dirs:
	@echo "Ensuring RPM build tree exists under $(RPMBUILD)"
	@mkdir -p "$(SOURCES)" "$(RPMBUILD)/{BUILD,RPMS,SRPMS,BUILDROOT}"

download-sources: prepare-dirs
	@echo "Downloading $(SOURCE_URL) -> $(SOURCETARBALL)"
	@curl -fsSL "$(SOURCE_URL)" -o "$(SOURCETARBALL)" || (echo "Failed to download $(SOURCE_URL)"; exit 1)
	@echo "Download complete"

srpm: download-sources
	@echo "Building SRPM from spec: libnbcompat.spec"
	@rpmbuild -bs libnbcompat.spec || (echo "rpmbuild failed"; exit 1)
	@echo "SRPM(s) created under $(SRPMS)"

copr:
	@command -v copr-cli >/dev/null 2>&1 || (echo "copr-cli not found; install with: sudo dnf install copr-cli"; exit 1)
	@echo "Submitting COPR build for tag $(BUILD_TAG)"
	@copr-cli build libnbcompat "$(SOURCE_URL)" --spec libnbcompat.spec

rpm: download-sources
	@echo "Building binary RPMs from spec: libnbcompat.spec"
	@rpmbuild -ba libnbcompat.spec || (echo "rpmbuild failed"; exit 1)
	@echo "Binary RPM(s) created under $(RPMBUILD)/RPMS"
	@mkdir -p releases
	@echo "Locating main binary RPM (excluding devel/debug packages)"
	@main=$$(find "$(RPMBUILD)/RPMS" -type f -name "libnbcompat-$(BUILD_TAG)-*.rpm" ! -name "*-devel-*.rpm" ! -name "*-debuginfo-*.rpm" ! -name "*-debugsource-*.rpm" | sort | tail -n1); \
	if [ -n "$$main" ]; then cp -v "$$main" releases/; else echo "Main RPM not found"; fi; \
	# copy SRPM too
	@srpm=$$(ls "$(SRPMS)"/libnbcompat-$(BUILD_TAG)-*.src.rpm 2>/dev/null | tail -n1); \
	if [ -n "$$srpm" ]; then cp -v "$$srpm" releases/; else echo "SRPM not found in $(SRPMS)"; fi; \
	echo "Releases copied to releases/"

copr-srpm: srpm
	@command -v copr-cli >/dev/null 2>&1 || (echo "copr-cli not found; install with: sudo dnf install copr-cli"; exit 1)
	@echo "Locating SRPM in $(SRPMS)"
	@srpm=$$(ls "$(SRPMS)"/libnbcompat-$(BUILD_TAG)-*.src.rpm 2>/dev/null | tail -n1); \
	if [ -z "$$srpm" ]; then echo "SRPM not found in $(SRPMS)"; exit 1; fi; \
	echo "Uploading $$srpm to COPR"; \
	copr-cli build libnbcompat "$$srpm"

clean-sources:
	@echo "Removing $(SOURCETARBALL)"
	@rm -f "$(SOURCETARBALL)"
	@echo "Done"
