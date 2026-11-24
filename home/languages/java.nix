{ pkgs, ... }:
{
  # Java Development Kit (OpenJDK 21 LTS), also sets JAVA_HOME
  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  home.packages = with pkgs; [
    maven
    gradle
  ];
}
