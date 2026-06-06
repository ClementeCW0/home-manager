#/usr/bin/env bash

flake="nixos-wacquez"

cd $HOME
git clone git@github.com:ClementeCW0/home-manager.git && cd home-manager
git clone git@github.com:ClementeCW0/Config.git &&

if [ $? -eq 0 ]; then
	sudo nixos-rebuild boot --impure --flake ".#$flake"
fi
