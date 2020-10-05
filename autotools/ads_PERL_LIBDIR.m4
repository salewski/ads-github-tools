dnl -*- autoconf -*-
dnl SPDX-FileCopyrightText: <text> © 2016, 2020 Alan D. Salewski <ads@salewski.email> </text>
dnl SPDX-License-Identifier: GPL-2.0-or-later
dnl
dnl This macro provides for a new 'configure' option:
dnl
dnl     --with-perl-libdir=DIR
dnl
dnl which provides the following semantics:
dnl
dnl     --without-perl-libdir AKA --with-perl-libdir=no uses $pkglibdir (the default).
dnl     --with-perl-libdir AKA --with-perl-libdir=yes uses 'perl -V:installsitelib'.
dnl     --with-perl-libdir=DIR uses specified DIR
dnl
dnl This macro provides "autoconfiscated" software packages with a means of
dnl installing Perl library modules in a way that is consistent with other
dnl packages that use the GNU autotools, yet also allows perl modules to be
dnl installed like CPAN modules.
dnl
dnl Dependencies:
dnl =============
dnl
dnl This macro expects that the shell variables $SED and $PERL are set and
dnl that their values are the paths to the 'sed' and 'perl' executables.
dnl
dnl The macro provides the 'PERL_LIBDIR' automake variable to indicate where
dnl perl library modules should be installed. It also provides the automake
dnl conditional 'USING_PERL_INSTALLSITELIB'. See below for details.
dnl
dnl The default behavior of this macro is to set up PERL_LIBDIR to install
dnl perl modules in $pkglibdir; this is to make it consistent with other
dnl automake macros in that the '--prefix=DIR' configure option is respected.
dnl The downside to this default behavior is that Perl scripts that need to
dnl access the installed modules may need to take special measures (add
dnl a 'use lib' pragma or manipulate @INC directly) to be able to find the
dnl modules; see the 'USING_PERL_INSTALLSITELIB' automake conditional below
dnl for one tool that may be used to handle this condition at configure time.
dnl The default behavior is what you get when the '--with-perl-libdir' option
dnl is not passed to configure, or when it is passed in the following forms:
dnl
dnl     --with-perl-libdir=no
dnl
dnl     --without-perl-libdir
dnl
dnl
dnl When specified as
dnl
dnl     --with-perl-libdir
dnl
dnl or
dnl
dnl     --with-perl-libdir=yes
dnl
dnl the macro will determine where to install the perl modules by asking the
dnl perl interpreter where it will look for installed site libraries. This is
dnl how CPAN user's expect to be able to install Perl modules (that is, the
dnl installation procedure ask the existing Perl installation where it will be
dnl able to find installed modules, and then installs the modules
dnl accordingly), and would be the default behavior except for the fact that
dnl it ignores the '--prefix=DIR' configure option (when setting PERL_LIBDIR),
dnl and could therefore be destructive if the user was not expecting that.
dnl Packages that use this macro may wish to recommend this form of
dnl '--with-perl-libdir' to user's in a README or INSTALL file. This
dnl installation method is accomplished by extracting the directory path from
dnl the output of the command:
dnl
dnl     $ perl -V:installsitelib
dnl 
dnl The third and final way to use the '--with-perl-libdir' configure option
dnl is like this:
dnl
dnl     --with-perl-libdir=DIR
dnl
dnl When run this way, PERL_LIBDIR simply gets set to the value of DIR.
dnl
dnl
dnl To use this macro, simply put the following in your configure.in:
dnl
dnl     ads_PERL_LIBDIR
dnl
dnl This macro sets up the shell variable:
dnl
dnl     $PERL_LIBDIR, which will contain a directory name at the
dnl               end of the macro
dnl
dnl This macro sets up the automake var @PERL_LIBDIR@ with the value in the
dnl $PERL_LIBDIR shell variable. This automake var is provided for use in
dnl Makefile.am files.
dnl
dnl This macro also sets up the automake conditional 'USING_PERL_INSTALLSITELIB'
dnl to indicate whether or not the value of PERL_LIBIDR was set using the value
dnl returned from the perl interpreter for 'installsitelib'.
dnl
dnl
dnl CREDITS
dnl
dnl     * This macro was written by Alan D. Salewski <salewski AT att.net>,
dnl       using code extracted from earlier efforts.
dnl
dnl     * The name and semantics of the '--with-perl-libdir' configure option are
dnl       an immense improvement over the original effort; these were suggested
dnl       by Ralph Schleicher <ralph.schleicher AT lli.liebherr.com>
dnl

AC_DEFUN([ads_PERL_LIBDIR], [

    AC_REQUIRE([ads_PROG_PERL])

    AC_ARG_WITH(perl-libdir,

     changequote(<<, >>)dnl
<<  --with-perl-libdir[=ARG]
                          where to install perl modules [ARG=no, uses \$pgklibdir]>>dnl
     changequote([, ])dnl
    ,
    [ # AC_ARG_WITH: option if given
    AC_MSG_CHECKING(for where to install perl modules)
    # each condition sets 'using_perlsysdirs' to either "yes" or "no", and
    # sets 'PERL_LIBDIR' to a non-empty DIR value
    if test "$withval" = "no"; then
        # --with-perl-libdir=no AKA --without-perl-libdir uses $pkglibdir (dflt)
        using_perlsysdirs="no"

        # note that we're constructing pkglibdir as automake would, but not
        # using the shell variable directly; this is because automake (at least
        # as of 1.4-p5) only defines '$pkglibdir' in the generated Makefile.in
        # files, but not in 'configure.in'. We need it defined in configure
        # in order for the assignment to PERL_LIBDIR to work.
        PERL_LIBDIR=${libdir}/${PACKAGE}
        AC_MSG_RESULT(\$pkglibdir: ${libdir}/${PACKAGE})
    elif test -z "$withval" || \
         test "$withval" = "yes"; then
        # --with-perl-libdir AKA --with-perl-libdir=yes uses 'perl -V:installsitelib'
        using_perlsysdirs="yes"
        AC_MSG_RESULT(Perl's "installsitelib")

        AC_MSG_CHECKING(for perl installsitelib dir)
        PERL_LIBDIR=`$PERL '-V:installsitelib*' | \
                     $SED -e "s/^installsitelib=[']\(.*\)[']\$/\1/"`
        if test "${PERL_LIBDIR}" = "undef" || \
           test "${PERL_LIBDIR}X" = "X"; then
            tmp_valid_opts="`printf "\t"`"`$PERL -le 'print join $/."\t", @INC'`
            AC_MSG_ERROR([
    Perl\'s installsitelib is not defined, and this is the preferred
    location in which to install the perl libraries included with ${PACKAGE}.
    Of course, you may specify that the perl libraries be installed anywhere
    perl will find them (anywhere in the @INC array), but you must explicitely
    request where, as this is non-standard. You may specify where to place them
    by using the \'--with-perl-libdir=DIR\' option to \'configure\'. All of the
    following are in @INC:
$tmp_valid_opts
])
        fi
        AC_MSG_RESULT($PERL_LIBDIR)

    else
        # --with-perl-libdir=DIR, use user-specified directory
        using_perlsysdirs="no"
        PERL_LIBDIR="${withval}"
        AC_MSG_RESULT(specified dir: $withval)
        dnl DEBUG: FIXME: warn the user if dir not in @INC?
    fi
    ],
    [ # AC_ARG_WITH: option if not given, same as --without-perl-libdir
    AC_MSG_CHECKING(for where to install perl modules)

    # note that we're constructing pkglibdir as automake would, but not
    # using the shell variable directly; this is because automake (at least
    # as of 1.4-p5) only defines '$pkglibdir' in the generated Makefile.in
    # files, but not in 'configure.in'. We need it defined in configure
    # in order for the assignment to PERL_LIBDIR to work.
    PERL_LIBDIR=${libdir}/${PACKAGE}
    AC_MSG_RESULT(\$pkglibdir: ${libdir}/${PACKAGE})
    ])dnl end of AC_ARG_WITH(perl-libdir) macro

    AC_SUBST(PERL_LIBDIR)
    dnl register a conditional for use in Makefile.am files
    AM_CONDITIONAL(USING_PERL_INSTALLSITELIB, test x$using_perlsysdirs = x$yes)
])
