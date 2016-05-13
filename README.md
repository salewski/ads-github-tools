# ads-github-tools
For now, just a scratch pad while I get familiar with the GitHub v3 API.

At the moment (2016-05-09) there are three tools:

* `ads-github-normalize-url` - produces a "normalized" view of a given URL,
  suitable for use in generating an ID. Currently is a quick 'n dirty
  implementation optimized for this sole purpose, so there's no guarantee that
  the normalized variation of the URL will actually work

* `ads-github-hash-url` - similar in spirit to `git-hash-object(1)`, this tool
  takes a (presumably normalized) URL and emits a checksum for it. Currently
  uses the SHA-3 512-bit algorithm variant.

* `ads-github-fetch-all-upstreams` - Operates on the working directories of a
  collection of GitHub-hosted git repositories. Each that is found with an
  'upstream' remote defined will have `git fetch upstream` invoked in it.
  
** With the `--clone-if-missing` option, any of the user's GitHub repos for
   which there is not a git working directory beneath the current location
   will be cloned (using the `git-hub` tool's `clone` operation, which sets up
   the 'upstream' remote if the repo is a fork).

** There's also a `--upstream-remote-if-missing` option that will add the
   'upstream' remote on existing project working directories that do not have
   it (only if the project is a fork of another project, of course).

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

2. mid-level tools that make use of the caching tools
   * `ads-github-user-repos [--owner] [--repo] [--per-page=N] [--page=N]`
   * `ads-github-org-repos [--org] [--repo]...`
   * `ads-github-repos [--list-tags] [--list-branches] ...`
   * `...`

3. high-level tools the build upon the first two levels above
   * `ads-github-fetch-all-upstreams`
   * `ads-github-merge-all-upstreams`
   * `...`
