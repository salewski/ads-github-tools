## Process this file with automake to produce Makefile.in   -*-Makefile-*-

noinst_DATA = adsgithubtools-perl5-inc-begin-block.snippet

## Ensure that our input file makes it into the distribution tarball
dist_noinst_DATA = adsgithubtools-perl5-inc-begin-block.snippet.in

@do_subst_command@

adsgithubtools-perl5-inc-begin-block.snippet: adsgithubtools-perl5-inc-begin-block.snippet.in

# This file depends on Makefile so it will be rebuilt if $(VERSION) or other
# do_subst'ituted variables change. Use chmod a-w to prevent people from
# editing the wrong file by accident.
#
adsgithubtools-perl5-inc-begin-block.snippet: Makefile
	rm -f $@ $@.tmp
	$(do_subst) "$(srcdir)/$@.in" > "$@.tmp"
	chmod a-w "$@.tmp"
	mv -f "$@.tmp" "$@"

CLEANFILES = adsgithubtools-perl5-inc-begin-block.snippet
