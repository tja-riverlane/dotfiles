#!  bash
# shellcheck disable=SC2239

if [[ ! "${WSL+set}" ]]; then
	[[ "$(systemd-detect-virt || :)" = "wsl" ]] && WSL=1 || WSL=
	export WSL
fi
