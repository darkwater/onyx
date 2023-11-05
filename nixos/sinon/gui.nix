{ config, lib, pkgs, ... }:

{
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  services.getty.autologinUser = "dark";

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.dbus.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.xserver = {
      enable = true;

      videoDrivers = [ "amdgpu" ];
      displayManager.autoLogin = {
          enable = true;
          user = "dark";
      };

      libinput.enable = true;
      libinput.accelProfile = "flat";

      inputClassSections = [
          ''
              Identifier "Mouse Settings"
              Driver "libinput"
              MatchIsPointer "yes"
              Option "AccelProfile" "flat"
              Option "MiddleEmulation" "off"
          ''
      ];

      wacom.enable = true;

      xkbOptions = "ctrl:nocaps";
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;

      displayManager.lightdm.enable = true;
      displayManager.lightdm.background = builtins.fetchurl {
          url = https://dark.red/wallpapers/atsushi.png;
          sha256 = "0a8y0d7ibrgzwp9lfw41vd9n1r7pzrbxkk9db6vi2pw1gkrqkyij";
      };
      displayManager.lightdm.greeters.gtk = {
          enable = true;
          theme.name = "Adwaita-dark";
          cursorTheme.name = "Capitaine Cursors - White";
          cursorTheme.package = pkgs.capitaine-cursors;
          extraConfig = ''
              position = 50%,center 80%,center
              hide-user-image = true
          '';
      };

      displayManager.defaultSession = "none+i3";
      windowManager.i3.enable = true;
      desktopManager.xterm.enable = false;
  };

  services.picom = {
    enable = true;
    backend = "glx";
    vSync = false;
    wintypes = {
      dock = { opacity = 0.92; };
    };
  };

  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  # };

  fonts.fonts = with pkgs; [
    dejavu_fonts
    hack-font
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    roboto
    roboto-mono
    ipafont
    kochi-substitute
  ];
}
