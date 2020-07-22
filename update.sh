#!/usr/bin/env nix-shell
#!nix-shell -p nodePackages.node2nix bash -i bash

cd "$(dirname "$0")"

( cd pkgs/nodePackages/ && node2nix )
