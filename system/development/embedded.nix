{ ... }:
{
  # Microcontroller / embedded board access (user is in dialout, uucp and plugdev groups)
  services.udev.extraRules = ''
    # Arduino Opta bootloader
    SUBSYSTEM=="usb", ATTR{idVendor}=="2341", ATTR{idProduct}=="0364", MODE="0666"
  '';
}
