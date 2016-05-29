## Process this file with automake to produce Makefile.in -*-Makefile-*-

SUBDIRS = src \
          .

# The ACLOCAL_AMFLAGS are used by 'autoreconf' and by the Makefile rebuild
# rule when they need to run 'aclocal'.
#
ACLOCAL_AMFLAGS = -I autotools


## Ensure that these files make it into the distribution tarball
##
EXTRA_DIST = BUGS HACKING

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
