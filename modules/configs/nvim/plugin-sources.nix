{ pkgs, system, stdenv, neovim }:

let
  mkEntryFromDrv = drv: { name = drv.name; path = drv; };
  npm-plugins = (import ./npm-plugins { inherit pkgs system; });
in {
  github = repo: { ref ? "HEAD", patches ? [] }: let
    name = builtins.baseNameOf repo;
    generate-docs = "${neovim}/bin/nvim"
      + " --headless --noplugin --clean"
      + " -c 'helptags doc/' -c 'q'";
  in mkEntryFromDrv (stdenv.mkDerivation {
    inherit name patches;
    src = builtins.fetchGit {
      inherit name ref;
      url = "https://github.com/${repo}";
    };
    buildInputs = with pkgs; [ python3 perl bash ruby ];
    phases = [
      "unpackPhase" "patchPhase" "buildPhase" "installPhase"
    ];
    buildPhase = ''[[ -d doc/ ]] && ${generate-docs} || true'';
    installPhase = ''
      cp -ax . $out
      patchShebangs $out
      if grep -R '^#!' $out | grep -v '#!/nix/store' >&2; then
        echo -e "\e[1;31merror\e[0m: shebangs found leading outside nix store!" >&2
        exit 1
      fi
    '';
  });

  # to add npm plugins, first add them to npm-plugins/npm-plugins.json
  # run `node2nix -i npm-plugins.json` in npm-plugins/ after changes
  npm = name: {
    inherit name;
    path = "${npm-plugins.${name}}/lib/node_modules/${name}";
  };
}
