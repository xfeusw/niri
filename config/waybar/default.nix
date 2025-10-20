{ config, lib, pkgs, ... }:

{
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
          format = "{:%I:%M %p}";
          format-alt = "{:%Y-%m-%d %I:%M %p}";
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
    style = builtins.readFile ./style.css;
  };

  # Autostart Waybar via systemd service
  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar status bar";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
