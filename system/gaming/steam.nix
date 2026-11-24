{ ... }:
{
  # Steam needs system-level FHS env, udev rules and firewall ports, so it can't be
  # a Home Manager package. Proton/Wine/MangoHud live in home/gaming/.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  hardware.steam-hardware.enable = true;

  # Daemon that applies CPU/GPU performance tweaks while a game runs (`gamemoderun %command%`)
  programs.gamemode.enable = true;
}
