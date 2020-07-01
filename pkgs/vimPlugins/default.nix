{ stdenv, runCommand, neovim, python3, perl, bash, ruby, nodePackages }:

let
  inherit (import ../../. {}) unstable;

  github = name: repo: commit: let
    # besides downloading the plugin, we also generate tags for its documentation
    generate-docs = "${neovim}/bin/nvim"
      + " --headless --noplugin --clean"
      + " -c 'helptags doc/' -c 'q'";
  in stdenv.mkDerivation {
    inherit name;
    src = builtins.fetchTarball {
      inherit name;
      url = "https://github.com/${repo}/archive/${commit}.tar.gz";
    };

    buildInputs = [ python3 perl bash ruby ];

    phases = [ "unpackPhase" "patchPhase" "buildPhase" "installPhase" ];

    buildPhase = ''[[ -d doc/ ]] && ${generate-docs} || true'';

    installPhase = ''
      mkdir -p $out/share/vim-plugins
      cp -ax . $out/share/vim-plugins/${name}
      patchShebangs $out
      if grep -R '^#!' $out | grep -v '#!/nix/store' >&2; then
        echo -e "\e[1;31merror\e[0m: shebangs found leading outside nix store!" >&2
        exit 1
      fi
    '';
  };

  node = builtins.mapAttrs (name: package: runCommand name {} ''
    mkdir -p $out/share/vim-plugins
    ln -s ${package}/lib/node_modules/* $out/share/vim-plugins/${name}
  '') nodePackages;
in {
  fzf-preview = github "fzf-preview" "yuki-ycino/fzf-preview.vim" "b769e2e97ff0700e1d1570c4f459c27c7992cfbf";
  vim-floaterm = github "vim-floaterm" "voldikss/vim-floaterm" "fb5ba1bc6f29038f0141e9e08e248dc07bca77d9";
  vim-which-key = github "vim-which-key" "liuchengxu/vim-which-key" "b9409149a5a8a386322cc4246d890c8c4c07d11d";

  # syntax plugins
  i3config-vim = github "i3config-vim" "mboughaba/i3config.vim" "c3fe1a901392ee11721e08d2a0d2886a7f8b8e83";
  ron-vim = github "ron-vim" "ron-rs/ron.vim" "3cd98b1b4d66d6719dcc02a758f20f40b0e1fc5a";

  inherit (node)
    coc-actions
    coc-angular
    coc-clangd
    coc-cmake
    coc-explorer
    coc-jedi
    coc-phpls
    coc-rust-analyzer
    coc-vimlsp
    coc-xml;

  inherit (unstable.vimPlugins)
    coc-git
    coc-json
    coc-nvim
    coc-tsserver
    coc-yaml
    fzf-vim
    vim-commentary
    vim-nix
    vim-repeat
    vim-surround
    vim-toml;
}
