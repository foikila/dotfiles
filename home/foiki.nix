{ config, lib, pkgs, ... }:

let
  # Full path: programs.sway also installs plain swaylock, which rejects the effects options.
  lock = "${config.programs.swaylock.package}/bin/swaylock -f";
in
{
  imports = [
    ./sway-keybindings.nix
    ./neovim.nix
    ./bash-it.nix
  ];

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

  # One ssh-agent per login (systemd user service); the key is added on first use,
  # so the passphrase is asked once per session.
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*".addKeysToAgent = "yes";
  };

  xdg.configFile."git/config".source = ../config/git/config;
  home.file.".vim/vimrc".source = ../config/vim/vimrc;

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      effect-blur = "7x5";
      clock = true;
      indicator = true;
      fade-in = 0.2;
    };
  };

  # Lock after 5 min idle, screen off after 10 min.
  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = lock; }
      {
        timeout = 600;
        command = "swaymsg 'output * power off'";
        resumeCommand = "swaymsg 'output * power on'";
      }
    ];
  };

  # Status bar; Sway launches it via `bars` below.
  programs.waybar = {
    enable = true;
    settings.main = {
      position = "top";
      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-center = [ "sway/window" ];
      modules-right = [ "cpu" "memory" "disk" "clock"];
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
      #cpu, #memory, #disk, #clock {
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

      # Apps launched once when Sway starts (not on reload).
      startup = [
        { command = "signal-desktop"; }
      ];

      input."type:keyboard" = {
        xkb_layout = "se";
        # Mac key positions (e.g. @ on Alt+2); remove for a PC keyboard.
        xkb_variant = "mac";
      };
    };
  };
}
