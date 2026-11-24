{ ... }:
{
  system.stateVersion = "24.11";

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = true;
  };

  # Framework AMD & hardware support
  hardware.enableRedistributableFirmware = true;
}
