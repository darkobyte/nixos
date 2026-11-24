{ pkgs, ... }:
{
  # Cisco AnyConnect compatible client; NetworkManager plugin is in system/core/networking.nix
  home.packages = [ pkgs.openconnect ];

  programs.zsh.shellAliases.tu-vpn =
    "sudo ${pkgs.openconnect}/bin/openconnect --protocol=anyconnect --authgroup=campus vpn.hrz.tu-darmstadt.de";
}
