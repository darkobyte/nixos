{ ... }:
{
  # System layer: boot, hardware, daemons. Apps are in ./home.nix (Home Manager).
  imports = [
    ./hardware-configuration.nix

    ../../system/core
    ../../system/desktop
    ../../system/development
    ../../system/gaming
    ../../system/hardware/bluetooth.nix
  ];
}
