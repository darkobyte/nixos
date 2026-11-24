{ ... }:
{
  # System layer: boot, hardware, daemons. Apps are in ./home.nix (Home Manager).
  imports = [
    ./hardware-configuration.nix

    ../../system/core
    ../../system/desktop
    ../../system/development
    ../../system/gaming
    ../../system/hardware
  ];

  # Power button locks the screen instead of shutting down (Noctalia picks up
  # logind's lock signal). Holding it ~5s still forces off via the firmware.
  services.logind.settings.Login.HandlePowerKey = "lock";

  # This module bypasses logind and signals init to power off on every press
  boot.blacklistedKernelModules = [ "tiny_power_button" ];

  # Early KMS: load the GPU driver in the initrd so the Plymouth splash
  # (system/desktop/plymouth.nix) shows at native resolution without a mode switch
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Goodix 27c6:609c fingerprint reader (libfprint goodixmoc driver).
  # Enroll once with `fprintd-enroll`. Works for sudo and polkit prompts via PAM.
  services.fprintd.enable = true;

  # The Noctalia lock screen talks to fprintd itself, next to the password field,
  # and authenticates passwords against the `login` PAM service; pam_fprintd there
  # would make it wait for a finger before checking the password. The greeter has
  # no fingerprint support and needs the password to unlock the GNOME keyring.
  security.pam.services.login.fprintAuth = false;
  security.pam.services.greetd.fprintAuth = false;
}
