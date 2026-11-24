{ env, ... }:
{
  # Base Home Manager profile shared by every host. Hosts add categories
  # (browsers, entertainment, development, ...) in hosts/<host>/home.nix.
  imports = [
    ./cli
  ];

  home.username = env.username;
  home.homeDirectory = "/home/${env.username}";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # Restart changed user services (Noctalia, Nextcloud, ...) on every switch
  systemd.user.startServices = "sd-switch";
}
