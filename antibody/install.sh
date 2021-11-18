#!/bin/bash
set -x

if ! command -v $(brew --prefix antibody)/bin/antibody >/dev/null 2>&1; then

	if command -v brew >/dev/null 2>&1; then
		brew tap | grep -q 'getantibody/tap' || brew tap getantibody/tap
		brew install antibody
	else
		curl -sL https://git.io/antibody | sudo sh -s -- -b /usr/local/bin
	fi
fi
export ANTIBODY_HOME=~/.antibody
antibody bundle <"$DOTFILES/antibody/bundles.txt" >~/.zsh_plugins.sh
antibody update
