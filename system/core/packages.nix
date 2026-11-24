{ pkgs, ... }:
{
  # Minimal rescue toolset for root and recovery. Everything else is installed
  # per user through Home Manager (home/cli/tools.nix).
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    curl
  ];
}
