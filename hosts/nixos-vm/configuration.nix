{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # UTM boots aarch64 VMs via UEFI.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-vm";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Stockholm";

  # English system language, Swedish formats (dates, numbers, currency, units).
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  console.keyMap = "sv-latin1";

  # Keyboard for the ReGreet login screen (cage reads these); Sway sets its own in home/foiki.nix.
  environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "se";
    XKB_DEFAULT_VARIANT = "mac";
    # Run Electron apps (Signal, etc.) natively on Wayland instead of XWayland.
    NIXOS_OZONE_WL = "1";
  };

  users.users.foiki = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.bash;
  };

  programs.bash.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Graphical login screen (greetd + ReGreet); lists Sway as a session.
  programs.regreet.enable = true;

  security.polkit.enable = true;
  # swaylock needs a PAM entry to check the password on unlock.
  security.pam.services.swaylock = { };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  services.spice-vdagentd.enable = true;

  fonts.packages = with pkgs; [ inter ];

  environment.systemPackages = with pkgs; [
    dbeaver-bin
    # shortcut: pinned to 1.14.0 because 26.05 ships 1.7.0, which can't open
    # Enpass 6.8+ vaults (SQLCipher v4). Drop the override once nixpkgs has >= 1.14.
    (enpass-cli.overrideAttrs (_: rec {
      version = "1.14.0";
      src = fetchFromGitHub {
        owner = "HazCod";
        repo = "enpass-cli";
        tag = "v${version}";
        hash = "sha256-cVPPBuluUvPnPAlF+OEMYOOTSdPGbJmI1iSRlYqveFQ=";
      };
      vendorHash = "sha256-U9tnzok21yCFPDZprsvqq0NaO07qPS0L+IgVtF2hpvM=";
    }))
    filezilla
    firefox
    foot
    fuzzel
    git
    grim
    mako
    signal-desktop
    slurp
    vim 
    wl-clipboard
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # IMPORTANT: retain the stateVersion from your installation.
  system.stateVersion = "26.05";
}
