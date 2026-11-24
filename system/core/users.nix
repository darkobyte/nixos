{ pkgs, env, ... }:
{
  # users.mutableUsers = true ensures that system activation never resets or alters passwords
  users.mutableUsers = true;

  users.users.${env.username} = {
    isNormalUser = true;
    description = env.fullName or env.username;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      "dialout"
      "uucp"
      "plugdev"
      "audio"
    ];
    linger = true;
  };

  programs.zsh.enable = true;
}
