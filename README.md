# ads-github-tools

## Herds octocats so you can fork your brains out.


# Overview

This is the README.md file for the `'ads-github-tools'` project.

The `ads-github-tools` project provides command line tools for managing a
large number of GitHub repositories, motivated by the following two related
use cases:

    1. When you work on multiple computers, keeping your local clones of the
       repos in synch can be a chore.
       
    2. Similarly, when you have a large number of GitHub repos that are mostly
       forks of other repos, keeping your forks in synch with the upstream
       changes can be a chore.

Enter the `ads-github-tools`.

The 'ads-github-tools' project web site is:

   * https://salewski.github.io/ads-github-tools/

The latest version of the project is `0.1.1`, and can be downloaded from:

   * https://salewski.github.io/ads-github-tools/downloads/ads-github-tools-0.1.1.tar.gz
   * https://salewski.github.io/ads-github-tools/downloads/ads-github-tools-0.1.1.tar.gz.SHA-1
   * https://salewski.github.io/ads-github-tools/downloads/ads-github-tools-0.1.1.tar.gz.SHA-256
   * https://salewski.github.io/ads-github-tools/downloads/ads-github-tools-0.1.1.tar.gz.SHA3-256
    
Older releases are available from the project's downloads page:

   * https://salewski.github.io/ads-github-tools/downloads/


# Usage

Typical invocation involves only one or two commands. The author typcially
runs these two commands once daily:

```
    $ ads-github-fetch-all-upstreams -v -c

    $ ads-github-merge-all-upstreams -v -k -p
```

Many users would prefer to run those commands from a crontab (or similar); the
author runs them manually because he's actively hacking on the tools and wants
to inspect the output.

At the moment (2016-08-20) there are five tools:

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

Many of the programs provided by `'ads-github-tools'` are implemented in Bash
(a Bourne shell derivative). The 'ads-github-tools' project was developed and
tested using Bash version 4.3.30. It uses associative arrays which were added
in Bash 4.0, so you'll need a 4.x version or newer; the `'configure'` script
will check for this and exit with an error message if a new enough version of
Bash is not found. The author would appreciate hearing about any successes or
failures with other versions of Bash. In the unlikely event that your system
does not already have bash installed, it can be obtained from the project's
site:

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
`'git-hub'` to via:
```
    # apt-get install git-hub
```

Other users can obtain source release tarballs from that project's releases page:

   * https://github.com/sociomantic-tsunami/git-hub/releases
   
or you can build from that project's latest sources from its GitHub project
page:

   * https://github.com/sociomantic-tsunami/git-hub/releases


# Future directions

I'm working on sketching out a caching system for results from the GitHub API
with the intent of making it easy to use from shell scripts or similar. The
first two scripts noted above are a step in that direction.

Once the caching implementation is functional, the
`ads-github-fetch-all-upstreams` will be modified to use it, perhaps via a set
of intermediary tools. These tools will make use of the `ETag:`,
`Last-Modified:`, and `If-Modified-Since:` HTTP headers both to avoid
incurring unnecessary hits against the user's GitHub API rate limit and to cut
down on unnecessary retrieval of the same data over and over.

My current thinking is that there will be three levels of tools:
 
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


# License

GPLv2+: GNU GPL version 2 or later <http://gnu.org/licenses/gpl.html>

Unless otherwise stated by a different license notice in a particular file,
all files in the `ads-github-tools' project are made available under the GNU
GPL version 2, or (at your option) any later version.

See the [COPYING] file for the full license.

Copyright (C) 2016, 2017 Alan D. Salewski <salewski@att.net>

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
