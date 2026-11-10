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

  # Generates ~/.config/i3status-rust/config-default.toml for the Sway bar.
  programs.i3status-rust = {
    enable = true;
    bars.default.blocks = [
      { block = "cpu"; }
      { block = "memory"; }
      { block = "disk_space"; path = "/"; }
      { block = "net"; }
      { block = "time"; }
    ];
  };

  wayland.windowManager.sway = {
    enable = true;

    # Sway itself is installed by the NixOS module.
    package = null;

    config = {
      modifier = "Mod4";
      terminal = "top";
      menu = "fuzzel";

      # Inter: free look-alike of Apple's San Francisco (installed in configuration.nix).
      fonts = {
        names = [ "Inter" ];
        size = 10.0;
      };

      output."*".bg =
        "${pkgs.nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath} fill";

      bars = [
        {
          position = "top";
          fonts = {
            names = [ "Inter" ];
            size = 10.0;
          };
          statusCommand =
            "i3status-rs ${config.xdg.configHome}/i3status-rust/config-default.toml";
        }
      ];

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
