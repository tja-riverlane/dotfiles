#!  sh
# ^ sourced from /etc/X11/Xsession via ~/.xsessionrc
# shellcheck disable=SC2239

if [ -z "${WSL+set}" ]; then
	if [ "$(systemd-detect-virt || :)" = "wsl" ]; then
		export WSL=1
	else
		export WSL=
	fi
fi
