{ lib, pkgs, hostUsers, ... }:
{
  # users.mutableUsers = true ensures that system activation never resets or alters passwords
  users.mutableUsers = true;

  # One account per users/<name>.nix that lists this host. Removing it from there
  # removes the account on the next switch; the home folder is left on disk.
  users.users = lib.mapAttrs (name: user: {
    isNormalUser = true;
    description = user.fullName or name;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
    ] ++ lib.optional user.admin "wheel" ++ [
      "video"
      "input"
      "dialout"
      "uucp"
      "plugdev"
      "audio"
    ];
    linger = true;
    # First login only (users/<name>.nix); change it afterwards with `passwd`
    initialPassword = user.initialPassword or null;
  }) hostUsers;

  programs.zsh.enable = true;
}
