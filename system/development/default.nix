{ lib, usersNeeding, ... }:
{
  # Only when a user on this host has development apps (users/<name>.nix)
  imports = lib.optionals (usersNeeding "development" != [ ]) [
    ./docker.nix
    ./embedded.nix
  ];
}
