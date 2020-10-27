## Process this file with automake to produce Makefile.in -*-Makefile-*-

## SPDX-FileCopyrightText: <text> © 2016, 2020 Alan D. Salewski <ads@salewski.email> </text>
## SPDX-License-Identifier: GPL-2.0-or-later

SUBDIRS = bin \
          src \
          .

# The ACLOCAL_AMFLAGS are used by 'autoreconf' and by the Makefile rebuild
# rule when they need to run 'aclocal'.
#
ACLOCAL_AMFLAGS = -I autotools


## Ensure that these files make it into the distribution tarball
##
EXTRA_DIST = BUGS HACKING \
    src/third-party/cargo-vendored

MAINTAINERCLEANFILES = config.status \
                       config.log    \
                       $(PACKAGE)-$(VERSION).tar.gz \
                       *~

# If we have specified '--with-perl-includes' to configure to allow us to
# find Perl modules installed on the local workstation in non-standard
# locations, then 'make distcheck' will need to use that same option in
# order to complete successfully.
if USING_PERL5_EXTRA_INCLUDES
_DC_WITH_PERL_INCLUDES = "--with-perl-includes=$(ads_perl5_extra_includes)"
else
_DC_WITH_PERL_INCLUDES =
endif

DISTCHECK_CONFIGURE_FLAGS = $(_DC_WITH_PERL_INCLUDES)


CARGO_MANIFEST_FILES = \
    src/main/rust/bin/parse-netrc/Cargo.toml


# Target to iterate over all of the Cargo.toml manifest files in the tree, and
# pre-populate/update our local cache of source code for our "vendored" deps
# ("crates", in Rust parlance):
#
#     $ cargo vendor --no-delete --versioned-dirs -v --manifest-path ./src/main/rust/bin/my-prog/Cargo.toml ./src/third-party/cargo-vendored
#
# This target is never run as part of the normal build on an end-user's
# system, but is provided for use of the author when adjusting the
# dependencies (e.g., adding a new dependency, or bumping up the version of an
# existing dep).
#
# See also: cargo-vendor(1)
#
.PHONY: cargo-vendor-update
cargo-vendor-update:
	for fpath in $(CARGO_MANIFEST_FILES); do    \
	    "${CARGO_PROG}" vendor --verbose        \
	                           --no-delete      \
	                           --versioned-dirs \
	                           --manifest-path "$${fpath}" \
	                           "$(cargo_vendored_root)" \
	    || exit 1 ;\
	done
