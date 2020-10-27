## Process this file with automake to produce Makefile.in   -*-Makefile-*-

## SPDX-FileCopyrightText: <text> © 2016, 2020 Alan D. Salewski <ads@salewski.email> </text>
## SPDX-License-Identifier: GPL-2.0-or-later

# Each subdir beneath here is a Rust "package". Each package contains one or
# more "binary" crates (executable programs).
#
SUBDIRS = parse-netrc \
          .

# Notes on the Rust build tooling and how we integrate it here.
#
# In the Rust ecosystem, code is organized as follows:
#
#     modules -- Organizational construct to hierarchically arrange code in
#                logical units.
#             -- Provide namespacing to control scope and visibility.
#             -- Several modules may exist within a single source file,
#                or be spread out across multiple files.
#             -- When spread across files, the module hierarchy is (at least
#                partially) reflected in the filesystem hierarchy.
#             -- Modules may contain other modules.
#
#     crate   -- An executable binary program, or a library.
#             -- The fundamental compilation unit in Rust.
#             -- A single crate is composed of modules.
#             -- A crate always has an implicit "root module", even if no
#                modules are explicitly declared. In an executable
#                (a.k.a. "binary crate"), this is the 'main.rs' file; in a
#                "library crate" this is the 'lib.rs' file.
#             -- All modules within a crate are compiled together as a unit;
#                individual modules ARE NOT compiled individually, even if
#                they exist in separate source files.
#
#     package -- One or more crates (that presumably provide a set of related
#                functionality).
#             -- Contains a 'Cargo.toml' file (a.k.a. the "manifest file")
#                that describes how the group of related crates are to be
#                built.
#             -- Are strict rules about what a package can contain:
#                    * A package must contain zero or one library crates
#                    * It may contain an arbitrary number of binary crates
#                    * A package must contain at least one crate, either
#                      binary or a library.
#             -- Cargo builds all crates within a given package.
#
# The cargo(1) tool is the standard dependency management and build
# orchestration tool that comes with Rust. We integrate it into our build as
# described below.
#
# Under its default mode of operation, Cargo would connect to network
# resources (crates.io; others, too, if so configured) to obtain dependencies
# and check for updates. (Yes, I'm glossing over a lot of details here.)
#
# We want our build to work without needing network access. Toward this end,
# the developer "vendors" the dependencies (both direct deps and transitive
# deps) in the source tree under:
#
#     ${top_srcdir}/src/third-party/cargo-vendored/
#
# There is a 'cargo-vendor-update' Makefile target defined in the top-level
# Makefile.am file that is aware of all the 'Cargo.toml' package files in the
# source tree.
#
# During development, the author can run that target after adding (in a
# 'Cargo.toml' file) new dependencies to a given Rust package, or after
# updating the version numbers for existing deps. The Makefile rule uses the
# cargo-vendor(1) subcommand to download any deps not already present in the
# vendored subdirectory. The pristine dependencies are checked into source
# control (git) along with the project sources, and are distributed in the
# source tarball artifacts of the current project.
#
# The end result is that an end user installing the package will need to have
# only the 'rustc' compiler installed and the 'cargo' build tool (which is
# shipped with rustc, so that should not be a problem). Everything else needed
# to build the Rust source code is contained in the source tarball.
#
# This practice of "vendoring" is an experiment here. We are intersted in
# avoiding network connectivity during normal builds. Having the third-party
# deps in-tree also helps ensure repeatable builds (using the exact same
# versions of the deps that were tested during development), and also acts as
# an insurance policy against any of the deps disappearing from the Internet
# (which happens).
#
# Cargo integration with GNU Autotools
# ------------------------------------
# The 'cargo' operations ('build', 'run', etc.) all pertain to a single Rust
# "package" (one or more related crates). The build definition for that
# package comes from a package-specific 'Cargo.toml' file. The 'Cargo.toml'
# file contains metadata about the package (name, version, various URLs, and
# dependencies).
#
# Cargo is also influenced by '.cargo/config.toml' files. Among other things,
# these files control the type and location of the artifact repositories that
# Cargo will attempt to contact to obtain dependency artifacts. Cargo will
# check for '.cargo/config.toml' files in the package-specific directory, all
# its parent directories, and a default location (~/.cargo/config.toml); it
# will merge these definitions together, with those files found "closer" to
# the package-specific directory having higher precedence.
#
# In the case of the current project, each Cargo package directory contains a
# relative .cargo/config.toml with commented out example settings. There is
# also a '.cargo/config.toml' file that exists relative to the project's
# ${top_srcdir}; that file contains the configuration that tells Cargo to use
# our vendored sources from the in-tree location rather than obtain them from
# the network.
#
# At configure time, we check for 'cargo' and 'rustc' dependencies, and
# generate the '.cargo/config.toml' files.
#
# At build time, the normal 'make all' build target invokes 'cargo' as needed
# to build all of the Rust "packages" in the tree.
#
# Our 'make install' target takes care of copying files into the correct
# locations. We do not use the Rust/Cargo-specific cargo-install(1), or
# similar; we treat those as developer-focused tools. Instead, we tell the
# autotools which files are which (programs, manpages, etc.) and have those
# installed in the normal way.
#
# Our 'make clean' target invokes 'cargo clean', etc.
#
# Once the project has been configured, developers are free to invoke the
# high-level operations through 'make' or invoke 'cargo' directly while
# working on a given package. Neither approach precludes the other; sometimes
# one or the other will be the more convenient interface, depending on the
# task at hand. Think of the GNU Autotools as higher-level project
# orchestration, and Cargo as one-specific build tool that participates in
# that orchestration.
#
# One thing to be aware of is that the make-based targets (with the single
# exception of the 'cargo-vendor-update' target mentioned above) all use Cargo
# command line flags to avoid accessing the network. We do that in preference
# to setting 'offline = true' in the top-level '.cargo/config.toml' file
# because it is intended as the main end-user experience. Developers working
# on the codebase, however, would likely be inconvenienced by such an
# option. The trade-off, of course, is that developers invoking 'cargo'
# directly will need to remember to provide the '--offline' option themselves,
# when needed.
