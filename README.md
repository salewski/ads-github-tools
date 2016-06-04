# ads-github-tools

These tools are still in their early days, having been under casual
development only since the end of April 2016. Nevertheless, the tools that
exists currently provide a useful core and are used by the author on a daily
basis.

The `ads-github-tools` project provides command line tools for managing a
large number of GitHub repositories, motivated by the following two related
use cases:

    1. When you work on multiple computers, keeping your local clones of the
       repos in synch can be a chore.
       
    2. Similarly, when you have a large number of GitHub repos that are mostly
       forks of other repos, keeping your forks in synch with the upstream
       changes can be a chore.

Enter the `ads-github-tools`.

Typical invocation involves only one or two commands. The author typcially
runs these three commands once daily:

```
    $ ads-github-fetch-all-upstreams -v -c

    $ ads-github-merge-all-upstreams -v -k

    $ ads-github-merge-all-upstreams -v -k --push
```

Many users would prefer to run those commands from a crontab (or similar), in
which case the second invocation could be omitted; the author runs them
manually because he's actively hacking on the tools and wants to inspect the
output.

At the moment (2016-06-03) there are five tools:

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

  * With the `--push` option, will invoke 'git push origin <DEFAULT_BRANCH_NAME>'
    for each repo.

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
