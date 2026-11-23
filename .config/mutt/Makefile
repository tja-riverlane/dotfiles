.PHONY: all
all:

ifneq "$(wildcard ~/.cache/mu/xapian/*)" ""
all: muttrc-lists
muttrc-lists: $(wildcard ~/.cache/mu/xapian/*)
	mu find --fields=l body:mailman body:listinfo body:options \
		| xargs grep -P -i -o -h '^errors-to:\s+\K.*' \
		| sed -e 's/-bounces.*@/@/; s/^/lists /; s/\./\\./' \
		| sort -u \
		> $@
endif

ifneq "$(wildcard $(HOME)/.password-store/app-pass/fastmail-imap.gpg)" ""
all: muttrc-fastmail
muttrc-fastmail: muttrc-fastmail.j2 Makefile $(HOME)/.password-store/app-pass/fastmail-imap.gpg
	pass-extract-yaml-j2 app-pass/fastmail-imap | j2 -f yaml $< - > $@
endif

include ~/_gitignore.mk

.DELETE_ON_ERROR:
