dnl -*- autoconf -*-

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
