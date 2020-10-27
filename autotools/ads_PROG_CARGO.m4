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
dnl This macro contains an automatic dependency on the 'AC_PROG_SED'
dnl autoconf macro to set the $SED shell variable to the path of the
dnl configured 'sed' program used within the test.
dnl
dnl
dnl AUTHOR
dnl
dnl     * This macro was written by Alan D. Salewksi <ads AT salewski.email>

AC_DEFUN_ONCE([ads_PROG_CARGO], [

# start: [[ads_PROG_CARGO]]
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
    _ads_t_found_cargo_version=$("${CARGO_PROG}" --version | "${SED}" -e 's/^[[:space:]]*cargo[[:space:]]*//')
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
