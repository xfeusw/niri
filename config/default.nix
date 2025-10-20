{ niri }:

{ config, lib, pkgs, ... }:

{
  imports = [ niri.homeModules.niri ];

  programs.niri = {
    enable = true;
    
    settings = {
      input = {
        keyboard.xkb = {
          layout = "us,ru";
          options = "grp:alt_shift_toggle";
        };
        touchpad = {
          tap = true;
          natural-scroll = true;
        };
        mouse = {
          accel-profile = "flat";
          accel-speed = 0.4;
        };
      };

      layout = {
        gaps = 1;
        border = {
          width = 0;
          active.color = "#7aa2f7";
          inactive.color = "#414868";
        };
        focus-ring = {
          width = 0;
          active.color = "#7aa2f7";
          inactive.color = "#414868";
        };
      };

      prefer-no-csd = true;

      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      binds = with config.lib.niri.actions; {
        # Existing bindings
        "Mod+Return".action = spawn "ghostty";
        "Mod+D".action = spawn "fuzzel";
        "Mod+Q".action = close-window;
        "Mod+E".action = spawn "dolphin";
        "Mod+B".action = spawn "firefox";
        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+K".action = focus-workspace-up;
        "Mod+J".action = focus-workspace-down;
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+K".action = move-workspace-up;
        "Mod+Shift+J".action = move-workspace-down;
        "Mod+Ctrl+H".action = set-column-width "-10%";
        "Mod+Ctrl+L".action = set-column-width "+10%";
        "Mod+Ctrl+K".action = set-window-height "-10%";
        "Mod+Ctrl+J".action = set-window-height "+10%";
        "Mod+F".action = fullscreen-window;
        "Mod+M".action = maximize-column;
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Up".action = focus-workspace-up;
        "Mod+Down".action = focus-workspace-down;
        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+Shift+Up".action = move-workspace-up;
        "Mod+Shift+Down".action = move-workspace-down;
        "Mod+Shift+E".action = quit;
        "Mod+Shift+R".action = spawn ["sh" "-c" "niri msg action quit; niri"];

        # New bindings from image
        "Alt+Shift+E".action = spawn ["sh" "-c" "niri msg action quit; niri"];
        "Alt+Q".action = close-window;
        "Alt+H".action = focus-column-left;
        "Alt+Shift+H".action = move-column-left;
        "Alt+Shift+L".action = move-column-right;
        "Alt+M".action = maximize-column;
        "Alt+B".action = spawn "firefox";
        "Alt+D".action = spawn "fuzzel";
        "Alt+Return".action = spawn "ghostty";
        "Alt+Shift+R".action = spawn ["sh" "-c" "niri msg action quit; niri"];
      };

      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 22;
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
    waybar
  ];

  # Autostart Waybar via activation script
  home.activation = {
    startWaybar = lib.hm.dag.entryAfter ["writeBoundary"] ''
      pkill -f waybar || true
      ${pkgs.waybar}/bin/waybar &
    '';
  };

  # Session variables
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
