{ ... }:

let
  ssh-keys = import ../ssh-keys.nix;
in
{
  onyx.shell.defaultUser = "dark";

  users.users.dark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = ssh-keys.dark;
  };

  users.users.arena = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = ssh-keys.arena;
  };

  users.users.root = {
    openssh.authorizedKeys.keys = ssh-keys.dark;
  };

  services.nginx.enable = true;
  security.acme.defaults.email = "dark@dark.red";

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
}
