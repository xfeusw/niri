
{ niri }:
{ config, lib, pkgs, ... }:
{
  imports = [ niri.homeModules.niri ];

  programs.niri = {
    enable = true;

    settings = {
      # Basic input configuration
      input = {
        keyboard = {
          xkb = {
            layout = "us";
          };
        };
        touchpad = {
          tap = true;
          natural-scroll = true;
        };
      };

      layout = {
        gaps = 8;
        border.width = 2;  
      };

      binds = with config.lib.niri.actions; {
        "Mod+Return".action = spawn "ghostty";
        "Mod+D".action = spawn fuzzel;
        "Mod+Q".action = close-window;

        # Window focus
        "Mod+H".action = move-column-left;
        "Mod+L".action = move-column-right;
        "Mod+K".action = move-window-up;
        "Mod+J".action = move-window-down;

        # Workspaces
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;

        # Exit
        "Mod+Shift+E".action = quit;
      };
    };
  };
}

