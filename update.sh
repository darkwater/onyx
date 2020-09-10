#!/usr/bin/env nix-shell
#!nix-shell -p nodePackages.node2nix gnused curl jq git bash -i bash

cd "$(dirname "$0")"

# pkgs.nodePackages
( cd pkgs/nodePackages/ && node2nix )

# unstable
{
    unstable=$(
        curl -sLH 'Accept: application/json' https://hydra.nixos.org/job/nixpkgs/trunk/unstable/latest |
            jq -re '.nixname | match("[0-9a-f]+$").string'
    )
    sed -i -Ee "s|(https://github.com/nixos/nixpkgs/archive/)[0-9a-f]*|\1$unstable|" default.nix
}

# pkgs.vimPlugins
{
    sed -ne 's/^.*github "\(.*\)" "\(.*\)" "\(.*\)";$/\1 \2 \3/p' pkgs/vimPlugins/default.nix |
        while read name repo currentrev; do
            head="$(git ls-remote "https://github.com/$repo" HEAD | cut -d$'\t' -f1)"
            sed -i -e "s/$currentrev/$head/" pkgs/vimPlugins/default.nix
        done
}
