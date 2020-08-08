{ stdenv, lib, linkFarm, writeShellScript, coreutils, fzf, nodejs-12_x, writeText, callPackage,
  rnix-lsp, nodePackages, runCommand, vimPlugins, }:

let
  inherit ((import ../../. {}).unstable)
    rust-analyzer;

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
  ] ++ (builtins.attrValues (builtins.mapAttrs (name: drv: {
    inherit name;
    path = "${drv}/share/vim-plugins/${name}";
  }) (lib.getAttrs [
    "coc-actions"
    "coc-explorer"
    "coc-git"
    "coc-json"
    "coc-nvim"
    "coc-rust-analyzer"
    "coc-tsserver"
    "coc-vimlsp"
    "coc-xml"
    "coc-yaml"
    "fzf-preview"
    "fzf-vim"
    "i3config-vim"
    "ron-vim"
    "vim-commentary"
    "vim-easy-align"
    "vim-floaterm"
    "vim-fugitive"
    "vim-nix"
    "vim-repeat"
    "vim-surround"
    "vim-toml"
    "vim-which-key"
  ] vimPlugins)));

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

  optionalPlugins = [
  ];
in stdenv.mkDerivation {
  name = "onyx-nvim";
  version = "0.1.0";

  src = null;

  packStart = linkFarm "pack-start" plugins;
  packOpt   = linkFarm "pack-opt" optionalPlugins;

  builder = writeShellScript "onyx-nvim-builder" ''
    PATH=${coreutils}/bin

    mkdir -p $out/share/nvim/site/pack/onyx/
    ln -s $packStart $out/share/nvim/site/pack/onyx/start
    ln -s $packOpt $out/share/nvim/site/pack/onyx/opt
  '';
}
