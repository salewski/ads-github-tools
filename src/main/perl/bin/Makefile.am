## Process this file with automake to produce Makefile.in   -*-Makefile-*-

## SPDX-FileCopyrightText: <text> © 2016, 2020 Alan D. Salewski <ads@salewski.email> </text>
## SPDX-License-Identifier: GPL-2.0-or-later

#SUBDIRS =  \
#          .

INPUT_TEMPLATES = \
    ads-github-normalize-url.in

# "static" scripts
SSCRIPTS =
# "generated" scripts (filtered here by do_subst)
#GSCRIPTS = $(INPUT_TEMPLATES:.in=-$(VERSION))
GSCRIPTS = $(INPUT_TEMPLATES:.in=)


# "static" section 1 man pages
S1MANPAGES =
# "generated" section 1 man pages
G1MANPAGES = $(INPUT_TEMPLATES:.in=.1)


bin_SCRIPTS = $(SSCRIPTS) $(GSCRIPTS)

dist_noinst_DATA = $(INPUT_TEMPLATES)


man1_MANS = $(S1MANPAGES) $(G1MANPAGES)

CLEANFILES = $(GSCRIPTS) $(G1MANPAGES)

@do_subst_command@

# Command for sed sanitizing the value of a var for use on the left side of a
# sed 's' (substitution) command.
#
@sed_slsanitize_command@


$(GSCRIPTS): $(top_builddir)/src/main/resources/adsgithubtools-perl5-inc-begin-block.snippet

# Generated scripts depend on Makefile so they will be rebuilt if $(VERSION)
# or other do_subst'ituted variables change.
#
$(GSCRIPTS): Makefile

# # Rule to build versioned scripts from corresponding non-versioned input
# # templates.
# #
# # Uses chmod a-w to prevent people from editing the wrong file by accident.
# #
# # Note that the script depends on the naming convention:
# #
# # Target:
# #
# #     <PROG_NAME_BASE>-$(VERSION)
# #
# # is generated from:
# #
# #     <PROG_NAME_BASE>.in
# #
# $(GSCRIPTS): %-$(VERSION): %.in
# 	set -e ;\
# 	rm -f "$@" "$@.tmp" ;\
# 	vers_sedsanitized=$$(printf "%s\n" "-$(VERSION)" | $(sed_slsanitize)) ;\
# 	_t_base=$$(echo "$@" | sed -e "s/$${vers_sedsanitized}$$//") ;\
# 	$(do_subst) "$(srcdir)/$${_t_base}.in" > "$@.tmp"      ;\
# 	mv "$@.tmp" "$@"    ;\
# 	"$(top_srcdir)/bin/splice-in-file" "$@" '___REPLACE_ME__BEGIN_BLOCK__CONFIGURED_PERL_INC___' \
# 	  '@adsgithubtools_perl5_inc_begin_block_snippet_filepath@' 'filter' > '$@.tmp' ;\
# 	mv "$@.tmp" "$@"    ;\
# 	chmod a-w "$@"      ;\
# 	chmod a+rx "$@"


# Rule to build non-versioned scripts from corresponding non-versioned input
# templates.
#
# Uses chmod a-w to prevent people from editing the wrong file by accident.
#
# Note that the script depends on the naming convention:
#
# Target:
#
#     <PROG_NAME_BASE>
#
# is generated from:
#
#     <PROG_NAME_BASE>.in
#
$(GSCRIPTS): %: %.in
	set -e ;\
	rm -f "$@" "$@.tmp" ;\
	_t_base="$@"        ;\
	$(do_subst) "$(srcdir)/$${_t_base}.in" > "$@.tmp" ;\
	mv "$@.tmp" "$@"    ;\
	"$(top_srcdir)/bin/splice-in-file" "$@" '___REPLACE_ME__BEGIN_BLOCK__CONFIGURED_PERL_INC___' \
	  '@adsgithubtools_perl5_inc_begin_block_snippet_filepath@' 'filter' > '$@.tmp' ;\
	mv "$@.tmp" "$@"    ;\
	chmod a-w "$@"      ;\
	chmod a+rx "$@"


# The 'ads-github-tools' programs have relatively long names. When generating
# the man pages the fields in the top-of-page banner run together and become
# unreadable. The general format is:
#
#     <TOOL_NAME>(N)                 ads-github-tools                 <TOOL_NAME>(N)
#
# However, with some of our long tool names, we would get something like this
# on an 80-column terminal (or when $MANWIDTH is set to 80, which is common
# practice):
#
#     ads-github-fetch-all-upstreams(ads-github-tooads-github-fetch-all-upstreams(1)
#
# We work around this by slicing off the following prefixes from tool names as
# printed in the top-of-page banner. This changes the above output to look
# like:
#
#     fetch-all-upstreams(1)         ads-github-tools         fetch-all-upstreams(1)
#
# Note that only one prefix listed here will be removed, so order matters.
#
MANPAGE_PREFIXES_TO_REMOVE = ads-github-

# This list can be used to list full tool names (really, full man page topic
# names) that will be exempt from the man page top-of-page banner name munging
# documented above. These exemptions are intended for things like the
# ads-github-tools(7) intro man page, for which the 'ads-github-' prefix is an
# essential component of the topic name in the top-of-page banner.
#
MANPAGE_EXEMPTIONS_FROM_NAME_MUNGING =


# Generate section 1 man pages from corresponding generated programs. Note
# that we generate the man pages from the generated programs rather than from
# the corresponding input templates to allow for the possibility of the
# generation affecting the content of the man page text.
#
# XXX: We slice off the 'ads-github-' prefix from the tool name as it appears
#      on the top left and right corners of the rendered man page; on an 80
#      column terminal (or when $MANWIDTH is set to 80, which is common) the
#      names are too long -- they run together with the centered
#      'ads-github-tools' title and look bad.

#$(G1MANPAGES): %.1: %-$(VERSION)
$(G1MANPAGES): %.1: %
	target_name="$@" ;\
	topic_name=$$(echo "$${target_name}" | sed -e 's/\.1$$//') ;\
	\
	topic_name_is_exempt_from_munging=false ;\
	for one_exempt_name in '' $(MANPAGE_EXEMPTIONS_FROM_NAME_MUNGING); do \
	    if test -z "$${one_exempt_name}"; then continue; fi ;\
	\
	    if test "$${one_exempt_name}" = "$${topic_name}"; then \
	        topic_name_is_exempt_from_munging=true ;\
	        break ;\
	    fi ;\
	done ;\
	\
	if $${topic_name_is_exempt_from_munging}; then :; else \
	    for one_pfx in '' $(MANPAGE_PREFIXES_TO_REMOVE); do \
	        if test -z "$${one_pfx}"; then continue; fi ;\
	\
	        t_one_pfx_sedsanitized=$$(echo "$${one_pfx}" | $(sed_slsanitize)) ;\
	        t_new_topic_name=$$(echo "$${topic_name}" | sed -e 's/^'"$${t_one_pfx_sedsanitized}"'//') || exit 1 ;\
	\
	        if test "$${t_new_topic_name}" = "$${topic_name}"; then :; else \
	            topic_name=$${t_new_topic_name} ;\
	            break ;\
	        fi ;\
	    done ;\
	fi ;\
	\
	"$(POD2MAN)" $< \
	    --center='$(PACKAGE_TARNAME)' \
	    --name="$${topic_name}" \
	    --release=$(PACKAGE_TARNAME)-$(VERSION) \
	    --section=1 > "$${target_name}"


# all-local: create-local-links

# # For the convenience of the developer, we create symlinks from the
# # foo-$(VERSION) name to a non-versioned name in the build tree.
# create-local-links:
# 	set -e ;\
# 	vers_sedsanitized=$$(printf "%s\n" "-$(VERSION)" | $(sed_slsanitize)) ;\
# 	for prog in $(bin_SCRIPTS); do \
# 	    tname=$$(echo "$${prog}" | sed -e "s/$${vers_sedsanitized}$$//") ;\
# 	    $(LN_S) -f "$${prog}" "$${tname}" ;\
# 	    test $$? -eq 0 || exit 1 ;\
# 	done

# clean-local: clean-local-links

# # Remove the convenience symlinks we created in 'create-local-links'
# clean-local-links:
# 	set -e ;\
# 	vers_sedsanitized=$$(printf "%s\n" "-$(VERSION)" | $(sed_slsanitize)) ;\
# 	for prog in $(bin_SCRIPTS); do \
# 	    tname=$$(echo "$${prog}" | sed -e "s/$${vers_sedsanitized}$$//") ;\
# 	    rm -f "$${tname}" ;\
# 	    test $$? -eq 0 || exit 1 ;\
# 	done

# install-exec-hook:
# 	set -e ;\
# 	cd $(DESTDIR)$(bindir) ;\
# 	vers_sedsanitized=$$(printf "%s\n" "-$(VERSION)" | $(sed_slsanitize)) ;\
# 	for s in $(bin_SCRIPTS); do \
# 	    tname=$$(echo "$$s" | sed -e "s/$${vers_sedsanitized}$$//") ;\
# 	    $(LN_S) -f "$$s" "$${tname}" ;\
# 	    test $$? -eq 0 || exit 1     ;\
# 	done
