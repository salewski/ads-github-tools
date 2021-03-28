# ads-github-tools

## Herds octocats so you can fork your brains out.


# Overview

This is the README.md file for the `'ads-github-tools'` project.

The `ads-github-tools` project provides command line tools for managing a
large number of GitHub repositories, motivated by the following two related
use cases:

    1. When you work on multiple computers, keeping your local clones of the
       repos in sync can be a chore.
       
    2. Similarly, when you have a large number of GitHub repos that are mostly
       forks of other repos, keeping your forks in sync with the upstream
       changes can be a chore.

Enter the `ads-github-tools`.

The 'ads-github-tools' project web site is:

   * https://salewski.github.io/ads-github-tools/

The latest version of the project is `0.3.3` (released 2021-03-27), and can
be downloaded from:

   * https://salewski.github.io/ads-github-tools/downloads/ads-github-tools-0.3.3.tar.gz
   * https://salewski.github.io/ads-github-tools/downloads/ads-github-tools-0.3.3.tar.gz.SHA-1
   * https://salewski.github.io/ads-github-tools/downloads/ads-github-tools-0.3.3.tar.gz.SHA-256
   * https://salewski.github.io/ads-github-tools/downloads/ads-github-tools-0.3.3.tar.gz.SHA3-256

See the [NEWS] file for changes for this release.
    
Older releases are available from the project's downloads page:

   * https://salewski.github.io/ads-github-tools/downloads/


# Usage

Typical usage involves ensuring there is an updated cache, and then just
invoking a couple of commands.

The cache is updated like this:
```
    $ ads-github-cache -v --update
```
First time users will want to update the cache prior to running any of the
other commands. It may take a while to poplute the cache the first time
(especially if you have a large number of GitHub repos), but updating it
thereafer is done conditionally and on an as-needed basis. Note that the only
objects cached are those used by the various utilities in the
C<ads-github-tools>; it does not cache any data that is not used.

The cache is provided in order to avoid unnecessary network round trips to the
GitHub API servers. The cache storage is specific to the GitHub user. A Unix
system user may have multiple GitHub accounts (say, work and personal); the
cached data for those GitHub users would be stored separately.

Regular users would probably just run the above cache update command (say,
once or twice a day) from a cron job (or similar). That way the cached data is
already available when you need it.

With the cached data in hand, the author typcially runs these two commands
once daily:

```
    $ ads-github-fetch-all-upstreams -v -c

    $ ads-github-merge-all-upstreams -v -k -p
```

Many users would prefer to run those commands from a crontab (or similar); the
author runs them manually because he's actively hacking on the tools and wants
to inspect the output.

The following invocation is also handy for creating local clones of recently
forked GitHub repos:
```
    $ ads-github-fetch-all-upstreams -m
```
That invocation clones all of a user's GitHub repos for which there is no
working directory beneath the current directory. It can be thought of as
creating clones of "all the new stuff (and /just/ the new stuff)"; it operates
much more quickly than invocations that operate on all of a user's GitHub
repos (assuming only a minority of them are "missing", which is the common
case). Note that the `'-m'` (`--missing-only`) option was introduced in the
version of `ads-github-fetch-all-upstreams` released with `ads-github-tools-0.2.0`.

At the moment (2021-03-27) there are nine tools:

* `ads-github-cache` - Manipulate the `ads-github-tools` cache. Mainly used to
  keep relevant GitHub data at-the-ready for use by the other utilities, but
  will also be of interest to software developers working with the GitHub v3
  API. Because the tool can hide the paging necessary to obtain all of the
  items for a given resource, the following is a very fast way to get all of
  data for all of the user's repo:
  ```
    $ ads-github-cache --get-cached '/user/repos' | jq '.'
  ```

* `ads-github-whoami` - Show the currently authenticated GitHub user. This
  program similar in spirit to the Unix `whoami(1)` and `id(1)` commands, but
  shows information about the authenticated GitHub user (as understood by the
  GitHub API). Obtains its direct information via the GitHub v3 API call:
  ```
      GET /user
  ```
  Default output is plain text for interactive command line use, but we
  provide a knob to have the raw JSON response emitted, as well. The
  `ads-github-whoami` command was added in `ads-github-tools-0.3.1`.

* `ads-github-normalize-url` - produces a "normalized" view of a given URL,
  suitable for use in generating an ID. Currently is a quick 'n dirty
  implementation optimized for this sole purpose, so there's no guarantee that
  the normalized variation of the URL will actually work

* `ads-github-hash-url` - similar in spirit to `git-hash-object(1)`, this tool
  takes a (presumably normalized) URL and emits a checksum for it. Currently
  uses the SHA-3 256-bit algorithm variant.
  
* `ads-github-show-rate-limits` - Show user's GitHub API rate limits ("core"
  and "search").

* `ads-github-fetch-all-upstreams` - Operates on the working directories of a
  collection of GitHub-hosted git repositories. The user can specify one or
  more repositories explicitly to restrict operations to just those
  repos. Each that is found with an 'upstream' remote defined will have
  `git fetch upstream` invoked in it.
  
  * With the `--clone-if-missing` option, any of the user's GitHub repos for
    which there is not a git working directory beneath the current location
    will be cloned (using the `git-hub` tool's `clone` operation, which sets
    up the 'upstream' remote if the repo is a fork).

  * There's also an `--upstream-remote-if-missing` option that will add the
    'upstream' remote on existing project working directories that do not have
    it (only if the project is a fork of another project, of course).
    
  * `ads-github-tools-0.2.0` added the `--missing-only` option (which implies
    `--clone-if-missing`). The `--missing-only` option limits the program's
    activity to operating on /only/ the user's "missing" GitHub repos. It can
    be thought of as creating clones of "all the new stuff (and /just/ the
    new stuff)"; it operates much more quickly than invocations that operate
    on all of a user's GitHub repos (assuming only a minority of them are
    "missing", which is the common case).
    
* `ads-github-merge-all-upstreams` - Operates on the working directories of a
  collection of GitHub-hosted git repositories. Each that is found with both
  'origin' and 'upstream' remotes defined will have
  `git merge --ff-only upstream/<DEFAULT_BRANCH_NAME>` invoked in it. The user
  can specify one or more repositories explicitly to restrict operations to
  just those repos. The program is careful to sanity check the local
  repository before attempting any operations on it. Also, it will skip any
  repository for which the git index has any changes recorded. Will
  (temporarily) check out the default branch before merging (if the working
  directory happens to have some other branch checked out); will restore the
  originally checked out branch when done if the temporary switch was
  necessary.

  * With one `--push` option, will invoke 'git push origin <DEFAULT_BRANCH_NAME>'
    for each repo that has changes merged into it during the program invocation.

  * With two `--push` options, will invoke 'git push origin
    <DEFAULT_BRANCH_NAME>' for each repo that is not being skipped over for
    some other reason (e.g. local changes in the working directory),
    regardless of whether changes are merged into it during the program
    invocation. This is useful for pushing changes that were merged but not
    pushed during earlier runs of the program invoked without the `--push`
    option.

* `ads-github-repo-create` - Creates a new GitHub repo with a given name and
  attributes (description, default branch, etc.). Newly created repo is empty
  by default (suitable for importing existing Git repos into GitHub), but can
  optionally be auto-initialized (more suitable for projects being started
  from scratch). The `ads-github-repo-create` command was added in
  `ads-github-tools-0.3.1`.

* `parse-netrc` - Parses the user's `~/.netrc` file to obtain the first
  matching record by host machine name (and optionally by user login
  name). This is used by `ads-github-cache` to determine the name of the
  in-effect GitHub user account, using the approach that emulates what
  `curl(1)` does. This allows for entirely offline cache operations against
  the user-specific cache. The tool name does not start with the
  `'ads-github-'` prefix because it is being considered for extraction into a
  small stand-alone project.


See the "Prerequisites" section below for other programs that must be
installed and configured on your system before you can install the
`'ads-github-tools'` package.

See the [BUGS] file for information on reporting bugs.

See the [INSTALL] file for installation instructions.

See the [HACKING] file for developer build instructions and the like.

See the [NEWS] file for changes for this release, and a running list of
changes from previous releases. Any incompatibilities with previous versions
will be noted in the `'NEWS'` file.


# Prerequisites

The tools provided by the `'ads-github-tools'` project are intended to be
built and run on Unix and Unix-like systems, so expect a standard set of
utilities (`cat`, `sed`, `awk`, `rm`, ...) to be present. These utilities are
not explicitly listed below as prerequisites as they should be present on any
modern Unix or GNU/Linux system (or in Cygwin, if you happen to be running on
MS Windows).

The `parse-netrc` program is implemented in Rust, and requires that the
`rustc` compiler and `cargo` programs be installed. They are distributed
together, so if you have one you likely have the other, as well. On Debian
based systems:
```
    # apt-get -u install rustc cargo
```

Many of the programs provided by `'ads-github-tools'` are implemented in Bash
(a Bourne shell derivative). The 'ads-github-tools' project was developed and
tested using Bash version 5.0.3(1)-release, as shipped by Debian. It uses
associative arrays which were added in Bash 4.0, so you'll need a 4.x version
or newer; the `'configure'` script will check for this and exit with an error
message if a new enough version of Bash is not found. The author would
appreciate hearing about any successes or failures with other versions of
Bash. In the unlikely event that your system does not already have bash
installed, it can be obtained from the project's site:

   * http://www.gnu.org/software/bash/

On a Debian system (including derivatives, such as Ubuntu), you can install
the program via:
```
    # apt-get install bash
```

or (for a statically linked version):
```
    # apt-get install bash-static
```

Another required tool is [git-hub][GIT_HUB], which provides a command line
interface for interacting with a GitHub repository. The tool provides a
'`clone`' operation that, for GitHub forked repos, establishes an 'upstream'
remote that points to the upstream source of the fork (which is part of the
typical arrangement when tracking changes to an upstream project over time: an
'origin' remote points to your own fork of the project on GitHub, and an
'upstream' remote points to the upstream project's tree on GitHub). The
`'git-hub'` tool is used by our `'ads-github-fetch-all-upstreams'` tool when
cloning repositories.

On a Debian system (including derivatives, such as Ubuntu) you can install the
`'git-hub'` program via:
```
    # apt-get install git-hub
```

Other users can obtain source release tarballs from that project's releases page:

   * https://github.com/sociomantic-tsunami/git-hub/releases
   
or you can build from that project's latest sources from its GitHub project
page:

   * https://github.com/sociomantic-tsunami/git-hub


# Build instructions

The `ads-github-tools` project is distributed as a standard GNU
autotools-based package.

Obtain the prerequisites as described above, and then you are ready to
build. From an unpacked release tarball, run:
```
    $ ./configure
    $ make
    $ make check
    $ make install
```

By default `make install` will install into subdirectories of `/usr/local`. To
change where things will get installed, use `./configure --prefix=/some/path`.


# Future directions

The `ads-github-tools-0.3.2` release (October 2020) introduced the foundations
for the long-wanted caching system. It delivers on the ability to
conditionally retrieve objects "through the cache" using `ETag:` and
`If-None-Match:` to pull full objects over the network only when necessary. It
also delivers on the goal of being easy to use from shell scripts or even in
an interactive shell.

Note that conditionally fetching objects as described also has the benefit of
avoiding incurring unnecessary hits against the user's GitHub API rate
limit. (Not sure where you stand? Try `ads-github-show-rate-limits -h` to find
out!)

At the moment, the caching foundation is in place, and the
`ads-github-fetch-all-upstreams` tool uses it to good effect. But at the
moment it is the *only* tool that does so. Others will be enhanced, as well,
in upcoming releases.

My earlier thinking was that there will be three levels of tools:
 
1. low-level tools that store and retrieve objects from the cache, and related
   * `ads-github-cache update` (similar in spirit to `apt-get update` and `apt-file update`)
   * `ads-github-cache put KEY [VALUE]`
   * `ads-github-cache get KEY`
   * `ads-github-normalize-url`
   * `ads-github-hash-url`
   
   In the above list, '`KEY`' is likey a "normalized" url, or perhaps just
   _any_ url (and the tools would normalize the url behind the scenes to
   produce the "key").

2. mid-level tools that make use of the caching tools
   * `ads-github-user-repos [--owner] [--repo] [--per-page=N] [--page=N]`
   * `ads-github-org-repos [--org] [--repo]...`
   * `ads-github-repos [--list-tags] [--list-branches] ...`
   * `...`

3. high-level tools the build upon the first two levels above
   * `ads-github-show-rate-limits`
   * `ads-github-fetch-all-upstreams`
   * `ads-github-merge-all-upstreams`
   * `...`

That does not seem like a terrible arrangement, but we have learned that there
is value in allowing the high-level tools access the low-level cache directly.


# License

GPLv2+: GNU GPL version 2 or later <http://gnu.org/licenses/gpl.html>

Unless otherwise stated by a different license notice in a particular file,
all files in the `ads-github-tools' project are made available under the GNU
GPL version 2, or (at your option) any later version.

See the [COPYING] file for the full license.

Copyright (C) 2016, 2017, 2019, 2020, 2021 Alan D. Salewski <ads@salewski.email>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.



[BUGS]:         https://github.com/salewski/ads-github-tools/blob/master/BUGS
[COPYING]:      https://github.com/salewski/ads-github-tools/blob/master/COPYING
[HACKING]:      https://github.com/salewski/ads-github-tools/blob/master/HACKING
[INSTALL]:      https://github.com/salewski/ads-github-tools/blob/master/INSTALL
[NEWS]:         https://github.com/salewski/ads-github-tools/blob/master/NEWS
[GIT_HUB]:      https://github.com/sociomantic-tsunami/git-hub
