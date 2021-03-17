{ stdenv, lib, linkFarm, writeShellScript, coreutils, writeText, callPackage,
  rnix-lsp, nodePackages, runCommand, unstable }:

let
  inherit ((import ../../. {}).unstable)
    rust-analyzer fzf;

  plugins = [
    {
      # must be loaded before most plugins
      name = "00_onyx";
      path = stdenv.mkDerivation {
        name = "onyx";
        src = ./onyx;
        phases = [ "unpackPhase" "buildPhase" "installPhase" ];
        installPhase = ''cp -ax . $out'';

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
    "i3config-vim"
    "rust-vim"
    "vim-airline"
    "vim-airline-themes"
    "vim-commentary"
    "vim-easy-align"
    "vim-floaterm"
    "vim-fugitive"
    "vim-nix"
    "vim-repeat"
    "vim-surround"
    "vim-toml"
  ] unstable.vimPlugins)));
in stdenv.mkDerivation {
  name = "onyx-nvim";
  version = "0.1.0";

  src = null;

  packStart = linkFarm "pack-start" plugins;
  builder = writeShellScript "onyx-nvim-builder" ''
    PATH=${coreutils}/bin

    mkdir -p $out/share/nvim/site/pack/onyx/
    ln -s $packStart $out/share/nvim/site/pack/onyx/start
  '';
}
