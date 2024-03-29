dnl Process this file with autoconf to produce a configure script. -*-Autoconf-*-

dnl SPDX-FileCopyrightText: <text>
dnl     © 2016, 2017, 2020, 2021, 2022 Alan D. Salewski <ads@salewski.email>
dnl </text>
dnl SPDX-License-Identifier: GPL-2.0-or-later

dnl +-------------------------+
dnl |  Autotools Boilerplate  |
dnl +-------------------------+

dnl Ensure that a recent-enough version of Autoconf is being used
AC_PREREQ([2.69])

dnl Defines the following m4 macros, output variables, and preprocessor
dnl symbols. Only the m4 macros have the 'AC_' prefix:
dnl
dnl     [AC_] PACKAGE_NAME
dnl     [AC_]PACKAGE_TARNAME
dnl     [AC_]PACKAGE_VERSION
dnl     [AC_]PACKAGE_STRING     ("<PACKAGE> <VERSION>")
dnl     [AC_]PACKAGE_BUGREPORT
dnl     [AC_]PACKAGE_URL
dnl
AC_INIT([[ADS GitHub Tools]],
        [[0.3.6-snapshot]],
        [[Alan D. Salewski <ads@salewski.email>]],
        [[ads-github-tools]],
        [[https://github.com/salewski/ads-github-tools]])

AC_CONFIG_AUX_DIR([build-aux])

dnl Indicate dir where our custom m4 macros may be found (future
dnl proofing; as of may not be used yet...)
AC_CONFIG_MACRO_DIR([autotools])

dnl Turn on all Automake warnings and report them as errors
dnl
dnl Enable subdir-objects. This is just future-proofing, as it will be the
dnl default behavior in future versions of Automake.
dnl
dnl Use the ustar format defined by POSIX 1003.1-1988 to allow filepaths
dnl longer than 99 chars (up to 256 chars). This is needed because of the deep
dnl directories created by our vendored deps (under src/third-party/...)
dnl
AM_INIT_AUTOMAKE([-Wall -Werror foreign subdir-objects tar-ustar])


dnl AC_SUBST([DFLT_MAINTAINER_NAME])
dnl AC_SUBST([DFLT_MAINTAINER_EMAIL])
dnl AC_SUBST([DFLT_MAINTAINER_FULL])


dnl We have the Automake "Silent Rules" feature enabled by default, which
dnl allows us to control the verbosity of output messages at build time.
dnl
dnl Users can override this at configure time by specifying '--disable-silent-rules'.
dnl
dnl Users can control the verbosity at build time by specifying either:
dnl     make V=1 ...
dnl or
dnl     make V=0 ...
dnl
dnl Rationale: For historical reasons, the Automake default is to have this
dnl feature disabled, which results in detailed output being emitted at build
dnl time (every command invoked, plus its output). That behavior is
dnl theoretically useful for debugging failures, but for this project actually
dnl makes the build less easy to follow because of the sheer volume of it.
dnl
AM_SILENT_RULES([yes])

dnl Use the 'config.guess' script to compute the canonical host-system type
dnl variable, 'host', and its three individual parts 'host_cpu',
dnl 'host_vendor', and 'host_os'.
dnl
dnl See section "Specifying target triplets" in the Autoconf manual.
dnl
dnl Note: The 'ads-github-tools' build will filter the value found for
dnl       'host_os' into the 'ads-github-nproc' program, where it may be used
dnl       at runtime by that program.
AC_CANONICAL_HOST


dnl +------------------------+
dnl |  Checks for programs.  |
dnl +------------------------+

dnl Check whether '$GREP -E' works, or else look for the best available
dnl 'egrep' or 'gegrep' that accepts the longest input lines possible.  Set
dnl the output variable 'EGREP' to whatever is chosen. The result can be
dnl overridden by setting the 'EGREP' variable and is cached in the
dnl 'ac_cv_path_EGREP' variable.
AC_PROG_EGREP

dnl makes $(LN_S) available in our Makefile.am files
AC_PROG_LN_S

dnl modtern Autoconf-based $(MKDIR_P)
AC_PROG_MKDIR_P

AC_PATH_PROG(AWK_PROG, awk)
if test -z "$AWK_PROG"; then
    AC_MSG_ERROR([awk not found])
fi

AC_PATH_PROG(BASENAME_PROG, basename)
if test -z "$BASENAME_PROG"; then
    AC_MSG_ERROR([basename not found])
fi

## We need bash >= 4.x (associative arrays were added in bash-4.0)
## See also: GitHub issue #6:
##     https://github.com/salewski/ads-github-tools/issues/6
##
AC_PATH_PROG(BASH_SH, bash)
AS_IF([test -z "$BASH_SH"], [AC_MSG_ERROR([bash not found])],
      [["${BASH_SH}" -c 'test -n "${BASH_VERSINFO@<:@0@:>@:+set}" && test ${BASH_VERSINFO@<:@0@:>@]} -ge 4 && exit 0'], [:],
      [AC_MSG_ERROR([found version of bash is not new enough; bash 4.0 or newer is required])
])

# Arbitrary-precision arithmetic language
# See:
#     bc(1)
#     bc(1posix)
AC_PATH_PROG(BC_PROG, bc)
if test -z "$BC_PROG"; then
    AC_MSG_ERROR([bc not found])
fi


# Cargo is the package management and build orchestration tool for the Rust
# programming language. If you've got 'rustc', then you probably have this
# already. On Debian systems (and its derivatives), it is provided by the
# 'cargo' package.
#
#     https://github.com/rust-lang/cargo/
#     https://doc.rust-lang.org/cargo/
#
# Our minimum required version is 1.43.0 (released 2020-04-23).
#
# Recent features on which we depend, and the Rust/Cargo 'stable' release in
# which they first appeared (newest first):
#
#     * 'config-profile'. First appeared in 1.43.0 (2020-04-23). Allows
#       overriding profile keys for certain dependencies, as well as providing
#       a way to set profiles in .cargo/config
#
#     * '--versioned-dirs' option. First appeared in 1.42.0 (released
#       2020-03-12). When combined with our other project configuration, this
#       option causes the build to use our "vendored" sources under:
#
#           src/third-party/cargo-vendored/
#
# This macro provides these shell variables (along with their AC_SUBST'd
# counterparts):
#
#     $CARGO_PROG
#     $CARGO_PROG_VERSION
#
# Require cargo version 1.43.0 or newer.
# 
ads_PROG_CARGO([1.43.0])


AC_PATH_PROG([CAT], [cat])
if test -z "$CAT"; then
    AC_MSG_ERROR([cat not found])
fi

AC_PATH_PROG([CHGRP], [chgrp])
if test -z "$CHGRP"; then
    AC_MSG_ERROR([chgrp not found])
fi

AC_PATH_PROG([CHMOD_PROG], [chmod])
if test -z "$CHMOD_PROG"; then
    AC_MSG_ERROR([chmod not found])
fi

AC_PATH_PROG([CHOWN], [chown])
if test -z "$CHOWN"; then
    AC_MSG_ERROR([chown not found])
fi

AC_PATH_PROG(CP_PROG, cp)
if test -z "$CP_PROG"; then
    AC_MSG_ERROR([cp not found])
fi

# See: https://en.wikipedia.org/wiki/CURL
#      https://curl.haxx.se/
#      https://github.com/curl/curl
#
AC_PATH_PROG([CURL_PROG], [curl])
if test -z "$CURL_PROG"; then
    AC_MSG_ERROR([curl not found])
fi

AC_PATH_PROG([DATE_PROG], [date])
if test -z "$DATE_PROG"; then
    AC_MSG_ERROR([date not found])
fi

AC_PATH_PROG(DIRNAME_PROG, dirname)
if test -z "$DIRNAME_PROG"; then
    AC_MSG_ERROR([dirname not found])
fi

AC_PATH_PROG([ECHO_PROG], [echo])
if test -z "$ECHO_PROG"; then
    AC_MSG_ERROR([echo not found])
fi

AC_PATH_PROG([EXPR_PROG], [expr])
if test -z "EXPR_PROG"; then
    AC_MSG_ERROR([expr not found])
fi

AC_PATH_PROG([FIND], [find])
if test -z "$FIND"; then
    AC_MSG_ERROR([find not found]);dnl Ha!
fi

# OPTIONAL tool: getconf
HAVE_GETCONF_PROG=false
AC_PATH_PROG([GETCONF_PROG], [getconf])
if test -n "$GETCONF_PROG"; then
    HAVE_GETCONF_PROG=true
fi
AC_SUBST([HAVE_GETCONF_PROG])


# git version control system
#
# See: https://git-scm.com/
#      https://en.wikipedia.org/wiki/Git_(software)
#      https://www.kernel.org/pub/software/scm/git/
#
AC_PATH_PROG([GIT_PROG], [git])
if test -z "$GIT_PROG"; then
    AC_MSG_ERROR([git not found])
fi

# git-hub - command line GitHub API tool; works as 'git' subcommand if found
#           on PATH
#           see: https://github.com/sociomantic-tsunami/git-hub
#                https://www.kernel.org/pub/software/scm/git/docs/howto/new-command.html
#
AC_PATH_PROG([GIT_HUB_PROG], [git-hub])
if test -z "$GIT_HUB_PROG"; then
    AC_MSG_ERROR([git-hub not found])
fi

AC_PATH_PROG([GREP], [grep])
if test -z "$GREP"; then
    AC_MSG_ERROR([grep not found])
fi

AC_PATH_PROG([HEAD_PROG], [head])
if test -z "$HEAD_PROG"; then
    AC_MSG_ERROR([head not found])
fi

AC_PATH_PROG([ID_PROG], [id])
if test -z "$ID_PROG"; then
    AC_MSG_ERROR([id program not found])
fi

# jq - command line JSON parser and manipulation language
#      see: https://github.com/stedolan/jq
#
AC_PATH_PROG([JQ_PROG], [jq])
if test -z "$JQ_PROG"; then
    AC_MSG_ERROR([jq program not found])
fi

# OPTIONAL tool: lscpu
# Note that 'lscpu' program comes from the 'util-linux' package.
#
# https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/
# https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git
# https://github.com/util-linux/util-linux
#
HAVE_LSCPU_PROG=false
AC_PATH_PROG([LSCPU_PROG], [lscpu])
if test -n "LSCPU_PROG"; then
    HAVE_LSCPU_PROG=true
fi
AC_SUBST([HAVE_LSCPU_PROG])

AC_PATH_PROG([MKDIR_PROG], [mkdir])
if test -z "$MKDIR_PROG"; then
    AC_MSG_ERROR([mkdir program not found])
fi

AC_PATH_PROG([MKTEMP_PROG], [mktemp])
if test -z "$MKTEMP_PROG"; then
    AC_MSG_ERROR([mktemp program not found])
fi

AC_PATH_PROG([MV_PROG], [mv])
if test -z "$MV_PROG"; then
    AC_MSG_ERROR([mv program not found])
fi

# OPTIONAL tool: nproc
# NOTE that nproc(1) is part of the GNU 'coreutils' package.
# https://www.gnu.org/software/coreutils/nproc
HAVE_NPROC_PROG=false
AC_PATH_PROG([NPROC_PROG], [nproc])
if test -n "$NPROC_PROG"; then
    HAVE_NPROC_PROG=true
fi
AC_SUBST([HAVE_NPROC_PROG])

AC_PATH_PROG([SED], [sed])
if test -z "$SED"; then
    AC_MSG_ERROR([sed not found])
fi

# readlink(1) from the GNU coreutils
AC_PATH_PROG([READLINK_PROG], [readlink])
if test -z "$READLINK_PROG"; then
    AC_MSG_ERROR([readlink not found])
fi

AC_PATH_PROG([RM], [rm])
if test -z "$RM"; then
    AC_MSG_ERROR([rm not found])
fi

AC_PATH_PROG([RMDIR], [rmdir])
if test -z "$RMDIR"; then
    AC_MSG_ERROR([rmdir not found])
fi

# 'rustc' is the compiler for the Rust programming language. If you have
# 'cargo' (checked-for above), then you probably have 'rustc', too. On Debian
# systems (and its derivatives), it is provided by the 'rust' package.
#
#     https://www.rust-lang.org/
#     https://www.rust-lang.org/tools/install
#     https://doc.rust-lang.org/rustc/index.html
#     https://github.com/rust-lang/rust
#
AC_PATH_PROG([RUSTC_PROG], [rustc])
if test -z "$RUSTC_PROG"; then
    AC_MSG_ERROR([rustc not found])
fi

# sha256sum(1), from GNU 'coreutils'
AC_PATH_PROG([SHA256SUM_PROG], [sha256sum])
if test -z "$SHA256SUM_PROG"; then
    AC_MSG_ERROR([sha256sum not found])
fi

# See: https://metacpan.org/release/Digest-SHA3
#      https://packages.debian.org/jessie/libdigest-sha3-perl
#      https://packages.debian.org/stretch/libdigest-sha3-perl
#
AC_PATH_PROG([SHA3SUM_PROG], [sha3sum])
if test -z "$SHA3SUM_PROG"; then
    AC_MSG_ERROR([sha3sum not found])
fi

# We need a sleep(1) command that accepts non-integer times (to allow sleeping
# for durations less than one second). BSD and GNU/Linux implementations
# support this, so portability is not much of a concern here. Please open a
# bug report if your system is different.
#
dnl FIXME: Implement test that finds a sleep command known to accept
dnl        non-integer values. Here we are currently just assuming it for
dnl        whichever sleep command was found first on PATH.
AC_PATH_PROG([SLEEP_PROG], [sleep])
if test -z "$SLEEP_PROG"; then
    AC_MSG_ERROR([sleep not found])  # I know the feeling!
fi

# OPTIONAL tool: sysctl
HAVE_SYSCTL_PROG=false
AC_PATH_PROG([SYSCTL_PROG], [sysctl])
if test -n "$SYSCTL_PROG"; then
    HAVE_SYSCTL_PROG=true
fi
AC_SUBST([HAVE_SYSCTL_PROG])

AC_PATH_PROG([TAIL_PROG], [tail])
if test -z "$TAIL_PROG"; then
    AC_MSG_ERROR([tail not found])
fi

AC_PATH_PROG([TR_PROG], [tr])
if test -z "$TR_PROG"; then
    AC_MSG_ERROR([tr not found])
fi

AC_PATH_PROG([WC_PROG], [wc])
if test -z "$WC_PROG"; then
    AC_MSG_ERROR([wc not found])
fi

AC_PATH_PROG([XARGS_PROG], [xargs])
if test -z "$XARGS_PROG"; then
    AC_MSG_ERROR([xargs not found])
fi

dnl XXX: Consider making zstd optional
dnl

# The zstd(1) compression tool
#
#     https://github.com/facebook/zstd
#
AC_PATH_PROG([ZSTD_PROG], [zstd])
if test -z "$ZSTD_PROG"; then
    AC_MSG_ERROR([zstd not found])
fi


dnl require /at least/ perl version 5.005
ads_PROG_PERL([5.005])

# pod2man comes with perl, which the above verifies that we have. Not yet sure
# if we can rely on that (distribution packaging may provide it in an optional
# package, for instance), so we check for it explicitly here. We use pod2man
# at build time to create some of our man pages.
AC_PATH_PROG([POD2MAN], [pod2man])
if test -z "$POD2MAN"; then
    AC_MSG_ERROR([pod2man program not found])
fi


dnl +------------------------+
dnl |  Checks for Libraries  |
dnl +------------------------+
dnl Perl Libs (3rd party)
dnl ---------------------
dnl
dnl Note that some of the modules checked for here are part of the core
dnl library for modern versions of Perl. We simply check for all used
dnl modules rather than try to track which version of perl includes which
dnl modules.
dnl
ads_PERL_MODULE([Carp])
dnl ads_PERL_MODULE([File::Basename])
dnl ads_PERL_MODULE([File::Spec])
ads_PERL_MODULE([Getopt::Long])
ads_PERL_MODULE([URL::Normalize], [REQUIRED], [0.33])


dnl +----------------------+
dnl |  Checks for Headers  |
dnl +----------------------+
dnl None!

dnl +------------------------------------------------------------------+
dnl |  Checks for typedefs, structures, and compiler characteristics.  |
dnl +------------------------------------------------------------------+
dnl None!

dnl +---------------------------------+
dnl |  Checks for library functions.  |
dnl +---------------------------------+
dnl None!

dnl +---------------------+
dnl |  Autotools Output.  |
dnl +---------------------+
dnl ads_PERL_LIBDIR

# FIXME: These are not general, so won't be correct in all
#        circumstances. They'll work correctly once we have full Perl
#        support.
AC_SUBST([perl5_pkgvdatadir], ["\${datadir}/${PACKAGE}-${VERSION}/perl5"])
AC_SUBST([perl5_pkgvlibdir],  ["\${libdir}/${PACKAGE}-${VERSION}/perl5"])

# The Cargo build orchestration tool for Rust can "vendor" our third-party
# rust library dependencies ("crates") by obtaining them from crates.io (or
# whever else we configure it to look) and storing local copies in an
# arbitrary subdirectory within our build tree.
#
# We take advantage of that capability so that end-users will have within our
# release tarballs everything they need to compile our Rust-based artifacts
# (assuming they have the rustc compiler and cargo itself already
# installed).
#
# This approach allows us to have reproducible builds and protects us against
# artifacts disappearing from the Internet. It also allows us to provide users
# with a build system that does not require access to network resources or
# otherwise have familiarity and/or comfort with the tooling of the Rust
# ecosystem.
#
cargo_vendored_root='$(top_srcdir)/src/third-party/cargo-vendored'
AC_SUBST([cargo_vendored_root])


## The 'do_subst' Makefile var is the conventional name for manual
## filtering process that needs to be done at build time.
##
## Basically, any file we generate that is not a Makefile should be
## filtered at build time rather than at configure time; at build
## time, autotools variables will be fully expanded (well, expanded
## recursively, which amounts to the same thing) and allows any of the
## make vars to be overridden on the 'make' command line. This also
## avoids other kludgey hacks, such as eval'ing shell variables to
## expand them at configure time).
##
## Note that we replace all of the autoconf installation directory
## vars (see "Installation Directory Variables" in the autoconf
## manual) and most of the autoconf preset output variables (see
## "Preset Output Variables" in the autoconf manual). The exceptions
## to that latter are flag vars to the C/C++/Fortran compilers,
## linkers, etc. (CFLAGS and friends), and the 'configure_input' var,
## which we have to provide our own variation of. We also omit
## 'builddir' (which is always '.'); in this last case, what you
## probably want instead is 'abs_builddir', which we provide.
[
do_subst_command='do_subst = sed \
  -e '"'"'s,[@]PACKAGE[@],$(PACKAGE),g'"'"' \
  -e '"'"'s,[@]PACKAGE_NAME[@],$(PACKAGE_NAME),g'"'"' \
  -e '"'"'s,[@]PACKAGE_TARNAME[@],$(PACKAGE_TARNAME),g'"'"' \
  -e '"'"'s,[@]PACKAGE_VERSION[@],$(PACKAGE_VERSION),g'"'"' \
  -e '"'"'s,[@]PACKAGE_STRING[@],$(PACKAGE_STRING),g'"'"' \
  -e '"'"'s,[@]PACKAGE_BUGREPORT[@],$(PACKAGE_BUGREPORT),g'"'"' \
  -e '"'"'s,[@]PACKAGE_URL[@],$(PACKAGE_URL),g'"'"' \
  \
  -e '"'"'s,[@]VERSION[@],$(VERSION),g'"'"' \
  -e '"'"'s,[@]PATH_SEPARATOR[@],$(PATH_SEPARATOR),g'"'"' \
  -e '"'"'s,[@]configure_input[@],Generated from $@.in; do not edit by hand.,g'"'"' \
  -e "s,[@]BUILD_DATE[@],$$(date '"'"'+%Y-%m-%d %H:%M:%S'"'"'),g" \
  \
  -e '"'"'s,[@]host_cpu[@],$(host_cpu),g'"'"' \
  -e '"'"'s,[@]host_vendor[@],$(host_vendor),g'"'"' \
  -e '"'"'s,[@]host_os[@],$(host_os),g'"'"' \
  \
  -e '"'"'s,[@]bindir[@],$(bindir),g'"'"' \
  -e '"'"'s,[@]datadir[@],$(datadir),g'"'"' \
  -e '"'"'s,[@]exec_prefix[@],$(exec_prefix),g'"'"' \
  -e '"'"'s,[@]includedir[@],$(includedir),g'"'"' \
  -e '"'"'s,[@]infodir[@],$(infodir),g'"'"' \
  -e '"'"'s,[@]libdir[@],$(libdir),g'"'"' \
  -e '"'"'s,[@]libexecdir[@],$(libexecdir),g'"'"' \
  -e '"'"'s,[@]localstatedir[@],$(localstatedir),g'"'"' \
  -e '"'"'s,[@]mandir[@],$(mandir),g'"'"' \
  -e '"'"'s,[@]oldincludedir[@],$(oldincludedir),g'"'"' \
  -e '"'"'s,[@]prefix[@],$(prefix),g'"'"' \
  -e '"'"'s,[@]sbindir[@],$(sbindir),g'"'"' \
  -e '"'"'s,[@]sharedstatedir[@],$(sharedstatedir),g'"'"' \
  -e '"'"'s,[@]sysconfdir[@],$(sysconfdir),g'"'"' \
  \
  -e '"'"'s,[@]abs_builddir[@],$(abs_builddir),g'"'"' \
  -e '"'"'s,[@]abs_srcdir[@],$(abs_srcdir),g'"'"' \
  -e '"'"'s,[@]abs_top_builddir[@],$(abs_top_builddir),g'"'"' \
  -e '"'"'s,[@]srcdir[@],$(srcdir),g'"'"' \
  -e '"'"'s,[@]top_builddir[@],$(top_builddir),g'"'"' \
  -e '"'"'s,[@]top_srcdir[@],$(top_srcdir),g'"'"' \
  \
  -e '"'"'s,[@]EGREP[@],$(EGREP),g'"'"' \
  \
  -e '"'"'s,[@]PERL[@],$(PERL),g'"'"' \
  -e '"'"'s,[@]POD2MAN[@],$(POD2MAN),g'"'"' \
  -e '"'"'s,[@]ads_perl5_extra_includes[@],$(ads_perl5_extra_includes),g'"'"' \
  -e '"'"'s,[@]perl5_pkgvdatadir[@],$(perl5_pkgvdatadir),g'"'"' \
  \
  -e '"'"'s,[@]cargo_vendored_root[@],$(cargo_vendored_root),g'"'"' \
  \
  -e '"'"'s,[@]AWK_PROG[@],$(AWK_PROG),g'"'"' \
  -e '"'"'s,[@]BASENAME_PROG[@],$(BASENAME_PROG),g'"'"' \
  -e '"'"'s,[@]BASH_SH[@],$(BASH_SH),g'"'"' \
  -e '"'"'s,[@]BC_PROG[@],$(BC_PROG),g'"'"' \
  -e '"'"'s,[@]CARGO_PROG[@],$(CARGO_PROG),g'"'"' \
  -e '"'"'s,[@]CARGO_PROG_VERSION[@],$(CARGO_PROG_VERSION),g'"'"' \
  -e '"'"'s,[@]CAT[@],$(CAT),g'"'"' \
  -e '"'"'s,[@]CHGRP[@],$(CHGRP),g'"'"' \
  -e '"'"'s,[@]CHMOD_PROG[@],$(CHMOD_PROG),g'"'"' \
  -e '"'"'s,[@]CHOWN[@],$(CHOWN),g'"'"' \
  -e '"'"'s,[@]CP_PROG[@],$(CP_PROG),g'"'"' \
  -e '"'"'s,[@]DIRNAME_PROG[@],$(DIRNAME_PROG),g'"'"' \
  -e '"'"'s,[@]CURL_PROG[@],$(CURL_PROG),g'"'"' \
  -e '"'"'s,[@]DATE_PROG[@],$(DATE_PROG),g'"'"' \
  -e '"'"'s,[@]ECHO_PROG[@],$(ECHO_PROG),g'"'"' \
  -e '"'"'s,[@]EXPR_PROG[@],$(EXPR_PROG),g'"'"' \
  -e '"'"'s,[@]FIND[@],$(FIND),g'"'"' \
  \
  -e '"'"'s,[@]HAVE_GETCONF_PROG[@],$(HAVE_GETCONF_PROG),g'"'"' \
  -e '"'"'s,[@]GETCONF_PROG[@],$(GETCONF_PROG),g'"'"' \
  \
  -e '"'"'s,[@]GIT_PROG[@],$(GIT_PROG),g'"'"' \
  -e '"'"'s,[@]GIT_HUB_PROG[@],$(GIT_HUB_PROG),g'"'"' \
  -e '"'"'s,[@]GREP[@],$(GREP),g'"'"' \
  -e '"'"'s,[@]HEAD_PROG[@],$(HEAD_PROG),g'"'"' \
  -e '"'"'s,[@]ID_PROG[@],$(ID_PROG),g'"'"' \
  -e '"'"'s,[@]JQ_PROG[@],$(JQ_PROG),g'"'"' \
  \
  -e '"'"'s,[@]HAVE_LSCPU_PROG[@],$(HAVE_LSCPU_PROG),g'"'"' \
  -e '"'"'s,[@]LSCPU_PROG[@],$(LSCPU_PROG),g'"'"' \
  \
  -e '"'"'s,[@]MKDIR_PROG[@],$(MKDIR_PROG),g'"'"' \
  -e '"'"'s,[@]MKTEMP_PROG[@],$(MKTEMP_PROG),g'"'"' \
  -e '"'"'s,[@]MV_PROG[@],$(MV_PROG),g'"'"' \
  \
  -e '"'"'s,[@]HAVE_NPROC_PROG[@],$(HAVE_NPROC_PROG),g'"'"' \
  -e '"'"'s,[@]NPROC_PROG[@],$(NPROC_PROG),g'"'"' \
  \
  -e '"'"'s,[@]SED[@],$(SED),g'"'"' \
  -e '"'"'s,[@]READLINK_PROG[@],$(READLINK_PROG),g'"'"' \
  -e '"'"'s,[@]RM[@],$(RM),g'"'"' \
  -e '"'"'s,[@]RMDIR[@],$(RMDIR),g'"'"' \
  -e '"'"'s,[@]RUSTC_PROG[@],$(RUSTC_PROG),g'"'"' \
  -e '"'"'s,[@]SHA256SUM_PROG[@],$(SHA256SUM_PROG),g'"'"' \
  -e '"'"'s,[@]SHA3SUM_PROG[@],$(SHA3SUM_PROG),g'"'"' \
  -e '"'"'s,[@]SLEEP_PROG[@],$(SLEEP_PROG),g'"'"' \
  \
  -e '"'"'s,[@]HAVE_SYSCTL_PROG[@],$(HAVE_SYSCTL_PROG),g'"'"' \
  -e '"'"'s,[@]SYSCTL_PROG[@],$(SYSCTL_PROG),g'"'"' \
  \
  -e '"'"'s,[@]TAIL_PROG[@],$(TAIL_PROG),g'"'"' \
  -e '"'"'s,[@]TR_PROG[@],$(TR_PROG),g'"'"' \
  -e '"'"'s,[@]WC_PROG[@],$(WC_PROG),g'"'"' \
  -e '"'"'s,[@]XARGS_PROG[@],$(XARGS_PROG),g'"'"' \
  -e '"'"'s,[@]ZSTD_PROG[@],$(ZSTD_PROG),g'"'"' \
'
]
AC_SUBST([do_subst_command])

# It's common for makefile scripts to need to "sed sanitize" the value of a
# variable in order to use it on the left side of a sed 's' (substitution)
# command. To obtain a "sed sanitized" copy of any variable, echo its value to:
#     $(sed_slsanitize)
#
# Example:
#     vers_sedslsanitized=$$(printf "%s\n" "-$(VERSION)" | $(sed_slsanitize)) ;\
#     nonvers=$$(echo progwithvers | sed -e "s/$${vers_sedslsanitized}$$//")
[
sed_slsanitize_command='sed_slsanitize = sed \
  -e '"'"'s!\([]^\*\$\/&[]\)!\\\1!g'"'"' \
  -e '"'"'s![-]![-]!g'"'"' \
'
]
AC_SUBST([sed_slsanitize_command])

# Similar to 'sed_slsanitize' above, but for the replacement text on the right
# side of a sed 's' (substitution) command. On the right side of a sed 's'
# substitution we only need to escape backslashes and amperdoodle chars.
[
sed_srsanitize_command='sed_srsanitize = sed \
  -e '"'"'s!\([\/&]\)!\\\1!g'"'"' \
'
]
AC_SUBST([sed_srsanitize_command])

adsgithubtools_perl5_inc_begin_block_snippet_filepath="\$(top_builddir)/src/main/resources/adsgithubtools-perl5-inc-begin-block.snippet"
AC_SUBST([adsgithubtools_perl5_inc_begin_block_snippet_filepath])


# Have Automake generate these recursive targets for us automatically. We can
# then invoke these from anywhere in the source tree and have the right thing
# happen beneath that location.
#
# In order to hang behavior off of these in any given subdir, a corresponding
# *-local target can be provided. Otherwise the default *-local target will be
# used for that subdir (which is effectively a NOOP).
#
AM_EXTRA_RECURSIVE_TARGETS(
    [cargo-build]     dnl build with 'release' profile
    [cargo-devbuild]  dnl build with 'dev' profile

    [cargo-check]     dnl think 'cargo check', not 'make check'

    dnl This one is like 'make check', but only affects Cargo-based bits.
    dnl
    dnl It is also implied by 'make check', so this target is probably only
    dnl useful when you want to do test runs of only the Cargo-based bits.
    [cargo-test]

    dnl This one allows 'cargo test --doc' to be run for the Cargo-based
    dnl projects to test /only/ the examples in their documentation (which are
    dnl compiled and run by 'rustdoc').
    [cargo-test-doc]

    dnl This one is like 'make clean', but only affects Cargo-based bits.
    [cargo-clean]
)


dnl AC_CONFIG_FILES requires a list of file paths, but we do not want
dnl to have to maintain the list by hand.
dnl
dnl To obtain a list of of paths to all Makefiles we want to have
dnl generated, based on the existence of Makefile.am files, run the
dnl following shell snippet (for use as the argument to
dnl AC_CONFIG_FILES).
dnl
dnl Note that we take care to m4-quote the output strings. Filenames
dnl with square brackets in them will break this, so don't do that.
dnl
dnl   find . -type f -name 'Makefile.am' -printf "%P\n"| sed -e 's/\.am$//g;s/^/[/g;s/$/]/g' | sort
dnl
dnl Cookbook for emacs users:
dnl   1. Delete all [**/Makefile] entries from args to AC_CONFIG_FILES
dnl
dnl   2. Copy the above 'find' command line (M-w)
dnl
dnl   3. Place point (cursor) on a line by itself after
dnl      AC_CONFIG_FILES's opening paren and set mark (C-SPACE)
dnl
dnl   4. Run the 'find' command, inserting the output at point:
dnl          C-u M-! C-y RET
dnl
dnl   5. Use `indent-region' (C-M-\) to indent the quoted
dnl      strings. Region is already set up because we set the mark above.

# We generate some of our Rust (.rs) source code files, so they end up in the
# build tree when doing a VPATH build. Because Cargo expects to find all of
# the files involved with building a Rust "package" (source code files for the
# crates, the Cargo.lock file, etc) together in the same directory tree, we
# need to arrange for the files that aren't generated to appear to be local to
# the build tree. Enter AC_CONFIG_LINKS.
#
# Note that the source files named here (all static files) will be included in
# the source tarball distribution.
#
AC_CONFIG_LINKS(
    [src/main/rust/bin/parse-netrc/Cargo.lock:src/main/rust/bin/parse-netrc/Cargo.lock]
    [src/main/rust/bin/parse-netrc/Cargo.toml:src/main/rust/bin/parse-netrc/Cargo.toml]

    [src/main/rust/bin/parse-netrc/src/lib.rs:src/main/rust/bin/parse-netrc/src/lib.rs]
    [src/main/rust/bin/parse-netrc/src/bin/main.rs:src/main/rust/bin/parse-netrc/src/bin/main.rs]
)

dnl Declare our output Makefiles (and others)
AC_CONFIG_FILES(
    [.cargo/config.toml]
    [src/main/rust/bin/parse-netrc/.cargo/config.toml]

    [Makefile]
    [bin/Makefile]
    [src/Makefile]
    [src/main/Makefile]
    [src/main/bash/Makefile]
    [src/main/bash/bin/Makefile]
    [src/main/perl/Makefile]
    [src/main/perl/bin/Makefile]
    [src/main/resources/Makefile]
    [src/main/rust/Makefile]
    [src/main/rust/bin/Makefile]
    [src/main/rust/bin/parse-netrc/Makefile]
)

dnl Actually output the declared files
AC_OUTPUT


# I know that shell functions are not considered portable to old ancient
# *nices, but users of such systems are unlikely users of the ads-github-tools
# (please let me know if this assumption is incorrect!). In most cases, it may
# be that we may need to beef something up to /find/ it, but there should
# definately be a shell installed that understands functions...
#
# Prints on stdout the fully expanded path represented by the value in
# the SHELL_VAR_NAME param. Does /not/ assign the expanded value to
# the named shell var.
#
# __poor_mans_expand_file_name( SHELL_VAR_NAME )
#
# @param SHELL_VAR_NAME should be set to the /name/ of an existing
#                       shell variable whose value contains a
#                       directory path that may or may not need
#                       expansion of the configure shell variables
#                       ($prefix, and the like).
#
__poor_mans_expand_file_name () {
    _tmp_name=$1
    _tmp_last="`eval echo '${'"${_tmp_name}"'}'`"
    if test -z "${_tmp_last}"; then
        printf "__poor_mans_expand_file_name() (WARNING): var \"%s\" is empty\n" \
          "${_tmp_name}" 1>&2
        return 0;  # nothing to do
    fi
    _tmp_last_expanded="`eval echo ${_tmp_last}`"
    while test "${_tmp_last_expanded}" != "${_tmp_last}"; do

        # Set 'last' hold var to most recently expanded version...
        _tmp_last="${_tmp_last_expanded}"

        # ...and try to expand further.
        _tmp_last_expanded="`eval echo ${_tmp_last_expanded}`"
    done
    printf "%s\n" "${_tmp_last_expanded}"
    unset _tmp_last_expanded
    unset _tmp_last
    unset _tmp_name
    return 0;
}

dnl show user a summary of the configured options
printf "\n"
printf "${PACKAGE} has been configured with the following options:\n"
printf "                      host_cpu: %s\n" "`__poor_mans_expand_file_name host_cpu`"
printf "                   host_vendor: %s\n" "`__poor_mans_expand_file_name host_vendor`"
printf "                       host_os: %s\n" "`__poor_mans_expand_file_name host_os`"
printf "\n"
printf "                        Prefix: %s\n" "`__poor_mans_expand_file_name prefix`"
printf "                 User binaries: %s\n" "`__poor_mans_expand_file_name bindir`"
printf "               System binaries: %s\n" "`__poor_mans_expand_file_name sbindir`"
printf "           Configuration files: %s\n" "`__poor_mans_expand_file_name sysconfdir`"
printf "                  Manual pages: %s\n" "`__poor_mans_expand_file_name mandir`"
printf "\n"
printf "                          bash: %s\n" "`__poor_mans_expand_file_name BASH_SH`"
printf "                          perl: %s\n" "`__poor_mans_expand_file_name PERL`"
printf "                         rustc: %s\n" "`__poor_mans_expand_file_name RUSTC_PROG`"
printf "                         cargo: %s (%s)\n" \
  "`__poor_mans_expand_file_name CARGO_PROG`"      \
  "`__poor_mans_expand_file_name CARGO_PROG_VERSION`"
printf "\n"


## DEBUG: Show all variables set in the shell at the end of 'configure' run
## set | grep -v '^[ {}]' | sort
