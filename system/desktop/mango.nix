{ pkgs, ... }:
let
  # Session launcher used by tuigreet (system/desktop/greetd.nix).
  # mango imports WAYLAND_DISPLAY/XDG_CURRENT_DESKTOP into systemd & DBus on its own,
  # its config (config/mango/config.conf) then starts mango-session.target.
  mangoSession = pkgs.writeShellScriptBin "mango-session" ''
    # Home Manager session variables (home.sessionVariables / home.sessionPath), so
    # apps launched from the compositor see the same environment as a login shell
    hmVars="/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
    [ -r "$hmVars" ] && . "$hmVars"

    export XDG_CURRENT_DESKTOP=mango
    export XDG_SESSION_DESKTOP=mango
    export XDG_SESSION_TYPE=wayland
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
    export GDK_BACKEND=wayland
    export NIXOS_OZONE_WL=1

    # User services run outside the login session; Noctalia needs the session ID to
    # follow logind's Lock signal (laptop power button, hosts/laptop/default.nix)
    systemctl --user import-environment XDG_SESSION_ID

    mango
    systemctl --user stop mango-session.target
  '';
in
{
  # MangoWC - Wayland compositor based on dwl + scenefx (blur, shadows, rounded corners).
  # Also sets up the mango portal config (wlr for screencast/screenshot, gtk for the rest).
  programs.mangowc.enable = true;

  xdg.portal.config.common.default = [ "gtk" ];

  # Same pattern as NixOS' sway-session.target: binds graphical-session.target to the
  # compositor lifetime, so user services like Noctalia start and stop with Mango
  systemd.user.targets.mango-session = {
    description = "Mango compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  # Battery / power info for the Noctalia shell (home/desktop/noctalia.nix)
  services.upower.enable = true;

  # Only the session launcher is system-wide (greetd needs it before any user profile
  # is active); desktop tools live in home/desktop/.
  environment.systemPackages = [ mangoSession ];
}
