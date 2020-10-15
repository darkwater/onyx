{ lib,
  mkShell,
  writeShellScriptBin,

  rustPlatform,
  clippy,

  stlink,
  gcc-arm-embedded,
  usbutils,
  tmux,

  openocd,
  ruby,
}:

{ nightly ? false, # takes a string like "2020-09"
  embedded ? false,
  openocd-bin ? "${openocd}/bin/openocd",
  ...
} @ args:

let
  nightlyDateMap = {
    # Every three months, add a new entry that contains at least these components:
    # cargo, clippy, rust, rust-std, rustc, rustfmt
    # https://rust-lang.github.io/rustup-components-history/x86_64-unknown-linux-gnu.html

    "2020-09" = "2020-09-23";
  };

  nightlyDate = if specificNightly then nightly else nightlyDateMap.${nightly};

  latestNightly = builtins.head (builtins.attrNames nightlyDateMap);
  latestNightlyVal = nightlyDateMap."${latestNightly}";

  onyx = import (builtins.fetchTarball https://git.dark.red/darkwater/onyx/-/archive/master/onyx-master.tar.gz) {};
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  overlaidPkgs = import <nixpkgs> { overlays = [ onyx.overlay moz_overlay ]; };

  # rustc/cargo
  broadNightly    = builtins.match "[0-9]{4}-[0-9]{2}" nightly != null;
  specificNightly = builtins.match "[0-9]{4}-[0-9]{2}-[0-9]" nightly != null;

  stableRust = with rustPlatform.rust; [ rustc cargo ];
  nightlyRust = (overlaidPkgs.rustChannelOf { channel = "nightly"; date = nightlyDate; }).rust;
  embeddedRust = nightlyRust.override {
    targets = [ "thumbv7em-none-eabi" ];
  };

  rustAndCargo = if embedded then embeddedRust else
                 if nightly != false then nightlyRust else stableRust;

  # custom tools

  # open tmux with openocd, itm log, shell
  wrappedOpenocd = (writeShellScriptBin "openocd-tmux" ''
    mkfifo itm.fifo
    exec tmux \
      new-session ${openocd-bin} \; \
      split-window -v -p 85 ${ruby}/bin/ruby ${./rust-read-itm.rb} \; \
      split-window -v -p 70 \; \
      attach
  '');
in 

assert (embedded -> nightly != false) || throw ''
  embedded programs require a nightly rust.
    please add: nightly = "${latestNightly}";
'';

assert ((nightly != false) -> broadNightly || specificNightly) || throw ''
  nightly specifier should be a string like "${latestNightly}", or "${latestNightlyVal}".
'';

mkShell (args // {
  buildInputs = (args.buildInputs or []) ++ [
    rustAndCargo clippy
  ] ++ lib.optional embedded [
    stlink gcc-arm-embedded
    usbutils tmux
    wrappedOpenocd
  ];

  shellHook = (args.shellHook or "") + ''
    ${lib.optionalString embedded ''
      ${builtins.readFile ./rust-stlink-hook.sh}
      echo "commands:"
      echo "  openocd-tmux - start a tmux session with openocd and a shell"
    ''}
  '';
})
