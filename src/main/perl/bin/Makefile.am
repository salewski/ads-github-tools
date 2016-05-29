## Process this file with automake to produce Makefile.in   -*-Makefile-*-

#SUBDIRS =  \
#          .

INPUT_TEMPLATES = \
    ads-github-normalize-url.in

# "static" scripts
SSCRIPTS =
# "generated" scripts (filtered here by do_subst)
GSCRIPTS = $(INPUT_TEMPLATES:.in=-$(VERSION))


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

# Rule to build versioned scripts from corresponding non-versioned input
# templates.
#
# Uses chmod a-w to prevent people from editing the wrong file by accident.
#
# Note that the script depends on the naming convention:
#
# Target:
#
#     <PROG_NAME_BASE>-$(VERSION)
#
# is generated from:
#
#     <PROG_NAME_BASE>.in
#
$(GSCRIPTS): %-$(VERSION): %.in
	set -e ;\
	rm -f "$@" "$@.tmp" ;\
	vers_sedsanitized=$$(printf "%s\n" "-$(VERSION)" | $(sed_slsanitize)) ;\
	_t_base=$$(echo "$@" | sed -e "s/$${vers_sedsanitized}$$//") ;\
	$(do_subst) "$(srcdir)/$${_t_base}.in" > "$@.tmp"      ;\
	mv "$@.tmp" "$@"    ;\
	"$(top_srcdir)/bin/splice-in-file" "$@" '___REPLACE_ME__BEGIN_BLOCK__CONFIGURED_PERL_INC___' \
	  '@adsgithubtools_perl5_inc_begin_block_snippet_filepath@' 'filter' > '$@.tmp' ;\
	mv "$@.tmp" "$@"    ;\
	chmod a-w "$@"      ;\
	chmod a+rx "$@"


# Generate section 1 man pages from corresponding generated programs. Note
# that we generate the man pages from the generated programs rather than from
# the corresponding input templates to allow for the possibility of the
# generation affecting the content of the man page text.
$(G1MANPAGES): %.1: %-$(VERSION)
	target_name="$@" ;\
	tname=$$(echo "$${target_name}" | sed -e 's/\.1$$//') ;\
	"$(POD2MAN)" $< \
	    --center='$(PACKAGE_TARNAME)' \
	    --name="$${tname}" \
	    --release=$(PACKAGE_TARNAME)-$(VERSION) \
	    --section=1 > "$${target_name}"

all-local: create-local-links

# For the convenience of the developer, we create symlinks from the
# foo-$(VERSION) name to a non-versioned name in the build tree.
create-local-links:
	set -e ;\
	vers_sedsanitized=$$(printf "%s\n" "-$(VERSION)" | $(sed_slsanitize)) ;\
	for prog in $(bin_SCRIPTS); do \
	    tname=$$(echo "$${prog}" | sed -e "s/$${vers_sedsanitized}$$//") ;\
	    $(LN_S) -f "$${prog}" "$${tname}" ;\
	    test $$? -eq 0 || exit 1 ;\
	done

clean-local: clean-local-links

# Remove the convenience symlinks we created in 'create-local-links'
clean-local-links:
	set -e ;\
	vers_sedsanitized=$$(printf "%s\n" "-$(VERSION)" | $(sed_slsanitize)) ;\
	for prog in $(bin_SCRIPTS); do \
	    tname=$$(echo "$${prog}" | sed -e "s/$${vers_sedsanitized}$$//") ;\
	    rm -f "$${tname}" ;\
	    test $$? -eq 0 || exit 1 ;\
	done

install-exec-hook:
	set -e ;\
	cd $(DESTDIR)$(bindir) ;\
	vers_sedsanitized=$$(printf "%s\n" "-$(VERSION)" | $(sed_slsanitize)) ;\
	for s in $(bin_SCRIPTS); do \
	    tname=$$(echo "$$s" | sed -e "s/$${vers_sedsanitized}$$//") ;\
	    $(LN_S) -f "$$s" "$${tname}" ;\
	    test $$? -eq 0 || exit 1     ;\
	done
