{ inputs, pkgs, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];

  # Wayland shell, bar, wallpaper and control center.
  # Writes ~/.config/noctalia/config.toml (validated at build time) and runs as a user
  # service on graphical-session.target, which mango-session.target pulls in.
  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    systemd.enable = true;
    settings = ../../config/noctalia/config.toml;
  };

  # The repo config is the only source of truth: drop GUI overrides on every shell start.
  # Changes made in Noctalia's settings apply live, but are gone after a restart.
  systemd.user.services.noctalia.Service.ExecStartPre =
    "${pkgs.coreutils}/bin/rm -f %S/noctalia/settings.toml";
}
