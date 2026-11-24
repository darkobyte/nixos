{ pkgs, ... }:
{
  # Vanilla Minecraft via Prism Launcher (official launcher was removed from nixpkgs as broken).
  # Sign in with a Microsoft account; Prism downloads the matching Java automatically.
  home.packages = [ pkgs.prismlauncher ];
}
