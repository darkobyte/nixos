{ pkgs, ... }:
let
  cliphist = "${pkgs.cliphist}/bin/cliphist";
  wlcopy = "${pkgs.wl-clipboard}/bin/wl-copy";

  # Super+V picker (fuzzel dmenu, same design as the launcher)
  #   Enter   copy entry
  #   Alt+P   pin / unpin entry (pins survive reboots)
  #   Alt+X   delete entry
  #   Alt+C   clear history (pins stay)
  # History lives in /run/user (tmpfs), so it is empty after every reboot.
  clipboardHistory = pkgs.writeShellScriptBin "clipboard-history" ''
    set -uo pipefail
    pins="''${XDG_DATA_HOME:-$HOME/.local/share}/clipboard-pins"
    mkdir -p "$pins"

    preview() {
      if ${pkgs.file}/bin/file -b --mime-type "$1" | grep -q '^text/'; then
        tr '\n\t' '  ' < "$1" | cut -c1-200
      else
        echo "[image / binary]"
      fi
    }

    while true; do
      entry=$(
        {
          for f in $(ls -1 "$pins" | sort -rn); do
            printf 'pin:%s\t󰐃  %s\n' "$f" "$(preview "$pins/$f")"
          done
          ${cliphist} list
        } | ${pkgs.fuzzel}/bin/fuzzel --dmenu --with-nth 2 --width 70 --lines 14 \
              --prompt "  " --placeholder "alt+p pin · alt+x delete · alt+c clear"
      )
      code=$?
      [ -n "$entry" ] || exit 0

      case "$entry" in
        pin:*) id=''${entry%%$'\t'*}; id=''${id#pin:}; file="$pins/$id" ;;
        *) file="" ;;
      esac

      case $code in
        0) # copy
          if [ -n "$file" ]; then ${wlcopy} < "$file"
          else printf '%s' "$entry" | ${cliphist} decode | ${wlcopy}; fi
          exit 0 ;;
        10) # pin / unpin
          if [ -n "$file" ]; then rm -f "$file"
          else printf '%s' "$entry" | ${cliphist} decode > "$pins/$(date +%s%N)"; fi ;;
        11) # delete
          if [ -n "$file" ]; then rm -f "$file"
          else printf '%s' "$entry" | ${cliphist} delete; fi ;;
        12) # clear history, keep pins
          ${cliphist} wipe ;;
        *) exit 0 ;;
      esac
    done
  '';
in
{
  # Stores every copy (text and images) via `wl-paste --watch`, started with graphical-session.target
  services.cliphist.enable = true;

  # Database on tmpfs: history resets on reboot; read by every cliphist call
  xdg.configFile."cliphist/config".text = ''
    db-path /run/user/1000/cliphist.db
    preview-width 200
  '';

  # Alt+P / Alt+X / Alt+C in the picker (fuzzel exits with code 10 / 11 / 12)
  programs.fuzzel.settings.key-bindings = {
    custom-1 = "Mod1+p";
    custom-2 = "Mod1+x";
    custom-3 = "Mod1+c";
  };

  home.packages = [ clipboardHistory ];
}
