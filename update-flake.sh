#!/usr/bin/env bash

flake="nixos-wacquez"
pushd $HOME/nixos-dotfiles/
	sudo nixos-rebuild switch --impure --flake ".#$flake"
	if [ $? -eq 0 ]; then
		git add ./configuration.nix ./home.nix ./flake.nix ./flake.lock
		git commit -m "New version: $(date +"%Y-%m-%d %H:%M:%S")"
		git push
	fi
popd
