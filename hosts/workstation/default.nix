{ ... }:
{
  # System layer: boot, hardware, daemons. Accounts and their apps are in users/<name>.nix.
  imports = [
    ./hardware-configuration.nix

    ../../system/core
    ../../system/desktop
    ../../system/development
    ../../system/gaming
    ../../system/hardware/bluetooth.nix
  ];

  networking.hostName = "dumbledore";
}
