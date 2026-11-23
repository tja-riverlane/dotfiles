include ~/_wsl_detect.mk

ifneq "$(WSL)" ""
ifeq "$(MAKECMDGOALS)" ""
.DEFAULT_GOAL := _wsl_skipped
.PHONY: _wsl_skipped
_wsl_skipped:
else
$(error This Makefile is intended to be skipped if running in WSL. Refusing to run recipes: $(MAKECMDGOALS))
endif
endif
