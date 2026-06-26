#!/usr/bin/env bash

# Target the host configuration: use the first argument if provided, otherwise default to current hostname
flake="${1:-$(hostname)}"

if [[ "$flake" != "desktop" && "$flake" != "laptop" ]]; then
	echo "Error: Resolved hostname '$flake' is not configured in flake.nix."
	echo "To select a host configuration manually, run:"
	echo "  $0 desktop    # to apply the desktop configuration"
	echo "  $0 laptop     # to apply the laptop configuration"
	exit 1
fi

pushd $HOME/home-manager/
	sudo nixos-rebuild switch --impure --flake ".#$flake"
	if [ $? -eq 0 ]; then
		# Stage renamed configuration, host-specific entrypoints, and input-leap sandboxes
		git add ./common.nix ./desktop.nix ./laptop.nix ./home.nix ./flake.nix ./flake.lock ./input-leap/
		git commit -m "New version ($flake): $(date +"%Y-%m-%d %H:%M:%S")"
		git push
	fi
popd
