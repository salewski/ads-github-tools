## Process this file with automake to produce Makefile.in   -*-Makefile-*-

## SPDX-FileCopyrightText: <text> © 2016, 2020 Alan D. Salewski <ads@salewski.email> </text>
## SPDX-License-Identifier: GPL-2.0-or-later

#SUBDIRS = src \
#          .

## Ensure that these files make it into the distribution source tarball
##
EXTRA_DIST =   \
    Cargo.lock \
    Cargo.toml \
    .cargo/config.toml

# We reference the Cargo.toml file in the builddir because some of our *.rs
# source files are generated. Cargo want all files for a package build to be
# in the same directory subtree, so we use the builddir for that, and
# symlink-in anything static that is needed from the source tree. (See
# AM_CONFIG_LINKS in our 'configure.ac' file.).
#
CARGO_MANIFEST_PATH = $(builddir)/Cargo.toml

# Integrate Cargo verbosity with the Automake silencing rules.
#
# The user can control the default value that will be used for "this"
# configured build tree by specifying either '--enable-silent-rules' or
# '--disable-silent-rules' at configure time. See 'configure --help'
#
# This recipe is a variation of one presented in the "Automake Silent Rules"
# section of the Autoconf manual (q.v.)
#
# Recall that AM_V (the "shadow variable" for V, as in 'make V=0' or 'make
# V=1') expands to whatever value the user has specified for 'V' on the make
# command line. If the user has not specified 'V=0' or 'V=1' explicitly, then
# AM_V will be empty, and we use the configure-time default.
#
# Recall, too, that AM_DEFAULT_V is always either 0 (for non-verbose mode) or
# 1 (for verbose mode, which is the Automake default). The value observed here
# also depends (possibly) on the package definition (if AM_SILENT_RULES is
# used), and whether '--enable-silent-rules' or '--disable-silent-rules' was
# used at configure time, as noted above.
#
# Note that we avoid defining my_cargo_maybe_verbose_0, which will cause any
# reference for that variable to expand to an empty value.
#
my_cargo_maybe_verbose   = $(my_cargo_maybe_verbose_@AM_V@)
my_cargo_maybe_verbose_  = $(my_cargo_maybe_verbose_@AM_DEFAULT_V@)
my_cargo_maybe_verbose_1 = --verbose

CARGO_OPTS_COMMON = \
    --manifest-path "$(CARGO_MANIFEST_PATH)" \
    $(my_cargo_maybe_verbose) \
    --offline --locked --frozen

INPUT_TEMPLATES = \
    src/main.rs.in

dist_noinst_DATA = $(INPUT_TEMPLATES)


# "static" sources
SSOURCES =
# "generated" sources (filtered here by do_subst)
#GSOURCES = $(INPUT_TEMPLATES:.in=-$(VERSION))
GSOURCES = $(INPUT_TEMPLATES:.in=)


# "static" scripts
SSCRIPTS =

# "generated" scripts
#
# (Our Rust "binary crates" are listed here as "scripts" to allow us to build
# them under our local control (generating the sources first, if necessary),
# but then leverage the Autotools machinery for install/uninstall. See
# bin_SCRIPTS note below).
#
GSCRIPTS = \
    $(builddir)/target/release/parse-netrc$(EXEEXT)


# CAREFUL: 'cargo clean' (invoked indirectly by our 'clean-local' target) will
#          fail if we yank the generated *.rs file(s) out from under
#          it. Better to remove via a clean-time target that depends on our
#          'cargo-clean' target to make sure 'cargo clean' gets run before we
#          try to delete the generated source file(s).
#
#CLEANFILES = $(GSOURCES) $(G1MANPAGES)
#CLEANFILES = $(GSOURCES)


# In the GNU Autotools, the SCRIPTS primary is used for any executable thing
# for which the Autotools were not directly involved with the compiling or
# linking (such as our Rust-based program(s) built by Cargo). We still rely on
# Automake to install/uninstall this for us, which allows us to avoid doing it
# manually.
#
# Note from the Automake manual (in the section "An Alternative Approach to
# Subdirectories"):
#
#     "By default an installable file specified in a subdirectory will have
#      its directory name stripped before installation."
#
# We are relying on that behavior. It is important here because we want our
# bin_SCRIPTS installed directly in '$(bindir)', not in '$(bindir)/some/subdir/path/'
#
#bin_SCRIPTS = $(SSCRIPTS) $(GSCRIPTS)
bin_SCRIPTS = $(GSCRIPTS)


@do_subst_command@

# Command for sed sanitizing the value of a var for use on the left side of a
# sed 's' (substitution) command.
#
@sed_slsanitize_command@


# Generated sources depend on Makefile so they will be rebuilt if $(VERSION)
# or other do_subst'ituted variables change.
#
$(GSOURCES): Makefile

$(GSCRIPTS): cargo-build


# Auto-make *-local targets
.PHONY: all-local check-local clean-local
all-local: cargo-build

check-local: cargo-test

clean-local: cargo-clean
	for fpath in $(GSOURCES); do \
	    "$(RM)" -f "$${fpath}" || exit 1 ;\
	done


# Note: We are relying on the 'config-profile' feature to honor our
#       .cargo/config.toml file(s). The 'config-profile' feature was
#       stabilized in Rust 1.43.0 (released 2020-04-23):
#
#           https://github.com/rust-lang/rust/blob/master/RELEASES.md#version-1430-2020-04-23
#           https://github.com/rust-lang/cargo/pull/7823
#
.PHONY: cargo-build-local
cargo-build-local: $(SSOURCES) $(GSOURCES)
	"$(CARGO_PROG)" build $(CARGO_OPTS_COMMON) \
	    --release


# CAREFUL: This is "*-check" in the sense of 'cargo check', not in the sense
#          of the Autotools 'check' target. We would avoid the overloading of
#          the term, but using a different target name here would just make it
#          more difficult to use.
.PHONY: cargo-check-local
cargo-check-local: $(SSOURCES) $(GSOURCES)
	"$(CARGO_PROG)" check $(CARGO_OPTS_COMMON)


# By default, cargo uses 'dev' profile for 'bin' crates. Currently (2020-10)
# there is no way to explicitly indicate the 'dev' profile, AFAIK, but just
# omitting the profile-related opts has the intended effect.
#
# Note that our *-devbuild artifacts are intended for use in-tree only, so DO
# NOT get added to bin_SCRIPTS or similar list that would cause them to get
# installed.
.PHONY: cargo-devbuild-local
cargo-devbuild-local: $(SSOURCES) $(GSOURCES)
	"$(CARGO_PROG)" build $(CARGO_OPTS_COMMON)


# Recall that 'cargo test' runs documentation tests by default.
.PHONY: cargo-test-local
cargo-test-local:
	"$(CARGO_PROG)" test $(CARGO_OPTS_COMMON)


# Causes Cargo to run only the documentation tests.
.PHONY: cargo-test-doc-local
cargo-test-doc-local:
	"$(CARGO_PROG)" test --doc $(CARGO_OPTS_COMMON)


# cargo-clean(1) complains when source files are missing, and there is no
# apparent way to tell it to chill. Since we are generating (at least some of)
# the source files, that introduces both temporal and sequencing aspects into
# the build. For example, a 'make distcheck' followed by a 'make distclean'
# would fail because the distcheck target would have caused the generated
# source files to be deleted. It would be silly to re-generate the source
# files just to keep cargo-clean(1) from complaining, so we instead make its
# invocation conditional on the presence of /all/ of the generated source
# files.
#
.PHONY: cargo-clean-local
cargo-clean-local:
	one_or_more_missing=false ;\
	for fpath in $(GSOURCES); do \
	    test -e "$${fpath}" && continue ;\
	    : cargo-clean-local: skipping cargo-build b/c one or more generated source files is not present ;\
	    exit 0  ;\
	done ;\
	"$(CARGO_PROG)" clean $(CARGO_OPTS_COMMON)


# Rule to build generated sources from corresponding input templates.
#
# Uses chmod a-w to prevent people from editing the wrong file by accident.
#
# Note that the script depends on the naming convention:
#
# Target:
#
#     path/to/<SOURCE_FILE_BASE>
#
# is generated from:
#
#     path/to/<SOURCE_FILE_BASE>.in
#
$(GSOURCES): %: %.in
	set -ex ;\
	rm -f "$@" "$@.tmp" ;\
	_t_base="$@"        ;\
	$(MKDIR_P) "$$("$(DIRNAME_PROG)" "$@.tmp")" ;\
	$(do_subst) "$(srcdir)/$${_t_base}.in" > "$@.tmp" ;\
	mv "$@.tmp" "$@"    ;\
	chmod a-w "$@"      ;\
	chmod a+r "$@"
