{ lib, usersNeeding, ... }:
{
  # Only when a user on this host has gaming apps (users/<name>.nix)
  imports = lib.optionals (usersNeeding "gaming" != [ ]) [
    ./steam.nix
  ];
}
