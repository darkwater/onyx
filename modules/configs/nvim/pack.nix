{ stdenv, linkFarm, writeShellScript, coreutils, fzf, nodejs-12_x, writeText,
  callPackage, rnix-lsp, nodePackages }:

let
  langservers = callPackage ./langservers.nix {};
  plugin-sources = callPackage ./plugin-sources.nix {};

  cocConfig = {
    "npm.binPath" = "${nodejs-12_x}/bin/npm";
    "rust-analyzer.serverPath" = "${langservers.rust-analyzer}/bin/rust-analyzer";
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

  plugins = with plugin-sources; [
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
    # (npm "coc-angular")
    # (npm "coc-clangd") # or ccls?
    # (npm "coc-cmake")
    # (npm "coc-css")
    # (npm "coc-html")
    # (npm "coc-java")
    # (npm "coc-jedi") # alternatives exist
    # (npm "coc-phpls")
    # (npm "coc-solargraph")
    (npm "coc-tsserver")
    (npm "coc-vimlsp")
    (npm "coc-xml")
    (npm "coc-yaml")

    # ui
    (github "junegunn/fzf.vim" {})
    (github "yuki-ycino/fzf-preview.vim" {})
    (github "voldikss/vim-floaterm" {})
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
