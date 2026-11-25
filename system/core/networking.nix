{ pkgs, ... }:
{
  networking = {
    networkmanager = {
      enable = true;
      # Cisco AnyConnect / Secure Client compatible VPN (TU Darmstadt campus VPN)
      plugins = [ pkgs.networkmanager-openconnect ];
    };
    firewall = {
      enable = true;
      allowPing = true;
    };
  };
}
