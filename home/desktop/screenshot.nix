{ pkgs, ... }:
let
  screenshotScript = pkgs.writeShellScriptBin "screenshot" ''
    set -euo pipefail

    DIR="''${SCREENSHOT_DIR:-$HOME/Pictures/Screenshots}"
    mkdir -p "$DIR"
    TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
    FILE="$DIR/Screenshot_$TIMESTAMP.png"

    notify() {
      if command -v notify-send >/dev/null 2>&1; then
        notify-send -a "Screenshot Tool" "$1" "$2"
      fi
    }

    mode="''${1:-area}"

    case "$mode" in
      fullscreen|full)
        ${pkgs.grim}/bin/grim "$FILE"
        ${pkgs.wl-clipboard}/bin/wl-copy --type image/png < "$FILE"
        notify "Screenshot Captured" "Full screen saved to $(basename "$FILE") and copied to clipboard"
        ;;
      area|region|edit|annotate)
        GEOM=$(${pkgs.slurp}/bin/slurp 2>/dev/null) || exit 0
        ${pkgs.grim}/bin/grim -g "$GEOM" "$FILE"
        ${pkgs.wl-clipboard}/bin/wl-copy --type image/png < "$FILE"
        notify "Screenshot Captured" "Area saved to $(basename "$FILE") and copied to clipboard"
        ;;
      *)
        echo "Usage: screenshot [area|fullscreen]"
        exit 1
        ;;
    esac
  '';
in
{
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    libnotify
    screenshotScript
  ];

  # Launcher entry for the screenshot tool in app menus
  xdg.desktopEntries.screenshot = {
    name = "Screenshot Tool";
    genericName = "Screenshot Tool";
    comment = "Capture screen area to file and clipboard";
    exec = "${screenshotScript}/bin/screenshot area";
    icon = "accessories-screenshot";
    terminal = false;
    categories = [ "Utility" "Graphics" ];
    settings.Keywords = "screenshot;screenshottool;snip;capture;";
  };
}
