{ user, ... }:
{
  # Base profile every user gets on every host: CLI, the full Mango + Noctalia desktop,
  # Firefox and Nemo. Personal apps are listed per user in users/<name>.nix.
  imports = [
    ./cli
    ./desktop
    ./files
    ./browsers/firefox.nix
  ];

  home.username = user.name;
  home.homeDirectory = "/home/${user.name}";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # Standard folders (Desktop, Downloads, Documents, ...), created for every new user
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = false;
    projects = "/home/${user.name}/Projects";
  };

  # Restart changed user services (Noctalia, Nextcloud, ...) on every switch
  systemd.user.startServices = "sd-switch";
}
