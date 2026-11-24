{ pkgs, ... }:
let
  # Super+V picker: pick an entry from cliphist in fuzzel and put it back on the clipboard
  clipboardHistory = pkgs.writeShellScriptBin "clipboard-history" ''
    set -euo pipefail
    entry=$(${pkgs.cliphist}/bin/cliphist list | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt "Clipboard: ") || exit 0
    printf '%s' "$entry" | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy
  '';
in
{
  # Stores every copy (text and images) via `wl-paste --watch`, started with graphical-session.target
  services.cliphist.enable = true;

  home.packages = [ clipboardHistory ];
}
