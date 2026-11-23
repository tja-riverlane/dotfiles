.PHONY: all
all:

ifneq "$(wildcard $(HOME)/.password-store/nomi/segoe.gpg)" ""
all: o365-fonts.user.css
o365-fonts.user.css: o365-fonts.user.css.j2 $(HOME)/.password-store/nomi/segoe.gpg
	pass-extract-yaml-j2 nomi/segoe | j2 -f yaml $< - > $@
endif

include ~/_gitignore.mk

.DELETE_ON_ERROR:
