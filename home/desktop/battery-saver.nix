{ pkgs, ... }:
let
  # True on AC, and on machines without a battery (workstation)
  onAc = pkgs.writeShellScriptBin "on-ac" ''
    has_battery=false
    for s in /sys/class/power_supply/*; do
      case "$(cat "$s/type" 2>/dev/null)" in
        Battery) has_battery=true ;;
        Mains) [ "$(cat "$s/online" 2>/dev/null)" = 1 ] && exit 0 ;;
      esac
    done
    [ "$has_battery" = false ]
  '';

  # On battery: drop the internal panel to its lowest refresh rate. On AC: restore
  # the highest. Reacts to power_supply uevents.
  batterySaver = pkgs.writeShellScriptBin "battery-saver" ''
    set -u
    grep -qx Battery /sys/class/power_supply/*/type 2>/dev/null || exit 0

    # Highest (AC) or lowest (battery) refresh rate at the panel's current resolution
    set_refresh() {
      local pick=$1 output=eDP-1 mode
      mode=$(${pkgs.wlr-randr}/bin/wlr-randr --json | ${pkgs.jq}/bin/jq -r --arg o "$output" --arg pick "$pick" '
        .[] | select(.name == $o and .enabled) | . as $out
        | ($out.modes[] | select(.current)) as $cur
        | [$out.modes[] | select(.width == $cur.width and .height == $cur.height)]
        | sort_by(.refresh) | (if $pick == "max" then last else first end)
        | "\(.width)x\(.height)@\(.refresh)Hz"') || return 0
      [ -n "$mode" ] && ${pkgs.wlr-randr}/bin/wlr-randr --output "$output" --mode "$mode"
    }

    last=""
    apply() {
      local now
      if ${onAc}/bin/on-ac; then now=ac; else now=bat; fi
      [ "$now" = "$last" ] && return
      last=$now
      if [ "$now" = ac ]; then set_refresh max; else set_refresh min; fi
    }

    apply
    ${pkgs.systemd}/bin/udevadm monitor --udev --subsystem-match=power_supply | while read -r _; do
      apply
    done
  '';
in
{
  systemd.user.services.battery-saver = {
    Unit = {
      Description = "Lower the refresh rate on battery";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${batterySaver}/bin/battery-saver";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
