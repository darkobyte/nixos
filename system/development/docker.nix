{ lib, usersNeeding, ... }:
{
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Everyone with development apps on this host
  users.users = lib.genAttrs (usersNeeding "development") (_: {
    extraGroups = [ "docker" ];
  });
}
