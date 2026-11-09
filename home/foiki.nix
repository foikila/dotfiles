{ config, lib, pkgs, ... }:

{
  imports = [
    ./programs/zsh.nix
  ];

  home.username = "foiki";
  home.homeDirectory = "/home/foiki";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  wayland.windowManager.sway = {
    enable = true;

    # Sway itself is installed by the NixOS module.
    package = null;

    config = {
      modifier = "Mod4";
      terminal = "foot";
      menu = "fuzzel";

      keybindings = lib.mkOptionDefault {
        # Application launcher
        "Mod4+d" = "exec fuzzel";

        # Exit Sway
        "Mod4+Shift+e" =
          "exec swaynag -t warning -m 'Exit Sway?' -b 'Yes' 'swaymsg exit'";
      };
    };
  };
}
