#!/usr/bin/env bash

# Target the host configuration: use the first argument if provided, otherwise default to current hostname
flake="${1:-$(hostname)}"

if [[ "$flake" != "tufnix" && "$flake" != "dellnix" && "$flake" != "senteynix" ]]; then
	echo "Error: Resolved hostname '$flake' is not configured in flake.nix."
	echo "To select a host configuration manually, run:"
	echo "  $0 tufnix        # to apply the tufnix configuration"
	echo "  $0 dellnix       # to apply the dellnix configuration"
	echo "  $0 senteynix     # to apply the senteynix configuration"
	exit 1
fi

pushd $HOME/home-manager/
	sudo nixos-rebuild switch --impure --flake ".#$flake"
	if [ $? -eq 0 ]; then
		# Stage renamed configuration, host-specific entrypoints, and input-leap sandboxes
		git add ./common.nix ./home.nix ./machines/*  ./flake.nix ./flake.lock ./input-leap/
		git commit -m "New version ($flake): $(date +"%Y-%m-%d %H:%M:%S")"
		git push
	fi
popd
