{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-vm";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Stockholm";

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

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  services.spice-vdagentd.enable = true;

  environment.systemPackages = with pkgs; [
    foot
    fuzzel
    mako
    wl-clipboard
    grim
    slurp
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # IMPORTANT: retain the stateVersion from your installation.
  system.stateVersion = "26.05";
}
