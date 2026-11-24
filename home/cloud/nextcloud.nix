{ pkgs, ... }:
{
  # Nextcloud desktop sync client, started automatically with the graphical session
  # (tray icon only, no main window). Tokens are stored in GNOME Keyring
  # (system/desktop/keyring.nix).
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  # Also on PATH / in the app launcher for opening the settings window manually
  home.packages = [ pkgs.nextcloud-client ];

  # Start after the Noctalia bar so the tray icon has a host to register with
  systemd.user.services.nextcloud-client.Unit.After = [ "noctalia.service" ];
}
