Name:           libnbcompat
%global         buildtag 1.0.2
Version:        %{buildtag}
Release:        1%{?dist}
Summary:        Portable NetBSD compatibility library

License:        BSD
URL:            https://github.com/archiecobbs/libnbcompat
Source0:        https://github.com/archiecobbs/libnbcompat/archive/refs/tags/1.0.2.tar.gz

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  autoconf
BuildRequires:  automake
BuildRequires:  libtool

%description
libnbcompat is a portable NetBSD compatibility library that provides
NetBSD-specific functions and utilities for use on other operating
systems. It includes implementations of various BSD library functions
that may not be available on all platforms.

%package        devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description    devel
The %{name}-devel package contains libraries and header files for
developing applications that use %{name}.

%prep
%autosetup -n %{name}-%{buildtag}
bash ./autogen.sh

%build
%configure
%make_build

%install
%make_install

# Remove libtool archives
find %{buildroot} -name '*.la' -delete

%files
%doc README
%{_libdir}/libnbcompat.so.*

%files devel
%{_includedir}/nbcompat.h
%{_includedir}/nbcompat/
%{_libdir}/libnbcompat.so
%{_libdir}/libnbcompat.a

%changelog
* Fri Jan 02 2026 Package Maintainer <maintainer@example.com> - 1.0.2-1
- Initial COPR package for libnbcompat
- Based on upstream release tag 1.0.2
