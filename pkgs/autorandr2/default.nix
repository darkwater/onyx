{ writeShellScriptBin, xrandr, systemd, ruby }:

let
  xrandr-rb = builtins.fetchGit {
    url = "https://github.com/F-3r/xrandr.rb";
    rev = "4bcb693cc7012d413a1b9c7731ea20b586ae55ce";
  };
in writeShellScriptBin "autorandr2" ''
  export PATH=${xrandr}/bin:${systemd}/bin
  ${ruby}/bin/ruby -I ${xrandr-rb}/lib ${./autorandr2.rb} "$@"
''
