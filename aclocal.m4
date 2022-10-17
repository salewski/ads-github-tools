# generated automatically by aclocal 1.16.3 -*- Autoconf -*-

# Copyright (C) 1996-2020 Free Software Foundation, Inc.

# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

m4_ifndef([AC_CONFIG_MACRO_DIRS], [m4_defun([_AM_CONFIG_MACRO_DIRS], [])m4_defun([AC_CONFIG_MACRO_DIRS], [_AM_CONFIG_MACRO_DIRS($@)])])
m4_ifndef([AC_AUTOCONF_VERSION],
  [m4_copy([m4_PACKAGE_VERSION], [AC_AUTOCONF_VERSION])])dnl
m4_if(m4_defn([AC_AUTOCONF_VERSION]), [2.69],,
[m4_warning([this file was generated for autoconf 2.69.
You have another version of autoconf.  It may work, but is not guaranteed to.
If you have problems, you may need to regenerate the build system entirely.
To do so, use the procedure documented by the package, typically 'autoreconf'.])])

# Copyright (C) 2002-2020 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_AUTOMAKE_VERSION(VERSION)
# ----------------------------
# Automake X.Y traces this macro to ensure aclocal.m4 has been
# generated from the m4 files accompanying Automake X.Y.
# (This private macro should not be called outside this file.)
AC_DEFUN([AM_AUTOMAKE_VERSION],
[am__api_version='1.16'
dnl Some users find AM_AUTOMAKE_VERSION and mistake it for a way to
dnl require some minimum version.  Point them to the right macro.
m4_if([$1], [1.16.3], [],
      [AC_FATAL([Do not call $0, use AM_INIT_AUTOMAKE([$1]).])])dnl
])

# _AM_AUTOCONF_VERSION(VERSION)
# -----------------------------
# aclocal traces this macro to find the Autoconf version.
# This is a private macro too.  Using m4_define simplifies
# the logic in aclocal, which can simply ignore this definition.
m4_define([_AM_AUTOCONF_VERSION], [])

# AM_SET_CURRENT_AUTOMAKE_VERSION
# -------------------------------
# Call AM_AUTOMAKE_VERSION and AM_AUTOMAKE_VERSION so they can be traced.
# This function is AC_REQUIREd by AM_INIT_AUTOMAKE.
AC_DEFUN([AM_SET_CURRENT_AUTOMAKE_VERSION],
[AM_AUTOMAKE_VERSION([1.16.3])dnl
m4_ifndef([AC_AUTOCONF_VERSION],
  [m4_copy([m4_PACKAGE_VERSION], [AC_AUTOCONF_VERSION])])dnl
_AM_AUTOCONF_VERSION(m4_defn([AC_AUTOCONF_VERSION]))])

# AM_AUX_DIR_EXPAND                                         -*- Autoconf -*-

# Copyright (C) 2001-2020 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# For projects using AC_CONFIG_AUX_DIR([foo]), Autoconf sets
# $ac_aux_dir to '$srcdir/foo'.  In other projects, it is set to
# '$srcdir', '$srcdir/..', or '$srcdir/../..'.
#
# Of course, Automake must honor this variable whenever it calls a
# tool from the auxiliary directory.  The problem is that $srcdir (and
# therefore $ac_aux_dir as well) can be either absolute or relative,
# depending on how configure is run.  This is pretty annoying, since
# it makes $ac_aux_dir quite unusable in subdirectories: in the top
# source directory, any form will work fine, but in subdirectories a
# relative path needs to be adjusted first.
#
# $ac_aux_dir/missing
#    fails when called from a subdirectory if $ac_aux_dir is relative
# $top_srcdir/$ac_aux_dir/missing
#    fails if $ac_aux_dir is absolute,
#    fails when called from a subdirectory in a VPATH build with
#          a relative $ac_aux_dir
#
# The reason of the latter failure is that $top_srcdir and $ac_aux_dir
# are both prefixed by $srcdir.  In an in-source build this is usually
# harmless because $srcdir is '.', but things will broke when you
# start a VPATH build or use an absolute $srcdir.
#
# So we could use something similar to $top_srcdir/$ac_aux_dir/missing,
# iff we strip the leading $srcdir from $ac_aux_dir.  That would be:
#   am_aux_dir='\$(top_srcdir)/'`expr "$ac_aux_dir" : "$srcdir//*\(.*\)"`
# and then we would define $MISSING as
#   MISSING="\${SHELL} $am_aux_dir/missing"
# This will work as long as MISSING is not called from configure, because
# unfortunately $(top_srcdir) has no meaning in configure.
# However there are other variables, like CC, which are often used in
# configure, and could therefore not use this "fixed" $ac_aux_dir.
#
# Another solution, used here, is to always expand $ac_aux_dir to an
# absolute PATH.  The drawback is that using absolute paths prevent a
# configured tree to be moved without reconfiguration.

AC_DEFUN([AM_AUX_DIR_EXPAND],
[AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
# Expand $ac_aux_dir to an absolute path.
am_aux_dir=`cd "$ac_aux_dir" && pwd`
])

# AM_CONDITIONAL                                            -*- Autoconf -*-

# Copyright (C) 1997-2020 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_CONDITIONAL(NAME, SHELL-CONDITION)
# -------------------------------------
# Define a conditional.
AC_DEFUN([AM_CONDITIONAL],
[AC_PREREQ([2.52])dnl
 m4_if([$1], [TRUE],  [AC_FATAL([$0: invalid condition: $1])],
       [$1], [FALSE], [AC_FATAL([$0: invalid condition: $1])])dnl
AC_SUBST([$1_TRUE])dnl
AC_SUBST([$1_FALSE])dnl
_AM_SUBST_NOTMAKE([$1_TRUE])dnl
_AM_SUBST_NOTMAKE([$1_FALSE])dnl
m4_define([_AM_COND_VALUE_$1], [$2])dnl
if $2; then
  $1_TRUE=
  $1_FALSE='#'
else
  $1_TRUE='#'
  $1_FALSE=
fi
AC_CONFIG_COMMANDS_PRE(
[if test -z "${$1_TRUE}" && test -z "${$1_FALSE}"; then
  AC_MSG_ERROR([[conditional "$1" was never defined.
Usually this means the macro was only invoked conditionally.]])
fi])])

# AM_EXTRA_RECURSIVE_TARGETS                                -*- Autoconf -*-

# Copyright (C) 2012-2020 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_EXTRA_RECURSIVE_TARGETS
# --------------------------
# Define the list of user recursive targets.  This macro exists only to
# be traced by Automake, which will ensure that a proper definition of
# user-defined recursive targets (and associated rules) is propagated
# into all the generated Makefiles.
# TODO: We should really reject non-literal arguments here...
AC_DEFUN([AM_EXTRA_RECURSIVE_TARGETS], [])

# Do all the work for Automake.                             -*- Autoconf -*-

# Copyright (C) 1996-2020 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This macro actually does too much.  Some checks are only needed if
# your package does certain things.  But this isn't really a big deal.

dnl Redefine AC_PROG_CC to automatically invoke _AM_PROG_CC_C_O.
m4_define([AC_PROG_CC],
m4_defn([AC_PROG_CC])
[_AM_PROG_CC_C_O
])

# AM_INIT_AUTOMAKE(PACKAGE, VERSION, [NO-DEFINE])
# AM_INIT_AUTOMAKE([OPTIONS])
# -----------------------------------------------
# The call with PACKAGE and VERSION arguments is the old style
# call (pre autoconf-2.50), which is being phased out.  PACKAGE
# and VERSION should now be passed to AC_INIT and removed from
# the call to AM_INIT_AUTOMAKE.
# We support both call styles for the transition.  After
# the next Automake release, Autoconf can make the AC_INIT
# arguments mandatory, and then we can depend on a new Autoconf
# release and drop the old call support.
AC_DEFUN([AM_INIT_AUTOMAKE],
[AC_PREREQ([2.65])dnl
dnl Autoconf wants to disallow AM_ names.  We explicitly allow
dnl the ones we care about.
m4_pattern_allow([^AM_[A-Z]+FLAGS$])dnl
AC_REQUIRE([AM_SET_CURRENT_AUTOMAKE_VERSION])dnl
AC_REQUIRE([AC_PROG_INSTALL])dnl
if test "`cd $srcdir && pwd`" != "`pwd`"; then
  # Use -I$(srcdir) only when $(srcdir) != ., so that make's output
  # is not polluted with repeated "-I."
  AC_SUBST([am__isrc], [' -I$(srcdir)'])_AM_SUBST_NOTMAKE([am__isrc])dnl
  # test to see if srcdir already configured
  if test -f $srcdir/config.status; then
    AC_MSG_ERROR([source directory already configured; run "make distclean" there first])
  fi
fi

# test whether we have cygpath
if test -z "$CYGPATH_W"; then
  if (cygpath --version) >/dev/null 2>/dev/null; then
    CYGPATH_W='cygpath -w'
  else
    CYGPATH_W=echo
  fi
fi
AC_SUBST([CYGPATH_W])

# Define the identity of the package.
dnl Distinguish between old-style and new-style calls.
m4_ifval([$2],
[AC_DIAGNOSE([obsolete],
             [$0: two- and three-arguments forms are deprecated.])
m4_ifval([$3], [_AM_SET_OPTION([no-define])])dnl
 AC_SUBST([PACKAGE], [$1])dnl
 AC_SUBST([VERSION], [$2])],
[_AM_SET_OPTIONS([$1])dnl
dnl Diagnose old-style AC_INIT with new-style AM_AUTOMAKE_INIT.
m4_if(
  m4_ifdef([AC_PACKAGE_NAME], [ok]):m4_ifdef([AC_PACKAGE_VERSION], [ok]),
  [ok:ok],,
  [m4_fatal([AC_INIT should be called with package and version arguments])])dnl
 AC_SUBST([PACKAGE], ['AC_PACKAGE_TARNAME'])dnl
 AC_SUBST([VERSION], ['AC_PACKAGE_VERSION'])])dnl

_AM_IF_OPTION([no-define],,
[AC_DEFINE_UNQUOTED([PACKAGE], ["$PACKAGE"], [Name of package])
 AC_DEFINE_UNQUOTED([VERSION], ["$VERSION"], [Version number of package])])dnl

# Some tools Automake needs.
AC_REQUIRE([AM_SANITY_CHECK])dnl
AC_REQUIRE([AC_ARG_PROGRAM])dnl
AM_MISSING_PROG([ACLOCAL], [aclocal-${am__api_version}])
AM_MISSING_PROG([AUTOCONF], [autoconf])
AM_MISSING_PROG([AUTOMAKE], [automake-${am__api_version}])
AM_MISSING_PROG([AUTOHEADER], [autoheader])
AM_MISSING_PROG([MAKEINFO], [makeinfo])
AC_REQUIRE([AM_PROG_INSTALL_SH])dnl
AC_REQUIRE([AM_PROG_INSTALL_STRIP])dnl
AC_REQUIRE([AC_PROG_MKDIR_P])dnl
# For better backward compatibility.  To be removed once Automake 1.9.x
# dies out for good.  For more background, see:
# <https://lists.gnu.org/archive/html/automake/2012-07/msg00001.html>
# <https://lists.gnu.org/archive/html/automake/2012-07/msg00014.html>
AC_SUBST([mkdir_p], ['$(MKDIR_P)'])
# We need awk for the "check" target (and possibly the TAP driver).  The
# system "awk" is bad on some platforms.
AC_REQUIRE([AC_PROG_AWK])dnl
AC_REQUIRE([AC_PROG_MAKE_SET])dnl
AC_REQUIRE([AM_SET_LEADING_DOT])dnl
_AM_IF_OPTION([tar-ustar], [_AM_PROG_TAR([ustar])],
	      [_AM_IF_OPTION([tar-pax], [_AM_PROG_TAR([pax])],
			     [_AM_PROG_TAR([v7])])])
_AM_IF_OPTION([no-dependencies],,
[AC_PROVIDE_IFELSE([AC_PROG_CC],
		  [_AM_DEPENDENCIES([CC])],
		  [m4_define([AC_PROG_CC],
			     m4_defn([AC_PROG_CC])[_AM_DEPENDENCIES([CC])])])dnl
AC_PROVIDE_IFELSE([AC_PROG_CXX],
		  [_AM_DEPENDENCIES([CXX])],
		  [m4_define([AC_PROG_CXX],
			     m4_defn([AC_PROG_CXX])[_AM_DEPENDENCIES([CXX])])])dnl
AC_PROVIDE_IFELSE([AC_PROG_OBJC],
		  [_AM_DEPENDENCIES([OBJC])],
		  [m4_define([AC_PROG_OBJC],
			     m4_defn([AC_PROG_OBJC])[_AM_DEPENDENCIES([OBJC])])])dnl
AC_PROVIDE_IFELSE([AC_PROG_OBJCXX],
		  [_AM_DEPENDENCIES([OBJCXX])],
		  [m4_define([AC_PROG_OBJCXX],
			     m4_defn([AC_PROG_OBJCXX])[_AM_DEPENDENCIES([OBJCXX])])])dnl
])
AC_REQUIRE([AM_SILENT_RULES])dnl
dnl The testsuite driver may need to know about EXEEXT, so add the
dnl 'am__EXEEXT' conditional if _AM_COMPILER_EXEEXT was seen.  This
dnl macro is hooked onto _AC_COMPILER_EXEEXT early, see below.
AC_CONFIG_COMMANDS_PRE(dnl
[m4_provide_if([_AM_COMPILER_EXEEXT],
  [AM_CONDITIONAL([am__EXEEXT], [test -n "$EXEEXT"])])])dnl

# POSIX will say in a future version that running "rm -f" with no argument
# is OK; and we want to be able to make that assumption in our Makefile
# recipes.  So use an aggressive probe to check that the usage we want is
# actually supported "in the wild" to an acceptable degree.
# See automake bug#10828.
# To make any issue more visible, cause the running configure to be aborted
# by default if the 'rm' program in use doesn't match our expectations; the
# user can still override this though.
if rm -f && rm -fr && rm -rf; then : OK; else
  cat >&2 <<'END'
Oops!

Your 'rm' program seems unable to run without file operands specified
on the command line, even when the '-f' option is present.  This is contrary
to the behaviour of most rm programs out there, and not conforming with
the upcoming POSIX standard: <http://austingroupbugs.net/view.php?id=542>

Please tell bug-automake@gnu.org about your system, including the value
of your $PATH and any error possibly output before this message.  This
can help us improve future automake versions.

END
  if test x"$ACCEPT_INFERIOR_RM_PROGRAM" = x"yes"; then
    echo 'Configuration will proceed anyway, since you have set the' >&2
    echo 'ACCEPT_INFERIOR_RM_PROGRAM variable to "yes"' >&2
    echo >&2
  else
    cat >&2 <<'END'
Aborting the configuration process, to ensure you take notice of the issue.

You can download and install GNU coreutils to get an 'rm' implementation
that behaves properly: <https://www.gnu.org/software/coreutils/>.

If you want to complete the configuration process using your problematic
'rm' anyway, export the environment variable ACCEPT_INFERIOR_RM_PROGRAM
to "yes", and re-run configure.

END
    AC_MSG_ERROR([Your 'rm' program is bad, sorry.])
  fi
fi
dnl The trailing newline in this macro's definition is deliberate, for
dnl backward compatibility and to allow trailing 'dnl'-style comments
dnl after the AM_INIT_AUTOMAKE invocation. See automake bug#16841.
])

dnl Hook into '_AC_COMPILER_EXEEXT' early to learn its expansion.  Do not
dnl add the conditional right here, as _AC_COMPILER_EXEEXT may be further
dnl mangled by Autoconf and run in a shell conditional statement.
m4_define([_AC_COMPILER_EXEEXT],
m4_defn([_AC_COMPILER_EXEEXT])[m4_provide([_AM_COMPILER_EXEEXT])])

# When config.status generates a header, we must update the stamp-h file.
# This file resides in the same directory as the config header
# that is generated.  The stamp files are numbered to have different names.

# Autoconf calls _AC_AM_CONFIG_HEADER_HOOK (when defined) in the
# loop where config.status creates the headers, so we can generate
# our stamp files there.
AC_DEFUN([_AC_AM_CONFIG_HEADER_HOOK],
[# Compute $1's index in $config_headers.
_am_arg=$1
_am_stamp_count=1
for _am_header in $config_headers :; do
  case $_am_header in
    $_am_arg | $_am_arg:* )
      break ;;
    * )
      _am_stamp_count=`expr $_am_stamp_count + 1` ;;
  esac
done
echo "timestamp for $_am_arg" >`AS_DIRNAME(["$_am_arg"])`/stamp-h[]$_am_stamp_count])

# Copyright (C) 2001-2020 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_PROG_INSTALL_SH
# ------------------
# Define $install_sh.
AC_DEFUN([AM_PROG_INSTALL_SH],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
if test x"${install_sh+set}" != xset; then
  case $am_aux_dir in
  *\ * | *\	*)
    install_sh="\${SHELL} '$am_aux_dir/install-sh'" ;;
  *)
    install_sh="\${SHELL} $am_aux_dir/install-sh"
  esac
fi
AC_SUBST([install_sh])])

# Copyright (C) 2003-2020 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# Check whether the underlying file-system supports filenames
# with a leading dot.  For instance MS-DOS doesn't.
AC_DEFUN([AM_SET_LEADING_DOT],
[rm -rf .tst 2>/dev/null
mkdir .tst 2>/dev/null
if test -d .tst; then
  am__leading_dot=.
else
  am__leading_dot=_
fi
rmdir .tst 2>/dev/null
AC_SUBST([am__leading_dot])])

# Fake the existence of programs that GNU maintainers use.  -*- Autoconf -*-

# Copyright (C) 1997-2020 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_MISSING_PROG(NAME, PROGRAM)
# ------------------------------
AC_DEFUN([AM_MISSING_PROG],
[AC_REQUIRE([AM_MISSING_HAS_RUN])
$1=${$1-"${am_missing_run}$2"}
AC_SUBST($1)])

# AM_MISSING_HAS_RUN
# ------------------
# Define MISSING if not defined so far and test if it is modern enough.
# If it is, set am_missing_run to use it, otherwise, to nothing.
AC_DEFUN([AM_MISSING_HAS_RUN],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
AC_REQUIRE_AUX_FILE([missing])dnl
if test x"${MISSING+set}" != xset; then
  MISSING="\${SHELL} '$am_aux_dir/missing'"
fi
# Use eval to expand $SHELL
if eval "$MISSING --is-lightweight"; then
  am_missing_run="$MISSING "
else
  am_missing_run=
  AC_MSG_WARN(['missing' script is too old or missing])
fi
])

# Helper functions for option handling.                     -*- Autoconf -*-

# Copyright (C) 2001-2020 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# _AM_MANGLE_OPTION(NAME)
# -----------------------
AC_DEFUN([_AM_MANGLE_OPTION],
[[_AM_OPTION_]m4_bpatsubst($1, [[^a-zA-Z0-9_]], [_])])

# _AM_SET_OPTION(NAME)
# --------------------
# Set option NAME.  Presently that only means defining a flag for this option.
AC_DEFUN([_AM_SET_OPTION],
[m4_define(_AM_MANGLE_OPTION([$1]), [1])])

# _AM_SET_OPTIONS(OPTIONS)
# ------------------------
# OPTIONS is a space-separated list of Automake options.
AC_DEFUN([_AM_SET_OPTIONS],
[m4_foreach_w([_AM_Option], [$1], [_AM_SET_OPTION(_AM_Option)])])

# _AM_IF_OPTION(OPTION, IF-SET, [IF-NOT-SET])
# -------------------------------------------
# Execute IF-SET if OPTION is set, IF-NOT-SET otherwise.
AC_DEFUN([_AM_IF_OPTION],
[m4_ifset(_AM_MANGLE_OPTION([$1]), [$2], [$3])])

# Copyright (C) 2001-2020 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_RUN_LOG(COMMAND)
# -------------------
# Run COMMAND, save the exit status in ac_status, and log it.
# (This has been adapted from Autoconf's _AC_RUN_LOG macro.)
AC_DEFUN([AM_RUN_LOG],
[{ echo "$as_me:$LINENO: $1" >&AS_MESSAGE_LOG_FD
   ($1) >&AS_MESSAGE_LOG_FD 2>&AS_MESSAGE_LOG_FD
   ac_status=$?
   echo "$as_me:$LINENO: \$? = $ac_status" >&AS_MESSAGE_LOG_FD
   (exit $ac_status); }])

# Check to make sure that the build environment is sane.    -*- Autoconf -*-

# Copyright (C) 1996-2020 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_SANITY_CHECK
# ---------------
AC_DEFUN([AM_SANITY_CHECK],
[AC_MSG_CHECKING([whether build environment is sane])
# Reject unsafe characters in $srcdir or the absolute working directory
# name.  Accept space and tab only in the latter.
am_lf='
'
case `pwd` in
  *[[\\\"\#\$\&\'\`$am_lf]]*)
    AC_MSG_ERROR([unsafe absolute working directory name]);;
esac
case $srcdir in
  *[[\\\"\#\$\&\'\`$am_lf\ \	]]*)
    AC_MSG_ERROR([unsafe srcdir value: '$srcdir']);;
esac

# Do 'set' in a subshell so we don't clobber the current shell's
# arguments.  Must try -L first in case configure is actually a
# symlink; some systems play weird games with the mod time of symlinks
# (eg FreeBSD returns the mod time of the symlink's containing
# directory).
if (
   am_has_slept=no
   for am_try in 1 2; do
     echo "timestamp, slept: $am_has_slept" > conftest.file
     set X `ls -Lt "$srcdir/configure" conftest.file 2> /dev/null`
     if test "$[*]" = "X"; then
	# -L didn't work.
	set X `ls -t "$srcdir/configure" conftest.file`
     fi
     if test "$[*]" != "X $srcdir/configure conftest.file" \
	&& test "$[*]" != "X conftest.file $srcdir/configure"; then

	# If neither matched, then we have a broken ls.  This can happen
	# if, for instance, CONFIG_SHELL is bash and it inherits a
	# broken ls alias from the environment.  This has actually
	# happened.  Such a system could not be considered "sane".
	AC_MSG_ERROR([ls -t appears to fail.  Make sure there is not a broken
  alias in your environment])
     fi
     if test "$[2]" = conftest.file || test $am_try -eq 2; then
       break
     fi
     # Just in case.
     sleep 1
     am_has_slept=yes
   done
   test "$[2]" = conftest.file
   )
then
   # Ok.
   :
else
   AC_MSG_ERROR([newly created file is older than distributed files!
Check your system clock])
fi
AC_MSG_RESULT([yes])
# If we didn't sleep, we still need to ensure time stamps of config.status and
# generated files are strictly newer.
am_sleep_pid=
if grep 'slept: no' conftest.file >/dev/null 2>&1; then
  ( sleep 1 ) &
  am_sleep_pid=$!
fi
AC_CONFIG_COMMANDS_PRE(
  [AC_MSG_CHECKING([that generated files are newer than configure])
   if test -n "$am_sleep_pid"; then
     # Hide warnings about reused PIDs.
     wait $am_sleep_pid 2>/dev/null
   fi
   AC_MSG_RESULT([done])])
rm -f conftest.file
])

# Copyright (C) 2009-2020 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_SILENT_RULES([DEFAULT])
# --------------------------
# Enable less verbose build rules; with the default set to DEFAULT
# ("yes" being less verbose, "no" or empty being verbose).
AC_DEFUN([AM_SILENT_RULES],
[AC_ARG_ENABLE([silent-rules], [dnl
AS_HELP_STRING(
  [--enable-silent-rules],
  [less verbose build output (undo: "make V=1")])
AS_HELP_STRING(
  [--disable-silent-rules],
  [verbose build output (undo: "make V=0")])dnl
])
case $enable_silent_rules in @%:@ (((
  yes) AM_DEFAULT_VERBOSITY=0;;
   no) AM_DEFAULT_VERBOSITY=1;;
    *) AM_DEFAULT_VERBOSITY=m4_if([$1], [yes], [0], [1]);;
esac
dnl
dnl A few 'make' implementations (e.g., NonStop OS and NextStep)
dnl do not support nested variable expansions.
dnl See automake bug#9928 and bug#10237.
am_make=${MAKE-make}
AC_CACHE_CHECK([whether $am_make supports nested variables],
   [am_cv_make_support_nested_variables],
   [if AS_ECHO([['TRUE=$(BAR$(V))
BAR0=false
BAR1=true
V=1
am__doit:
	@$(TRUE)
.PHONY: am__doit']]) | $am_make -f - >/dev/null 2>&1; then
  am_cv_make_support_nested_variables=yes
else
  am_cv_make_support_nested_variables=no
fi])
if test $am_cv_make_support_nested_variables = yes; then
  dnl Using '$V' instead of '$(V)' breaks IRIX make.
  AM_V='$(V)'
  AM_DEFAULT_V='$(AM_DEFAULT_VERBOSITY)'
else
  AM_V=$AM_DEFAULT_VERBOSITY
  AM_DEFAULT_V=$AM_DEFAULT_VERBOSITY
fi
AC_SUBST([AM_V])dnl
AM_SUBST_NOTMAKE([AM_V])dnl
AC_SUBST([AM_DEFAULT_V])dnl
AM_SUBST_NOTMAKE([AM_DEFAULT_V])dnl
AC_SUBST([AM_DEFAULT_VERBOSITY])dnl
AM_BACKSLASH='\'
AC_SUBST([AM_BACKSLASH])dnl
_AM_SUBST_NOTMAKE([AM_BACKSLASH])dnl
])

# Copyright (C) 2001-2020 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_PROG_INSTALL_STRIP
# ---------------------
# One issue with vendor 'install' (even GNU) is that you can't
# specify the program used to strip binaries.  This is especially
# annoying in cross-compiling environments, where the build's strip
# is unlikely to handle the host's binaries.
# Fortunately install-sh will honor a STRIPPROG variable, so we
# always use install-sh in "make install-strip", and initialize
# STRIPPROG with the value of the STRIP variable (set by the user).
AC_DEFUN([AM_PROG_INSTALL_STRIP],
[AC_REQUIRE([AM_PROG_INSTALL_SH])dnl
# Installed binaries are usually stripped using 'strip' when the user
# run "make install-strip".  However 'strip' might not be the right
# tool to use in cross-compilation environments, therefore Automake
# will honor the 'STRIP' environment variable to overrule this program.
dnl Don't test for $cross_compiling = yes, because it might be 'maybe'.
if test "$cross_compiling" != no; then
  AC_CHECK_TOOL([STRIP], [strip], :)
fi
INSTALL_STRIP_PROGRAM="\$(install_sh) -c -s"
AC_SUBST([INSTALL_STRIP_PROGRAM])])

# Copyright (C) 2006-2020 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# _AM_SUBST_NOTMAKE(VARIABLE)
# ---------------------------
# Prevent Automake from outputting VARIABLE = @VARIABLE@ in Makefile.in.
# This macro is traced by Automake.
AC_DEFUN([_AM_SUBST_NOTMAKE])

# AM_SUBST_NOTMAKE(VARIABLE)
# --------------------------
# Public sister of _AM_SUBST_NOTMAKE.
AC_DEFUN([AM_SUBST_NOTMAKE], [_AM_SUBST_NOTMAKE($@)])

# Check how to create a tarball.                            -*- Autoconf -*-

# Copyright (C) 2004-2020 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# _AM_PROG_TAR(FORMAT)
# --------------------
# Check how to create a tarball in format FORMAT.
# FORMAT should be one of 'v7', 'ustar', or 'pax'.
#
# Substitute a variable $(am__tar) that is a command
# writing to stdout a FORMAT-tarball containing the directory
# $tardir.
#     tardir=directory && $(am__tar) > result.tar
#
# Substitute a variable $(am__untar) that extract such
# a tarball read from stdin.
#     $(am__untar) < result.tar
#
AC_DEFUN([_AM_PROG_TAR],
[# Always define AMTAR for backward compatibility.  Yes, it's still used
# in the wild :-(  We should find a proper way to deprecate it ...
AC_SUBST([AMTAR], ['$${TAR-tar}'])

# We'll loop over all known methods to create a tar archive until one works.
_am_tools='gnutar m4_if([$1], [ustar], [plaintar]) pax cpio none'

m4_if([$1], [v7],
  [am__tar='$${TAR-tar} chof - "$$tardir"' am__untar='$${TAR-tar} xf -'],

  [m4_case([$1],
    [ustar],
     [# The POSIX 1988 'ustar' format is defined with fixed-size fields.
      # There is notably a 21 bits limit for the UID and the GID.  In fact,
      # the 'pax' utility can hang on bigger UID/GID (see automake bug#8343
      # and bug#13588).
      am_max_uid=2097151 # 2^21 - 1
      am_max_gid=$am_max_uid
      # The $UID and $GID variables are not portable, so we need to resort
      # to the POSIX-mandated id(1) utility.  Errors in the 'id' calls
      # below are definitely unexpected, so allow the users to see them
      # (that is, avoid stderr redirection).
      am_uid=`id -u || echo unknown`
      am_gid=`id -g || echo unknown`
      AC_MSG_CHECKING([whether UID '$am_uid' is supported by ustar format])
      if test $am_uid -le $am_max_uid; then
         AC_MSG_RESULT([yes])
      else
         AC_MSG_RESULT([no])
         _am_tools=none
      fi
      AC_MSG_CHECKING([whether GID '$am_gid' is supported by ustar format])
      if test $am_gid -le $am_max_gid; then
         AC_MSG_RESULT([yes])
      else
        AC_MSG_RESULT([no])
        _am_tools=none
      fi],

  [pax],
    [],

  [m4_fatal([Unknown tar format])])

  AC_MSG_CHECKING([how to create a $1 tar archive])

  # Go ahead even if we have the value already cached.  We do so because we
  # need to set the values for the 'am__tar' and 'am__untar' variables.
  _am_tools=${am_cv_prog_tar_$1-$_am_tools}

  for _am_tool in $_am_tools; do
    case $_am_tool in
    gnutar)
      for _am_tar in tar gnutar gtar; do
        AM_RUN_LOG([$_am_tar --version]) && break
      done
      am__tar="$_am_tar --format=m4_if([$1], [pax], [posix], [$1]) -chf - "'"$$tardir"'
      am__tar_="$_am_tar --format=m4_if([$1], [pax], [posix], [$1]) -chf - "'"$tardir"'
      am__untar="$_am_tar -xf -"
      ;;
    plaintar)
      # Must skip GNU tar: if it does not support --format= it doesn't create
      # ustar tarball either.
      (tar --version) >/dev/null 2>&1 && continue
      am__tar='tar chf - "$$tardir"'
      am__tar_='tar chf - "$tardir"'
      am__untar='tar xf -'
      ;;
    pax)
      am__tar='pax -L -x $1 -w "$$tardir"'
      am__tar_='pax -L -x $1 -w "$tardir"'
      am__untar='pax -r'
      ;;
    cpio)
      am__tar='find "$$tardir" -print | cpio -o -H $1 -L'
      am__tar_='find "$tardir" -print | cpio -o -H $1 -L'
      am__untar='cpio -i -H $1 -d'
      ;;
    none)
      am__tar=false
      am__tar_=false
      am__untar=false
      ;;
    esac

    # If the value was cached, stop now.  We just wanted to have am__tar
    # and am__untar set.
    test -n "${am_cv_prog_tar_$1}" && break

    # tar/untar a dummy directory, and stop if the command works.
    rm -rf conftest.dir
    mkdir conftest.dir
    echo GrepMe > conftest.dir/file
    AM_RUN_LOG([tardir=conftest.dir && eval $am__tar_ >conftest.tar])
    rm -rf conftest.dir
    if test -s conftest.tar; then
      AM_RUN_LOG([$am__untar <conftest.tar])
      AM_RUN_LOG([cat conftest.dir/file])
      grep GrepMe conftest.dir/file >/dev/null 2>&1 && break
    fi
  done
  rm -rf conftest.dir

  AC_CACHE_VAL([am_cv_prog_tar_$1], [am_cv_prog_tar_$1=$_am_tool])
  AC_MSG_RESULT([$am_cv_prog_tar_$1])])

AC_SUBST([am__tar])
AC_SUBST([am__untar])
]) # _AM_PROG_TAR

dnl -*- autoconf -*-
dnl SPDX-FileCopyrightText: <text> © 2016, 2020 Alan D. Salewski <ads@salewski.email> </text>
dnl SPDX-License-Identifier: GPL-2.0-or-later
dnl
dnl This macro provides for a new 'configure' option:
dnl
dnl     --with-perl-includes=DIR[:DIR...]
dnl
dnl which provides the following semantics:
dnl
dnl     --with-perl-includes=DIR prepends DIR (or DIRs) to Perl's @INC
dnl
dnl
dnl Multiple directories may be provided by separating the directory names
dnl with a colon (:); this works in the same way as PATH in the Bourne shell.
dnl
dnl The other ads_PERL5_* macros use this macro to allow the user to specify
dnl the locations of installed Perl 5 modules that may be installed in
dnl non-standard locations (that is, any locations that the 'perl' executable
dnl does not search by default).
dnl
dnl
dnl Dependencies
dnl ============
dnl
dnl This macro is not dependent on any macros that are not part of the core
dnl autotools.
dnl 
dnl
dnl Usage
dnl =====
dnl
dnl The ads_PERL_INCLUDES macro usually works as an implicit dependency that
dnl is automatically pulled in by explicitly using one of the other ads_PERL_*
dnl macros (such as ads_PERL_MODULE).
dnl 
dnl 
dnl Output
dnl ======
dnl 
dnl     * Shell variable in 'configure':  $ads_perl5_extra_includes
dnl 
dnl         ex. /some/path:/some/other/path
dnl
dnl       Multiple values separated by a colon (':') just like PATH
dnl 
dnl     * Filtering of variable in Autotools input files: @ads_perl5_extra_includes@
dnl       (same value as $ads_perl5_extra_includes
dnl 
dnl     * Filtering of variable in Autotools input files: @ads_perl5_extra_includes_opt@
dnl       (same value as $ads_perl5_extra_includes_opt (see below))
dnl 
dnl     * Automake conditional: USING_PERL5_EXTRA_INCLUDES
dnl       Will be true iff user specified extra include directories via
dnl       the --with-perl-includes command line opt
dnl 
dnl     * Shell variable in 'configure':  $ads_perl5_extra_includes_opt
dnl 
dnl         ex. "\"-I/some/path\" \"-I/some/o t h e r/path\""
dnl
dnl 
dnl       Note that use of this variable by Bourne shell code (or derivatives)
dnl       requires special care. In particular, this variable provides it's
dnl       own quoting for "logically" separate '-I' Perl arguments. It must do
dnl       this because we have to assume that any directories supplied by the
dnl       user may contain spaces in them. On the other hand, if the user did
dnl       not provide any additional '-I' directories, then we do not want to
dnl       pass an empty string argument to 'perl'.
dnl
dnl       Here are some examples of naive approaches to using this variable
dnl       (that just happen to work in some circumstances):
dnl
dnl         # WRONG! -- Breaks when no '-I' include paths were provided by
dnl         #           the user (because it creates an empty string arg
dnl         #           to perl).
dnl         #
dnl         #        -- Breaks when any '-I' include paths are provided because
dnl         #           of overquoting.
dnl         MOD='AppConfig'
dnl         "${PERL}" "${ads_perl5_extra_includes_opt}" -we '
dnl             use strict;
dnl             my $m = shift;
dnl             eval "require $m";
dnl             $@ and die $@;' "${MOD}"
dnl
dnl
dnl         # WRONG! -- Works when no '-I' include paths were provided by
dnl         #           the user
dnl         #
dnl         #        -- Breaks when any '-I' include paths are provided because
dnl         #           of overquoting.
dnl         MOD='AppConfig'
dnl         "${PERL}" ${ads_perl5_extra_includes_opt} -we '
dnl             use strict;
dnl             my $m = shift;
dnl             eval "require $m";
dnl             $@ and die $@;' "${MOD}"
dnl
dnl
dnl         # WRONG! -- Breaks when no '-I' include paths were provided by
dnl         #           the user (because it creates an empty string arg
dnl         #           to perl).
dnl         #
dnl         #        -- Works when any '-I' include paths were provided by
dnl         #           user (regardless of whether or not they have
dnl         #           spaces in them)
dnl         MOD='AppConfig'
dnl         "${PERL}" "$(eval echo ${ads_perl5_extra_includes_opt})" -we '
dnl             use strict;
dnl             my $m = shift;
dnl             eval "require $m";
dnl             $@ and die $@;' "${MOD}"
dnl
dnl
dnl         # WRONG! -- Works when no '-I' include paths were provided by
dnl         #           the user
dnl         #
dnl         #        -- Works when all of the '-I' include paths provided
dnl         #           by the user do /not/ contain spaces in them.
dnl         #
dnl         #        -- Breaks when any of the '-I' include paths provided
dnl         #           by the user do contain spaces in them.
dnl         MOD='AppConfig'
dnl         "${PERL}" $(eval echo "${ads_perl5_extra_includes_opt}") -we '
dnl             use strict;
dnl             my $m = shift;
dnl             eval "require $m";
dnl             $@ and die $@;' "${MOD}"
dnl
dnl
dnl       The key is to use the shell's builtin 'eval' command with an extra
dnl       layer of quoting around its arguments such that the resulting
dnl       quoting results in $ads_perl5_extra_includes_opt providing it's own
dnl       quoting, and everything else being single quoted:
dnl
dnl         # CORRECT!
dnl         eval "'""${PERL}""'" "${ads_perl5_extra_includes_opt}" -we "'"'
dnl             use strict;
dnl             my $m = shift;
dnl             eval "require $m";
dnl             $@ and die $@;'"'" "'""${MOD}""'"
dnl
dnl
dnl Design Notes
dnl ============
dnl
dnl     * We would have liked to use Bash or KornShell (ksh) style arrays for
dnl       storing the values of @ads_perl5_extra_includes_opt@, but shell
dnl       arrays are non-portable :-(
dnl
dnl
dnl TODO
dnl ====
dnl
dnl     * Add logic to print those directories (if any) found in PERL5LIB that
dnl       were not specified by the user on the command line (for transparency).

AC_DEFUN([ads_PERL_INCLUDES], [

    AC_ARG_WITH([perl-includes],

        [[  --with-perl-includes=DIR[:DIR:...]
                          prepend DIRs to Perl's @INC]],

        [ # AC_ARG_WITH: option if given
            AC_MSG_CHECKING([[for dirs to prepend to Perl's @INC]])

[
            if test "$withval" = "no"  || \
               test "$withval" = "yes" || \
               test -z "$withval"; then
                # The above result from one of the following spefications by the user:
                #
                #     --with-perl-includes=yes
                #     --with-perl-includes=no
                #
                # Both of the above are bogus because they are equivalent to these:
                #
                #     --with-perl-includes
                #     --without-perl-includes
                #
                # The DIR param is required.
]
                AC_MSG_ERROR([[missing argument to --with-perl-includes]])
[
            else

                # Verify that the user-specified directory (or directories) exists. Build
                # up our internal ads_perl5_* variables at the same time.
                _tmp_results_string=''
                IFShold=$IFS
                IFS=':'
                for _tdir in ${withval}; do
                    if test -d "${_tdir}"; then :; else
                        IFS=$IFShold
]
                        AC_MSG_ERROR([no such directory: ${_tdir}])
[
                    fi

                    if test -z "$ads_perl5_extra_includes"; then
                        ads_perl5_extra_includes="${_tdir}"
                        ads_perl5_extra_includes_opt="-I\"${_tdir}\""  # for passing on 'perl' command line, if needed
                        _tmp_results_string="`printf "\n    ${_tdir}"`"
                    else
                        ads_perl5_extra_includes="${ads_perl5_extra_includes}:${_tdir}"
                        ads_perl5_extra_includes_opt=${ads_perl5_extra_includes_opt}" -I\"${_tdir}\""
                        _tmp_results_string="${_tmp_results_string}`printf "\n    ${_tdir}"`"
                    fi
                done
                IFS=$IFShold
]
                AC_MSG_RESULT([${_tmp_results_string}])
[
            fi
]
        ],

        [ # AC_ARG_WITH: option if not given, same as --without-perl-includes
            AC_MSG_CHECKING([[for dirs to prepend to Perl's @INC]])
            AC_MSG_RESULT([[none]])
        ]
    )dnl end fo AC_ARG_WITH(perl-includes) macro

    AC_SUBST([ads_perl5_extra_includes])
    AC_SUBST([ads_perl5_extra_includes_opt])

    dnl register a conditional for use in Makefile.am files
    AM_CONDITIONAL([USING_PERL5_EXTRA_INCLUDES], [test -n "${ads_perl5_extra_includes}"])
])

dnl -*- autoconf -*-
dnl SPDX-FileCopyrightText: <text> © 2016, 2020 Alan D. Salewski <ads@salewski.email> </text>
dnl SPDX-License-Identifier: GPL-2.0-or-later
dnl 
dnl This file provides the 'ads_PERL_MODULE' autoconf macro, which may be used
dnl to add checks in your 'configure.ac' file for a specific Perl module.
dnl 
dnl By default, the specified module is "required"; if it is not found, the
dnl 'configure' program will print an error message and exit with an error
dnl status (via AC_MSG_ERROR). However, you may pass a parameter indicating
dnl that the module is optional; in that case 'configure' will simply print a
dnl message indicating that the module was not found and continue on.
dnl 
dnl Dependencies
dnl ============
dnl 
dnl This macro contains an automatic dependency on the 'ads_PROG_PERL'
dnl autoconf macro to set the $PERL shell variable to the path of the
dnl configured Perl interpreter.
dnl 
dnl Usage
dnl =====
dnl 
dnl ads_PERL_MODULE(PERL_MODULE_NAME, [REQUIRED|OPTIONAL], [PERL_MODULE_VERSION])
dnl 
dnl     * The PERL_MODULE_NAME param is required.
dnl 
dnl     * The second param is optional, and defaults to the constant 'REQUIRED'.
dnl 
dnl     * The PERL_MODULE_VERSION param is optional. If not specified, then
dnl       'configure' will be satisfied if /any/ version of the module is
dnl       found. Note that the specified version is /not/ absolute; we use the
dnl       Perl interpreter to determine whether or not the version requirement
dnl       is satisfied (which checks the module's $VERSION property), so it is
dnl       essentially a check for "the specified version number or newer". See
dnl       the perlmodlib(1) in the Perl documentation for all the details.
dnl 
dnl Examples
dnl ========
dnl 
dnl The following examples show snippets that would be placed in your
dnl 'configure.ac' file.
dnl 
dnl Example 1
dnl ---------
dnl 
dnl     ## Module 'Foo::Bar::Baz' is required (any version)
dnl     ads_PERL_MODULE([Foo::Bar::Baz])
dnl 
dnl Example 2
dnl ---------
dnl 
dnl     ## Same as Example 1, only more explicit
dnl     ads_PERL_MODULE([Foo::Bar::Baz], [REQUIRED])
dnl 
dnl Example 3
dnl ---------
dnl 
dnl     ## Version 0.02 of module 'Foo::Bar::Baz' is required
dnl     ads_PERL_MODULE([Foo::Bar::Baz], [REQUIRED], [0.02])
dnl 
dnl 
dnl Design Notes
dnl ============
dnl
dnl Required/Optional Param
dnl -----------------------
dnl Note that in order to specify the module version number, you must specify
dnl either 'REQUIRED' or 'OPTIONAL' as the second macro parameter.
dnl 
dnl An alternative interface design would make the version number the second
dnl param, and the 'REQUIRED' or 'OPTIONAL' param would always be optional.
dnl 
dnl The existing interface was decided on in order to optimize for the common
dnl case. The presumption, obviously, is that users of the macro will need to
dnl specify that a module is required or optional more often than they will
dnl need to specify a dependency on a particular version of the
dnl module. Moreover, users probably do /not/ want to specify a version number
dnl (or use hacks such as '0.00') when all they really want to do is indicate
dnl that a module is required or optional.
dnl
dnl
dnl Module Version Number Output
dnl ----------------------------
dnl If the user requests a specifc version number of the specified module,
dnl then we display both the requested version number (as part of the
dnl "checking for" message) and the version actually found (as part of the
dnl result message). For these modules, a version number is required, and
dnl 'configure' will bomb out even if the module is found, but does not
dnl specify a version number (note that in this case, 'configure' actually
dnl stops as a result of 'perl' exiting with an error status when we request
dnl such a module, so we're behaving consistently with Perl). Here's some
dnl example output:
dnl 
dnl     checking for for LWP::UserAgent 2.000... (2.033) /usr/share/perl5/LWP/UserAgent.pm
dnl 
dnl If the user did not request a specific version number, we still print out
dnl the version number found if we're able to determine it:
dnl 
dnl     checking for for LWP::UserAgent ... (2.033) /usr/share/perl5/LWP/UserAgent.pm
dnl 
dnl If the usre did not request a specific version number, and the module
dnl doesn't provide a version number (according to Perl's Exporter module
dnl conventions), then we simply show '???' for the version number:
dnl 
dnl     checking for for Example::FooMod... (???) /some/path/to/perl/lib/Example/FooMod.pm
dnl 
dnl 
dnl 
dnl TODO
dnl ====
dnl     * Add use of (not yet existing) facility to include maintainer name
dnl       and email address information for inclusion in error messages that
dnl       detect bugs in the macro.
dnl 
dnl     * Maybe set HAVE_PERL5_MODULE_FOO_BAR_BAZ automake conditional
dnl 
dnl     * Maybe set @HAVE_PERL5_MODULE_FOO_BAR_BAZ@ automake variable
dnl 

AC_DEFUN([ads_PERL_MODULE], [

    AC_REQUIRE([ads_PROG_PERL])
    AC_REQUIRE([ads_PERL_INCLUDES])

[
    _tmp_macro_name='ads_PERL_MODULE.m4'

    # (required) This should be something like Foo::Bar::Baz
    _tmp_perl_mod_name=$1
    if test -z "${_tmp_perl_mod_name}"; then
        # This is almost certainly a programmer error
]
        AC_MSG_ERROR([[
    ${_tmp_macro_name} ERROR: required 'PERL_MODULE_NAME' param not provided

    Usage:
        ${_tmp_macro_name}(PERL_MODULE_NAME, [REQUIRED|OPTIONAL], [PERL_MODULE_VERSION])
]])
[
    fi

    # (optional) If not provided, then we assume that the Perl
    # module is required. Valid values are 'REQUIRED' or 'OPTIONAL'.
    _tmp_perl_mod_required_or_optional=$2
    if test -z "${_tmp_perl_mod_required_or_optional}"; then
        _tmp_perl_mod_required_or_optional='REQUIRED'  # dflt
    fi
    if test "${_tmp_perl_mod_required_or_optional}" = 'REQUIRED' ||
       test "${_tmp_perl_mod_required_or_optional}" = 'OPTIONAL'; then :; else
]
        AC_MSG_ERROR([[
    ${_tmp_macro_name} ERROR: second macro param must be either 'REQUIRED' or 'OPTIONAL' (got "${_tmp_perl_mod_required_or_optional}")

    Usage:
        ${_tmp_macro_name}(PERL_MODULE_NAME, [REQUIRED|OPTIONAL], [PERL_MODULE_VERSION])
]])
[
    fi

    # (optional) If provided, this should be the perl module version
    _tmp_perl_mod_version=$3

    _tmp_check_msg="for ${_tmp_perl_mod_name}"
    if test -n "${_tmp_perl_mod_version}"; then
        _tmp_check_msg="${_tmp_check_msg} ${_tmp_perl_mod_version}"
    fi

    _tmp_perl_mod_msg_version="${_tmp_perl_mod_version}"
    if test -z "${_tmp_perl_mod_version}"; then
        _tmp_perl_mod_msg_version='(any version)'
    fi
]
    AC_MSG_CHECKING([[for ${_tmp_check_msg}]])
[
    # Invoking perl twice is inefficient, but better isolates our test
    eval "'""${PERL}""'" "${ads_perl5_extra_includes_opt}" \
              -we "'""use strict; use ${_tmp_perl_mod_name} ${_tmp_perl_mod_version};""'"
    if test $? -eq 0; then
        # Great, we have the module. Now print where it was found:
        _tmp_perl_mod_path="$( eval "'""${PERL}""'" "${ads_perl5_extra_includes_opt}" \
          -MFile::Spec -wle "'"'
            use strict;
            my $modname = shift;
            eval "require ${modname}";
            ${@} and die qq{Was unable to require module "$modname": ${@}};
            $modname .= q{.pm};
            my $found = undef;
            my $shortpath = File::Spec->catdir( split(q{::}, $modname) );
            my $fullpath;
            if (exists $INC{ $shortpath } && defined $INC{ $shortpath }) {
                $found = 1;
                $fullpath = $INC{ $shortpath };
            }
            $fullpath = q{<path unavailable in %INC}
                unless defined $fullpath && length $fullpath;
            print $fullpath;
            exit ($found ? 0 : 1);  # parens required
        '"'" "'""${_tmp_perl_mod_name}""'")"
        if test $? -ne 0; then
]

dnl FIXME: provide macro maintainer email address in error message

            AC_MSG_ERROR([[
    Perl module ${_tmp_perl_mod_name} exists, but 'configure' was unable to
    determine the path to the module. This is likely a bug in the ${_tmp_macro_name}
    autoconf macro; please report this as a bug.
]])
[
        fi

        # Always attempt to determine the version number of the module that
        # was actually found and display it to the user. Not all Perl modules
        # provide a $VERSION variable, but if the one we're testing for does,
        # then we'll show it.
        #
        # Note that we do this even for those modules for which the user has
        # requested a specific version because the user-specified version is
        # understood as "this version or newer", so may be different from the
        # version of the module actually found on the system.

        _tmp_found_mod_version="$(
          eval "'""${PERL}""'" "'""-M${_tmp_perl_mod_name}""'" \
            "${ads_perl5_extra_includes_opt}" -wle "'"'
               my $modname = shift;
               my $ver = "${modname}::VERSION";
               print $$ver if defined $$ver && length $$ver;
            '"'" "'""${_tmp_perl_mod_name}""'"
        )"
        if test $? -ne 0; then
]
            AC_MSG_ERROR([[
    Perl module ${_tmp_perl_mod_name} exists, but 'configure' was unable to
    test whether or not the module specifies a version number. This is likely
    a bug in the ${_tmp_macro_name} autoconf macro; please report this as a bug.
]])
[
        fi

        if test "${_tmp_found_mod_version}x" = 'x'; then
            # Module does not provide version info, so use bogon string
            _tmp_perl_mod_path="(???) ${_tmp_perl_mod_path}"
        else
            # Prepend the value to the module path for display to the user
            _tmp_perl_mod_path="(${_tmp_found_mod_version}) ${_tmp_perl_mod_path}"
        fi
]
        AC_MSG_RESULT([[${_tmp_perl_mod_path}]])
[
    else
        if test "${_tmp_perl_mod_required_or_optional}" = 'REQUIRED'; then
]
            AC_MSG_ERROR([[
    Was unable to locate Perl module ${_tmp_perl_mod_name} ${_tmp_perl_mod_msg_version}
]])
[
        else  # presence of module was optional
]
            AC_MSG_RESULT([[no (ok)]])
[
        fi
    fi
]
])

dnl FIXME: Maybe provide an autoconf flag indicating whether or not
dnl        the Perl module was found.

dnl -*- autoconf -*-
dnl SPDX-FileCopyrightText: <text> © 2020 Alan D. Salewski <ads@salewski.email> </text>
dnl SPDX-License-Identifier: GPL-2.0-or-later
dnl
dnl ads_PROG_CARGO([required_cargo_version])
dnl
dnl This macro tests for the existence of Cargo on the target
dnl system.
dnl
dnl Cargo is the dependency management and build orchestration tool
dnl for the Rust programming language.
dnl
dnl     https://github.com/rust-lang/cargo/
dnl     https://doc.rust-lang.org/cargo/
dnl
dnl Cargo is distributed by default with Rust. If you have the
dnl compiler, 'rustc', installed locally, then you probably also
dnl have 'cargo' installed locally.
dnl
dnl By default, this macro looks for Cargo version 1.0.0 or newer,
dnl which is entirely arbitrary. That would correspond to the Rust
dnl 1.0.0 release from 2015-05-15. At the time of writing (2020-10)
dnl the current version of cargo (the binary) is 1.47.0, released
dnl 2020-10-08.
dnl
dnl [ Aside: Cargo consists of two separate components: the binary
dnl   program ('cargo') and a library; both are versioned
dnl   differently. The binary program tracks the version numbers of
dnl   'rustc', and the library uses semantic versioning and a
dnl   separate version number. See comments in
dnl   cargo/src/cargo/lib.rs for details. In this macro, we are only
dnl   concerned with the version number of 'cargo' the binary
dnl   program that the user invokes on the command line. ]
dnl
dnl You can change the version required by passing in the optional
dnl 'required_cargo_version' argument, setting it to the cargo
dnl version you want. The 'required_cargo_version' argument should
dnl be specified in the form:
dnl
dnl     "M.m.p"
dnl
dnl where 'M' == "major",
dnl       'm' == "minor", and
dnl       'p' == "patch".
dnl
dnl
dnl If no 'cargo' program of the the required minimum version is
dnl found, then this macro will bomb out with an error message.
dnl
dnl To use this macro, just drop it in your configure.ac file as
dnl indicated in the examples below. Then use @CARGO_PROG@ in any of
dnl your files that will be processed by automake; the @CARGO_PROG@
dnl variable will be expanded to the full path of the cargo program.
dnl
dnl The specific version of Cargo found at configure time is made
dnl available in ${CARGO_PROG_VERSION}, which is AC_SUBST'd as
dnl @CARGO_PROG_VERSION@.
dnl
dnl Examples:
dnl     ads_PROG_CARGO             (looks for 1.0.0, the default)
dnl     ads_PROG_CARGO()           (same effect as previous)
dnl     ads_PROG_CARGO([1.42.1])   (looks for 1.42.1, or newer)
dnl
dnl Note that the cargo version specified is only a /minimum/
dnl required version. The macro will look for that specified version
dnl or any newer version.
dnl
dnl
dnl Dependencies
dnl ============
dnl This macro contains an automatic dependency on the 'AC_PROG_AWK' and
dnl 'AC_PROG_SED' autoconf macros to set the $AWK and $SED shell variables,
dnl respecitvely, to the corresponding path of the configured 'awk' or 'sed'
dnl program used within the test.
dnl
dnl
dnl AUTHOR
dnl
dnl     * This macro was written by Alan D. Salewksi <ads AT salewski.email>

AC_DEFUN_ONCE([ads_PROG_CARGO], [

# start: [[ads_PROG_CARGO]]
    AC_REQUIRE([AC_PROG_AWK])
    AC_REQUIRE([AC_PROG_SED])

#set -x
    _ads_req_cargo_version="$1"
    if test -z "${_ads_req_cargo_version}"; then
        _ads_req_cargo_version='1.0.0'
    fi
    AC_PATH_PROG(CARGO_PROG, cargo)
    if test -z "${CARGO_PROG}"; then
        AC_MSG_ERROR([cargo not found])
    fi

    AC_MSG_CHECKING([[cargo version (need ${_ads_req_cargo_version} or newer)]])

[# bracket is m4 quote bait start: do not remove

    # For legit semver version number strings, emits the five component
    # fields (major, minor, patch, pre-release, and buildinfo) on stdout
    # and then returns 0 (success).
    #
    # For non-legit semver version number strings, emits the value '_'
    # (underscore) for all five components and then returns 1 (error).
    #
    # In the success case, the major, minor, and patch fields will
    # always be non-empty, but either one (or both) of the pre-release
    # and buildinfo fields may be empty). Any empty fields are emitted
    # as '_'.
    #
    _ads_f_prog_cargo_extract_vfields() {
        _ads_local_val_to_check=$][1

        if test -z "${_ads_local_val_to_check}"; then
            printf '%s  %s  %s  %s  %s\n' '_' '_' '_' '_' '_'
            return 1  # error
        fi

        # When extracting the M, m, and p values we use not only two
        # separate sed expressions, but two separate invocations.
        #
        # The first sed expression (in the first invocation) plucks out
        # the relevant number from the M.m.p triplet ("the M part", "the
        # m part", or "the p part"). This part only emits a non-empty
        # value if it recognized the data.
        #
        # The second sed expression (in the second invocation) slices
        # off any leading zeros, but leaves stand-alone zeros alone. If
        # the first expression did not emit anything, then this cleanup
        # step is effectively a NOOP. Note that the Semantic Versioning
        # 2.0.0 ("SemVer") spec requires this no-leading-zeros behavior:
        #
        #     "A normal version number MUST take the form X.Y.Z where X,
        #      Y, and Z are non-negative integers, and MUST NOT contain
        #      leading zeroes."
        #
        # See also:
        #     https://semver.org/

        # XXX: We use alteration in our sed regexen, which is reportedly
        #      not universally portable. See the Autoconf manual,
        #      section "11.15 Limitations of Usual Tools ================================". If you run
        #      into a problem with this on your platform, please open a
        #      bug to let us know so we can prioritize a fix.

#set -x
        _ads_local_tval_M=$(printf '%s\n' "${_ads_local_val_to_check}" \
                   | "${SED}" -n -e 's/^\([[:digit:]]\{1,\}\)[.].*/\1/p' \
                   | "${SED}"    -e 's/^0*\([1-9][[:digit:]]*\)/\1/')

        _ads_local_tval_m=$(printf '%s\n' "${_ads_local_val_to_check}" \
                   | "${SED}" -n -e 's/^[[:digit:]]\{1,\}[.]\([[:digit:]]\{1,\}\)[.].*/\1/p' \
                   | "${SED}"    -e 's/^0*\([1-9][[:digit:]]*\)/\1/')

        _ads_local_tval_p=$(printf '%s\n' "${_ads_local_val_to_check}" \
                   | "${SED}" -n -e 's/^[[:digit:]]\{1,\}[.][[:digit:]]\{1,\}[.]\([[:digit:]]\{1,\}\)\([-+].*\|$\)/\1/p' \
                   | "${SED}"    -e 's/^0*\([1-9][[:digit:]]*\)/\1/')

        _ads_local_tval_prerel=$(printf '%s\n' "${_ads_local_val_to_check}" \
                        | "${SED}" -n -e 's/^[[:digit:]]\{1,\}[.][[:digit:]]\{1,\}[.][[:digit:]]\{1,\}-\([0-9A-Za-z-]\{1,\}\([.][0-9A-Za-z-]\{1,\}\)*\)\([+].*\|$\)/\1/p')

        _ads_local_tval_buildinfo=$(printf '%s\n' "${_ads_local_val_to_check}" \
                          | "${SED}" -n -e 's/^[[:digit:]]\{1,\}[.][[:digit:]]\{1,\}[.][[:digit:]]\{1,\}\(-[0-9A-Za-z-]\{1,\}\([.][0-9A-Za-z-]\{1,\}\)*\)\{0,1\}[+]\([0-9A-Za-z-]\{1,\}\([.][0-9A-Za-z-]\{1,\}\)*\)\{0,1\}$/\3/p' )
#set +x

        _ads_local_tval_recombined="${_ads_local_tval_M}.${_ads_local_tval_m}.${_ads_local_tval_p}"
        if test -n "${_ads_local_tval_prerel}"; then
            _ads_local_tval_recombined="${_ads_local_tval_recombined}-${_ads_local_tval_prerel}"
        fi
        if test -n "${_ads_local_tval_buildinfo}"; then
            _ads_local_tval_recombined="${_ads_local_tval_recombined}+${_ads_local_tval_buildinfo}"
        fi

        # If our recombined fields do not exactly match the input value
        # that was provided, then it was not a legit semver field.
        if test "${_ads_local_tval_recombined}" = "${_ads_local_val_to_check}"; then :; else
            printf '%s  %s  %s  %s  %s\n' '_' '_' '_' '_' '_'
            return 1  # error
        fi

        printf '%s  %s  %s  %s  %s\n' \
            "${_ads_local_tval_M}"    \
            "${_ads_local_tval_m}"    \
            "${_ads_local_tval_p}"    \
            "${_ads_local_tval_prerel:-_}"   \
            "${_ads_local_tval_buildinfo:-_}"
        return 0;  # success
    }

]# bracket is m4 quote bait end: do not remove

    # Sanity check the required ("given") cargo version

    read -r givmaj givmin givpat givrel givbld <<EOF
$(_ads_f_prog_cargo_extract_vfields "${_ads_req_cargo_version}")
EOF

    if test "${givmaj}" = '_' \
    || test "${givmin}" = '_' \
    || test "${givpat}" = '_'; then
        # The cargo version number provided ("given") in configure.ac is
        # invalid
        AC_MSG_ERROR([[ads_PROG_CARGO: (bug):]][ invalid cargo version specified: ${_ads_req_cargo_version}])
    fi

[## bracket is m4 quote bait start: do not remove
    # Example output from cargo --version from a few different versions of
    # cargo, to give an idea of what we are expecting:
    #     cargo 1.42.1
    #     cargo 1.47.0 (f3c7e066a 2020-08-28)
    _ads_t_found_cargo_version=$("${CARGO_PROG}" --version | "${SED}" -e 's/^[[:space:]]*cargo[[:space:]]*//' | "${AWK}" '{ print $][1 }' )
]## bracket is m4 quote bait end: do not remove
    if test $? -ne 0; then
        # unable to determine version of the found cargo program
        AC_MSG_ERROR([was unable to determine cargo version])
    fi

    if test -z "${_ads_t_found_cargo_version}"; then
        AC_MSG_ERROR([found cargo version string is empty])
    fi

    read -r fndmaj fndmin fndpat fndrel fndbld <<EOF
$(_ads_f_prog_cargo_extract_vfields "${_ads_t_found_cargo_version}")
EOF

    if test "${fndmaj}" = '_' \
    || test "${fndmin}" = '_' \
    || test "${fndpat}" = '_'; then
        AC_MSG_ERROR([[ads_PROG_CARGO: (bug?):]][ invalid cargo version found: ${_ads_t_found_cargo_version}])
    fi

    if test "${fndmaj}" -lt "${givmaj}"; then
        # found cargo version is not recent enough (major too low)
        AC_MSG_ERROR([found: ${_ads_t_found_cargo_version}])
    fi
    if test "${fndmaj}" -eq "${givmaj}" \
    && test "${fndmin}" -lt "${givmin}"; then
        # found cargo version is not recent enough (minor too low)
        AC_MSG_ERROR([found: ${_ads_t_found_cargo_version}])
    fi
    if test "${fndmaj}" -eq "${givmaj}" \
    && test "${fndmin}" -eq "${givmin}" \
    && test "${fndpat}" -lt "${givpat}"; then
        # found cargo version is not recent enough (patch too low)
        AC_MSG_ERROR([found: ${_ads_t_found_cargo_version}])
    fi

    if test "${fndmaj}" -gt "${givmaj}"; then
        # found cargo version's major is higher than the required, so
        # that's good enough.
        AC_MSG_RESULT([yes: ${_ads_t_found_cargo_version}])

    elif test "${fndmaj}" -eq "${givmaj}" \
      && test "${fndmin}" -gt "${givmin}"; then
        # found cargo version's major is the same as the required
        # version, but the minor version is higher than the required;
        # that's good enough.
        AC_MSG_RESULT([yes: ${_ads_t_found_cargo_version}])

    elif test "${fndmaj}" -eq "${givmaj}" \
      && test "${fndmin}" -eq "${givmin}" \
      && test "${fndpat}" -gt "${givpat}"; then
        # found cargo version's major and minor are the same as the
        # required version, but the patch version is higher than the
        # required; that's good enough.
        AC_MSG_RESULT([yes: ${_ads_t_found_cargo_version}])
    else

        # If we are falling through here, then the found M.m.p is
        # identical to the required M.m.p.
        #
        # The only thing left to distinguish the values is the
        # "pre-release" field.

        if test "${givrel}" = "${fndrel}"; then
            # Either both are '_' (not present), or both have the same
            # value. Either way, the found value satisfies the search.
            AC_MSG_RESULT([yes: ${_ads_t_found_cargo_version}])

        else
            # From the SemVer 2.0 spec: "Pre-release versions have a
            # lower precedence than the associated normal version."

            if test "${givrel}" = '_'; then
                # Our given pre-release field is empty...

                if test "${fndrel}" = '_'; then :; else
                    # ...but our found pre-release field is not. Our
                    # found version is "lower" than our given version.

                    # Found cargo version is not recent enough
                    AC_MSG_ERROR([found: ${_ads_t_found_cargo_version}])
                fi

            elif test "${fndrel}" = '_'; then
                # Our found pre-release field is empty...

                if test "${givrel}" = '_'; then :; else
                    # ...but our given pre-release field is not. Our
                    # given version is "lower" than our found version.
                    AC_MSG_RESULT([yes: ${_ads_t_found_cargo_version}])
                fi
            else

                # XXX: There are rules for comparing pre-release field
                #      strings, but that functionality is not
                #      implemented here. It seems like a corner case
                #      that is unlikely to affect people in the real
                #      world. Please file a bug to tell us otherwise if
                #      it affects your workflow. For now, we just
                #      punt...

                AC_MSG_ERROR([[ads_PROG_CARGO: (bug):]][comparison of unequal "pre-release" fields not currently supported. Required: ${_ads_req_cargo_version}; got: ${_ads_t_found_cargo_version}])
            fi
        fi
    fi

    CARGO_PROG_VERSION=${_ads_t_found_cargo_version}
    AC_SUBST([CARGO_PROG_VERSION])

#set +x
# end: [[ads_PROG_CARGO]]
])

dnl -*- autoconf -*-
dnl SPDX-FileCopyrightText: <text> © 2016, 2020 Alan D. Salewski <ads@salewski.email> </text>
dnl SPDX-License-Identifier: GPL-2.0-or-later
dnl
dnl ads_PROG_PERL([required_perl_version])
dnl
dnl This macro tests for the existence of a perl interpreter on the target
dnl system. By default, it looks for perl version 5.005 or newer; you can
dnl change the default version by passing in the optional
dnl 'required_perl_version' argument, setting it to the perl version you
dnl want. The format of the 'required_perl_version' argument string is
dnl anything that you could legitimately use in a perl script, but see below
dnl for a note on the format of the perl version argument and compatibility
dnl with older perl interpreters.
dnl
dnl If no perl interpreter of the the required minimum version is found, then
dnl we bomb out with an error message.
dnl
dnl To use this macro, just drop it in your configure.ac file as indicated in
dnl the examples below. Then use @PERL@ in any of your files that will be
dnl processed by automake; the @PERL@ variable will be expanded to the full
dnl path of the perl interpreter.
dnl
dnl Examples:
dnl     ads_PROG_PERL              (looks for 5.005, the default)
dnl     ads_PROG_PERL()            (same effect as previous)
dnl     ads_PROG_PERL([5.006])     (looks for 5.6.0, preferred way)
dnl     ads_PROG_PERL([5.6.0])     (looks for 5.6.0, don't do this)
dnl
dnl Note that care should be taken to make the required perl version backward
dnl compatible, as explained here:
dnl
dnl     http://perldoc.perl.org/functions/require.html
dnl
dnl That is why the '5.006' form is preferred over '5.6.0', even though both
dnl are for perl version 5.6.0
dnl
dnl CREDITS
dnl
dnl     * This macro was written by Alan D. Salewksi <salewski AT att.net>

AC_DEFUN([ads_PROG_PERL], [
    req_perl_version="$1"
    if test -z "$req_perl_version"; then
        req_perl_version="5.005"
    fi
    AC_PATH_PROG(PERL, perl)
    if test -z "$PERL"; then
        AC_MSG_ERROR([perl not found])
    fi
    $PERL -e "require ${req_perl_version};" || {
        AC_MSG_ERROR([perl $req_perl_version or newer is required])
    }
])

