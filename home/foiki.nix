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

  # Status bar; Sway launches it via `bars` below.
  programs.waybar = {
    enable = true;
    settings.main = {
      position = "top";
      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-center = [ "sway/window" ];
      modules-right = [ "cpu" "memory" "disk" "clock" ];
      cpu.format = "CPU {usage}%";
      memory.format = "RAM {percentage}%";
      disk.format = "Disk {percentage_used}%";
      clock.format = "{:%a %Y-%m-%d %H:%M}";
    };
    style = ''
      * {
        font-family: Inter, sans-serif;
        font-size: 13px;
      }
      window#waybar {
        background: #1e1e2e;
        color: #cdd6f4;
      }
      #workspaces button {
        padding: 0 8px;
        color: #cdd6f4;
      }
      #workspaces button.focused {
        background: #45475a;
      }
      #cpu, #memory, #disk, #network, #clock {
        padding: 0 10px;
      }
    '';
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

      bars = [ { command = "waybar"; } ];

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
