dnl -*- autoconf -*-

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
