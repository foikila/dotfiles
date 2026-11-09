{ config, lib, pkgs, ... }:

{

  home.username = "foiki";
  home.homeDirectory = "/home/foiki";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      source ${../config/bash/aliases.bash}
    '';
  };

  xdg.configFile."git/config".source = ../config/git/config;
  home.file.".vim/vimrc".source = ../config/vim/vimrc;

  wayland.windowManager.sway = {
    enable = true;

    # Sway itself is installed by the NixOS module.
    package = null;

    config = {
      modifier = "Mod4";
      terminal = "foot";
      menu = "fuzzel";

      input."type:keyboard" = {
        xkb_layout = "se";
        # Mac key positions (e.g. @ on Alt+2); remove for a PC keyboard.
        xkb_variant = "mac";
      };

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
