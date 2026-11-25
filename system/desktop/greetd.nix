{ pkgs, inputs, owner, ... }:
let
  # Session entry for the greeter's picker. mangowc's own "Mango" entry runs the bare
  # compositor; this one goes through mango-session (system/desktop/mango.nix).
  mangoSessionEntry = (pkgs.writeTextDir "share/wayland-sessions/mango-session.desktop" ''
    [Desktop Entry]
    Name=Mango (Noctalia)
    Comment=Mango compositor with the Noctalia shell
    Exec=mango-session
    Type=Application
    DesktopNames=mango;wlroots
  '').overrideAttrs { passthru.providedSessions = [ "mango-session" ]; };
in
{
  imports = [ inputs.noctalia-greeter.nixosModules.default ];

  services.xserver.enable = false;

  services.displayManager.sessionPackages = [ mangoSessionEntry ];

  # Noctalia Greeter on greetd (also enables AccountsService and Polkit).
  # Appearance follows the shell via Settings -> Security -> Noctalia Greeter -> Sync.
  services.displayManager.noctalia-greeter = {
    enable = true;
    # Patched: no login card, session picker (always starts session.default below) or
    # back-to-user-list button. None of this has a config option upstream.
    package =
      inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./patches/noctalia-greeter-minimal.patch ];
      });
    passwordless-sync-users = [ owner ];
    settings = {
      session.default = "mango-session";
      user.default = owner;

      # Minimal monochrome look: no logo or scheme picker, plain password dots.
      # A complete palette here wins over anything Sync writes.
      appearance = {
        scheme = "Synced";
        theme_mode = "dark";
        password_style = "default";
        hide_logo = true;
        scheme_selector_position = "hidden";
        power_buttons_position = "bottom-right";
        corner_radius_scale = 1.0;
        font_family = "JetBrainsMono Nerd Font";

        palette = {
          primary = "#e6e6e6";
          on_primary = "#0a0a0a";
          secondary = "#a3a3a3";
          on_secondary = "#0a0a0a";
          tertiary = "#d4d4d4";
          on_tertiary = "#0a0a0a";
          error = "#f87171";
          on_error = "#0a0a0a";
          surface = "#0a0a0a";
          on_surface = "#f5f5f5";
          surface_variant = "#171717";
          on_surface_variant = "#8a8a8a";
          outline = "#262626";
          shadow = "#000000";
          hover = "#2a2a2a";
          on_hover = "#f5f5f5";
        };

        wallpaper.fill_color = "#000000";
      };

      clock = {
        position = "above-panel";
        time_format = "{:%H:%M}";
        date_format = "%A, %d %B";
        time_font_size = 72;
        date_font_size = 14;
      };

      cursor.size = 24;
      keyboard.layout = "us";
    };
  };

  # The greeter runs as its own user, so it can't see fonts from Home Manager
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
}
