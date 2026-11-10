{ config, ... }:

# Every Sway keybinding, spelled out. This replaces Home Manager's defaults
# entirely, so a binding that isn't listed here doesn't exist.
let
  cfg = config.wayland.windowManager.sway.config;
  lock = "${config.programs.swaylock.package}/bin/swaylock -f";
in
{
  wayland.windowManager.sway.config = {
    keybindings = {
      # Apps
      "Mod4+Return" = "exec ${cfg.terminal}";
      "Mod4+d" = "exec ${cfg.menu}";
      "Mod4+Shift+q" = "kill";

      # Focus
      "Mod4+h" = "focus left";
      "Mod4+j" = "focus down";
      "Mod4+k" = "focus up";
      "Mod4+l" = "focus right";
      "Mod4+Left" = "focus left";
      "Mod4+Down" = "focus down";
      "Mod4+Up" = "focus up";
      "Mod4+Right" = "focus right";
      "Mod4+a" = "focus parent";
      "Mod4+space" = "focus mode_toggle";

      # Move windows
      "Mod4+Shift+h" = "move left";
      "Mod4+Shift+j" = "move down";
      "Mod4+Shift+k" = "move up";
      # Default was "move right"; Mod4+Shift+Right still does that.
      "Mod4+Shift+l" = "exec ${lock}";
      "Mod4+Shift+Left" = "move left";
      "Mod4+Shift+Down" = "move down";
      "Mod4+Shift+Up" = "move up";
      "Mod4+Shift+Right" = "move right";

      # Layout
      "Mod4+b" = "splith";
      "Mod4+v" = "splitv";
      "Mod4+f" = "fullscreen toggle";
      "Mod4+s" = "layout stacking";
      "Mod4+w" = "layout tabbed";
      "Mod4+e" = "layout toggle split";
      "Mod4+Shift+space" = "floating toggle";

      # Workspaces
      "Mod4+1" = "workspace number 1";
      "Mod4+2" = "workspace number 2";
      "Mod4+3" = "workspace number 3";
      "Mod4+4" = "workspace number 4";
      "Mod4+5" = "workspace number 5";
      "Mod4+6" = "workspace number 6";
      "Mod4+7" = "workspace number 7";
      "Mod4+8" = "workspace number 8";
      "Mod4+9" = "workspace number 9";
      "Mod4+0" = "workspace number 10";
      "Mod4+Shift+1" = "move container to workspace number 1";
      "Mod4+Shift+2" = "move container to workspace number 2";
      "Mod4+Shift+3" = "move container to workspace number 3";
      "Mod4+Shift+4" = "move container to workspace number 4";
      "Mod4+Shift+5" = "move container to workspace number 5";
      "Mod4+Shift+6" = "move container to workspace number 6";
      "Mod4+Shift+7" = "move container to workspace number 7";
      "Mod4+Shift+8" = "move container to workspace number 8";
      "Mod4+Shift+9" = "move container to workspace number 9";
      "Mod4+Shift+0" = "move container to workspace number 10";

      # Scratchpad
      "Mod4+Shift+minus" = "move scratchpad";
      "Mod4+minus" = "scratchpad show";

      # Sway
      "Mod4+r" = "mode resize";
      "Mod4+Shift+c" = "reload";
      "Mod4+Shift+e" =
        "exec swaynag -t warning -m 'Exit Sway?' -b 'Yes' 'swaymsg exit'";
    };

    # Active after Mod4+r.
    modes.resize = {
      "h" = "resize shrink width 10 px";
      "j" = "resize grow height 10 px";
      "k" = "resize shrink height 10 px";
      "l" = "resize grow width 10 px";
      "Left" = "resize shrink width 10 px";
      "Down" = "resize grow height 10 px";
      "Up" = "resize shrink height 10 px";
      "Right" = "resize grow width 10 px";
      "Escape" = "mode default";
      "Return" = "mode default";
    };
  };
}
