{ inputs, pkgs, ... }:
let
  noctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  # Wayland shell, bar, wallpaper and control center.
  # Writes ~/.config/noctalia/config.toml (validated at build time) and runs as a user
  # service on graphical-session.target, which mango-session.target pulls in.
  programs.noctalia = {
    enable = true;
    package = noctalia;
    systemd.enable = true;
    settings = ../../config/noctalia/config.toml;
  };

  # Minimal monochrome palette shared by bar, launcher, clipboard, panels and lock screen.
  # Same colors as the login screen (system/desktop/greetd.nix): black, white/grey text.
  programs.noctalia.customPalettes.Mono = {
    version = 2;
    dark = {
      primary = "#f5f5f5";
      on_primary = "#000000";
      secondary = "#a3a3a3";
      on_secondary = "#000000";
      tertiary = "#d4d4d4";
      on_tertiary = "#000000";
      error = "#f87171";
      on_error = "#000000";
      surface = "#000000";
      on_surface = "#f5f5f5";
      surface_container = "#171717";
      on_surface_variant = "#8a8a8a";
      outline_variant = "#262626";
      shadow = "#000000";
      hover = "#1f1f1f";
      on_hover = "#ffffff";

      # Required: Noctalia rejects a palette without a terminal block
      terminal = {
        background = "#000000";
        foreground = "#f5f5f5";
        cursor = "#f5f5f5";
        cursor_text = "#000000";
        selection_bg = "#262626";
        selection_fg = "#f5f5f5";
        normal = {
          black = "#000000";
          red = "#f87171";
          green = "#a3a3a3";
          yellow = "#d4d4d4";
          blue = "#8a8a8a";
          magenta = "#a3a3a3";
          cyan = "#d4d4d4";
          white = "#e5e5e5";
        };
        bright = {
          black = "#525252";
          red = "#fca5a5";
          green = "#d4d4d4";
          yellow = "#e5e5e5";
          blue = "#a3a3a3";
          magenta = "#d4d4d4";
          cyan = "#e5e5e5";
          white = "#ffffff";
        };
      };
    };
  };

  systemd.user.services.noctalia.Service = {
    # The repo config is the only source of truth: drop GUI overrides on every shell start.
    # Changes made in Noctalia's settings apply live, but are gone after a restart.
    ExecStartPre = "${pkgs.coreutils}/bin/rm -f %S/noctalia/settings.toml";

    # Clipboard history starts empty after a reboot (pins stay). The marker lives in
    # /run/user (tmpfs), so a plain shell restart keeps the history.
    ExecStartPost = "${pkgs.writeShellScript "noctalia-clipboard-reset" ''
      marker="$XDG_RUNTIME_DIR/noctalia-clipboard-reset"
      [ -e "$marker" ] && exit 0
      export PATH=${pkgs.coreutils}/bin:$PATH
      for _ in $(seq 50); do
        if ${noctalia}/bin/noctalia msg clipboard-clear >/dev/null 2>&1; then
          touch "$marker"
          exit 0
        fi
        sleep 0.2
      done
      exit 0
    ''}";
  };
}
