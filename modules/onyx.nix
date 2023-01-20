{ config, lib, pkgs, nixpkgs, ... }:

let
  cfg = config.onyx;
in
{
  imports = [
    ./docker.nix
    ./hetzner.nix
    ./shell
    ./proxies.nix
  ];

  options.onyx = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "[onyx] Enable common configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    onyx = {
      shell.enable = lib.mkDefault true;
      docker.enable = lib.mkDefault true;
    };

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
      file
      git
      lsof
      neovim
      pciutils
      unzip
      usbutils
    ];

    # == general system stuff ==
    boot.cleanTmpDir = true;

    networking.domain = "";
    networking.firewall.enable = false;

    networking.useDHCP = false;
    networking.dhcpcd.extraConfig = ''
      hostname ${config.networking.hostName}
    '';

    nix = {
      registry.nixpkgs.flake = nixpkgs;

      settings.trusted-users = [ "root" "@wheel" ];

      # binaryCaches = [ "https://cache.dark.red/" ];
      # binaryCachePublicKeys =
      #   [ "nix-serve:L6SPRX5KxckGNAQ2pY/RjzQCOzc+lrLie1BQlh+sAUg=" ];
    };

    nixpkgs.config.allowUnfree = true;

    time.timeZone = lib.mkDefault "Europe/Amsterdam";

    # == common services/programs ==
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
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };

    security.acme.acceptTerms = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    zramSwap.enable = true;
    system.stateVersion = "22.05";
  };
}
