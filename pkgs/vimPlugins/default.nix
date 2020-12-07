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
  fzf-preview = github "fzf-preview" "yuki-ycino/fzf-preview.vim" "c56b1ae1648e1b5bf79c6a033621e82ba0cbaabc"; # branch: release
  vim-floaterm = github "vim-floaterm" "voldikss/vim-floaterm" "d7880f46f9b339f935e9912bb3f41c9b346ae992";
  vim-which-key = github "vim-which-key" "liuchengxu/vim-which-key" "30c0810b012a7acdccc6b72f0e99c0388986844f";

  vim-godot = github "vim-godot" "habamax/vim-godot" "7697cc88a9ae3e5da923a1739f9753ec4c47617b";

  # syntax plugins
  i3config-vim = github "i3config-vim" "mboughaba/i3config.vim" "c3fe1a901392ee11721e08d2a0d2886a7f8b8e83";
  ron-vim = github "ron-vim" "ron-rs/ron.vim" "04004b3395d219f95a533c4badd5ba831b7b7c07";

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
    rust-vim
    vim-airline
    vim-airline-themes
    vim-commentary
    vim-easy-align
    vim-nix
    vim-repeat
    vim-surround
    vim-toml;
}
