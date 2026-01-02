Name:           libnbcompat
Version:        2020.08.17
Release:        1%{?dist}
Summary:        Portable NetBSD compatibility library

License:        BSD
URL:            https://github.com/archiecobbs/libnbcompat
Source0:        https://github.com/archiecobbs/libnbcompat/archive/refs/tags/2020-08-17.tar.gz

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  autoconf
BuildRequires:  automake

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
%autosetup -n %{name}-2020-08-17

%build
%configure
%make_build

%install
%make_install

# Remove libtool archives
find %{buildroot} -name '*.la' -delete

%files
%license LICENSE
%doc README
%{_libdir}/libnbcompat.so.*

%files devel
%{_includedir}/nbcompat.h
%{_includedir}/nbcompat/
%{_libdir}/libnbcompat.so
%{_libdir}/libnbcompat.a

%changelog
* Wed Jan 02 2026 Package Maintainer <maintainer@example.com> - 2020.08.17-1
- Initial COPR package for libnbcompat
- Based on upstream release tag 2020-08-17
