{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        
        modules-left = ["niri/workspaces" "niri/window"];
        modules-center = ["clock"];
        modules-right = ["cpu" "memory" "pulseaudio" "network" "battery" "tray"];

        "niri/workspaces" = {
          format = "{index}";
          all-outputs = true;
        };

        "niri/window" = {
          format = "{title}";
          max-length = 50;
          rewrite = {
            "" = "No Active Window";
          };
        };

        clock = {
          format = "{:%I:%M %p}";
          format-alt = "{:%Y-%m-%d %I:%M %p}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = "CPU {usage}%";
          tooltip = true;
        };

        memory = {
          format = "RAM {used:0.1f}G/{total:0.1f}G";
          tooltip = true;
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ⚡";
          format-icons = ["" "" "" "" ""];
          tooltip-format = "{timeTo} ({capacity}%)";
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%) 📶";
          format-ethernet = "Ethernet 🖧";
          format-disconnected = "Disconnected ⚠";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "Muted 🔇";
          format-icons = {
            default = ["🔈" "🔉" "🔊"];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
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
