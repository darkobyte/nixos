{ ... }:
{
  # Secret Service provider, unlocked at login by greetd. Used by Nextcloud
  # (home/cloud/nextcloud.nix) and other apps to persist account tokens.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
