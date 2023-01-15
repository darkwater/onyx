{ config, pkgs, ... }:

{
  # == automatic maintenance every night ==
  nix.gc = {
    automatic = true;
    dates = "05:00";
    options = "--delete-older-than 7d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "07:00" ];
  };

  # == packages ==
  environment.systemPackages = with pkgs; [
    (p7zip.override { enableUnfree = true; })

    # cli
    acpi bat ed du-dust exa fd file fzf git gnupg htop imagemagick jq lsof
    neovim netcat-gnu pciutils pstree pv ripgrep rubyPackages_3_1.pry
    solargraph sshfs unzip wget xxd

    # tui
    htop screen tmux
  ];

  # == general system stuff ==
  boot.cleanTmpDir = true;

  networking.domain = "";
  networking.useDHCP = false;
  networking.firewall.enable = false;

  nix = {
    settings.trusted-users = [ "root" "@wheel" ];

    # binaryCaches = [ "https://cache.dark.red/" ];
    # binaryCachePublicKeys =
    #   [ "nix-serve:L6SPRX5KxckGNAQ2pY/RjzQCOzc+lrLie1BQlh+sAUg=" ];
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Amsterdam";

  # == common services/programs ==
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };

    pam.enableSSHAgentAuth = true;

    acme = {
      acceptTerms = true;
      defaults.email = "dark@dark.red";
    };
  };

  programs.ssh = {
    startAgent = true;
    agentTimeout = "15m";
  };

  services = {
    openssh.enable = true;
    cron.enable = true;

    prometheus.exporters = {
      node = {
        enable = true;
        # enabledCollectors = [ "systemd" ];
      };
    };
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  users.users.dark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = import ../ssh-keys.nix;
  };

  users.users.root = {
    openssh.authorizedKeys.keys = import ../ssh-keys.nix;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  zramSwap.enable = true;
  system.stateVersion = "22.05";
}
