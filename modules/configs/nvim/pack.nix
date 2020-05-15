{ lib, stdenv, linkFarm, writeShellScript, coreutils, fzf, yarn, nodejs-12_x,
  neovim, writeText, callPackage, rnix-lsp, nodePackages }:

let
  unstable = import (builtins.fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {};

  rust-analyzer-pkgs = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixpkgs/3ea54e69727b0195f25a2be909ae821223621a64/"
        + "pkgs/development/tools/rust/rust-analyzer/generic.nix";
    sha256 = "1ji6z6g0pzddh68yznbm2qk37g8sw2v60qsbhv1135sldbwf0y8z";
  };

  rust-analyzer = callPackage rust-analyzer-pkgs rec {
    inherit (unstable) rustPlatform;
    rev = "2020-05-04";
    version = "unstable-${rev}";
    sha256 = "09q35wcs3ffkzbpx45z07xzmsiwkyjsjnn2d3697vv3iv4lg8i02";
    cargoSha256 = "1ncn54q8maf8890pk141901vrsijd7z4bkkchzl4sl3xd5h0a08c";
    doCheck = false;
  };

  mkEntryFromDrv = drv: { name = drv.name; path = drv; };

  github = path: { ref ? "HEAD", patches ? [] }: let
    name = builtins.baseNameOf path;
    generate-docs = "${neovim}/bin/nvim"
      + " --headless --noplugin --clean"
      + " -c 'helptags doc/' -c 'q'";
  in mkEntryFromDrv (stdenv.mkDerivation {
    inherit name patches;
    src = builtins.fetchGit {
      inherit name ref;
      url = "https://github.com/${path}";
    };
    phases = [ "unpackPhase" "patchPhase" "buildPhase" "installPhase" ];
    buildPhase = ''[[ -d doc/ ]] && ${generate-docs} || true'';
    installPhase = ''cp -ax . $out'';
  });

  npm-plugins = (import ./npm-plugins {});

  # to add npm plugins, first add them to npm-plugins/npm-plugins.json
  # run `node2nix -i npm-plugins.json` in npm-plugins/ after changes
  npm = name: {
    inherit name;
    path = "${npm-plugins.${name}}/lib/node_modules/${name}";
  };

  cocConfig = {
    "npm.binPath" = "${nodejs-12_x}/bin/npm";
    "rust-analyzer.serverPath" = "${rust-analyzer}/bin/rust-analyzer";
    languageserver = {
      rnix = {
        command = "${rnix-lsp}/bin/rnix-lsp";
        filetypes = [ "nix" ];
        rootPatterns = [ "default.nix" ];
      };
      bash = {
        command = "${nodePackages.bash-language-server}/bin/bash-language-server";
        args = [ "start" ];
        filetypes = [ "sh" ];
        ignoredRootPaths = [ "~" ];
      };
    };
  };

  plugins = [
    {
      # must be loaded before most plugins
      name = "00_onyx";
      path = stdenv.mkDerivation {
        name = "onyx";
        src = ./onyx;
        phases = [ "unpackPhase" "buildPhase" "installPhase" ];
        installPhase = ''cp -ax . $out'';

        # TODO: bundle npm somehow so :CocInstall etc. work
        generatedVim = writeText "generated.vim" ''
          let g:coc_node_path = "${nodejs-12_x}/bin/node"
          let g:coc_user_config = json_decode('${builtins.toJSON cocConfig}')
        '';

        buildPhase = ''
          ln -s $generatedVim plugin/generated.vim
        '';
      };
    }

    # fzf base plugin (not :Files etc. but :FZF itself)
    # TODO: bundle the binary?
    { name = "fzf"; path = "${fzf}/share/vim-plugins/fzf"; }

    # coc
    (github "neoclide/coc.nvim" { ref = "release"; }) # maybe also through npm?
    (npm "coc-actions")
    (npm "coc-explorer")
    (npm "coc-git")

    # coc language stuff
    (npm "coc-json")
    (npm "coc-rust-analyzer")
    # TODO: configure the following
    (npm "coc-angular")
    (npm "coc-clangd") # or ccls?
    (npm "coc-cmake")
    (npm "coc-css")
    (npm "coc-html")
    (npm "coc-java")
    (npm "coc-jedi") # alternatives exist
    (npm "coc-phpls")
    (npm "coc-solargraph")
    (npm "coc-tsserver")
    (npm "coc-vimlsp")
    (npm "coc-xml")
    (npm "coc-yaml")

    # ui
    (github "junegunn/fzf.vim" {})
    (github "liuchengxu/vim-which-key" {
      patches = [ ./which-key-quote.patch ];
    })

    # syntax
    (github "cespare/vim-toml" {})
    (github "mboughaba/i3config.vim" {})
    (github "ron-rs/ron.vim" {})
    (github "LnL7/vim-nix" {})

    # utilities
    (github "tpope/vim-surround" {})
    (github "tpope/vim-commentary" {})
    (github "tpope/vim-repeat" {})
  ];

  optionalPlugins = [
  ];
in stdenv.mkDerivation {
  name = "onyx-nvim";
  version = "0.1.0";

  src = ./onyx;

  packStart = linkFarm "pack-start" plugins;
  packOpt   = linkFarm "pack-opt" optionalPlugins;

  builder = writeShellScript "onyx-nvim-builder" ''
    PATH=${coreutils}/bin

    mkdir -p $out/share/nvim/site/pack/onyx/
    ln -s $packStart $out/share/nvim/site/pack/onyx/start
    ln -s $packOpt $out/share/nvim/site/pack/onyx/opt
  '';
}
