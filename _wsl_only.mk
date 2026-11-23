include ~/_wsl_detect.mk

ifeq "$(WSL)" ""
ifeq "$(MAKECMDGOALS)" ""
.DEFAULT_GOAL := _wsl_skipped
.PHONY: _wsl_skipped
_wsl_skipped:
else
$(error This Makefile is intended to be skipped unless running in WSL. Refusing to run recipes: $(MAKECMDGOALS))
endif
endif
