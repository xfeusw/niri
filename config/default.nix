{ niri }:

{ config, lib, pkgs, ... }:

{
  imports = [ niri.homeModules.niri ];

  programs.niri = {
    enable = true;
    
    settings = {
      input = {
        keyboard.xkb = {
          layout = "us";
        };
        touchpad = {
          tap = true;
          natural-scroll = true;
        };
        mouse = {
          accel-profile = "flat";
        };
      };

      layout = {
        gaps = 8;
        border = {
          width = 2;
          active.color = "#7aa2f7";
          inactive.color = "#414868";
        };
        focus-ring = {
          width = 2;
          active.color = "#7aa2f7";
          inactive.color = "#414868";
        };
      };

      prefer-no-csd = true;

      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      binds = with config.lib.niri.actions; {
        # Applications
        "Mod+Return".action = spawn "ghostty";
        "Mod+D".action = spawn "fuzzel";
        "Mod+Q".action = close-window;
        "Mod+E".action = spawn "dolphin";
        "Mod+B".action = spawn "firefox";

        # Window focus (vim keys)
        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+K".action = focus-window-up;
        "Mod+J".action = focus-window-down;

        # Window movement
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+K".action = move-window-up;
        "Mod+Shift+J".action = move-window-down;

        # Window sizing
        "Mod+Ctrl+H".action = set-column-width "-10%";
        "Mod+Ctrl+L".action = set-column-width "+10%";
        "Mod+Ctrl+K".action = set-window-height "-10%";
        "Mod+Ctrl+J".action = set-window-height "+10%";

        # Fullscreen and maximize
        "Mod+F".action = fullscreen-window;
        "Mod+M".action = maximize-column;

        # Workspaces
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;

        # Move to workspace
        "Mod+Shift+1".action = move-column-to-workspace 1;
        "Mod+Shift+2".action = move-column-to-workspace 2;
        "Mod+Shift+3".action = move-column-to-workspace 3;
        "Mod+Shift+4".action = move-column-to-workspace 4;
        "Mod+Shift+5".action = move-column-to-workspace 5;

        # Monitors
        "Mod+Left".action = focus-monitor-left;
        "Mod+Right".action = focus-monitor-right;
        "Mod+Shift+Left".action = move-column-to-monitor-left;
        "Mod+Shift+Right".action = move-column-to-monitor-right;

        # Screenshots
        "Print".action = screenshot;
        "Shift+Print".action = screenshot-screen;

        # System
        "Mod+Shift+E".action = quit;
        "Mod+Shift+R".action = spawn ["sh" "-c" "niri msg action quit; niri"];
      };

      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
      };

      window-rules = [
        {
          matches = [{ app-id = "org.kde.dolphin"; }];
          default-column-width = { proportion = 0.5; };
        }
        {
          matches = [{ app-id = "firefox"; }];
          default-column-width = { proportion = 0.7; };
        }
      ];
    };
  };

  # Fuzzel for app launching
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "ghostty";
        font = "JetBrains Mono:size=11";
        dpi-aware = "yes";
      };
      colors = {
        background = "1a1b26dd";
        text = "c0caf5ff";
        match = "7aa2f7ff";
        selection = "414868ff";
        selection-text = "c0caf5ff";
        border = "7aa2f7ff";
      };
    };
  };

  # Waybar for status bar
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        
        modules-left = ["niri/workspaces" "niri/window"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "network" "battery" "tray"];

        "niri/workspaces" = {
          format = "{index}";
        };

        "niri/window" = {
          format = "{title}";
          max-length = 50;
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d %H:%M}";
        };

        battery = {
          format = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
        };

        network = {
          format-wifi = "{essid} ";
          format-disconnected = "Disconnected ⚠";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            default = ["" "" ""];
          };
        };
      };
    };
    style = ''
      * {
        font-family: JetBrains Mono;
        font-size: 13px;
      }

      window#waybar {
        background-color: rgba(26, 27, 38, 0.95);
        color: #c0caf5;
      }

      #workspaces button {
        padding: 0 10px;
        color: #c0caf5;
      }

      #workspaces button.focused {
        background-color: #7aa2f7;
        color: #1a1b26;
      }

      #clock, #battery, #network, #pulseaudio {
        padding: 0 10px;
      }
    '';
  };

  # Wayland utilities
  home.packages = with pkgs; [
    wl-clipboard
    grim
    slurp
    swappy
  ];

  # Session variables
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
