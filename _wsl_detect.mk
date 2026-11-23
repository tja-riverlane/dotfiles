WSL := $(if $(filter wsl,$(shell systemd-detect-virt)),1)
