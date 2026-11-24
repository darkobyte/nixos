{ pkgs, ... }:
{
  # Native compilers and build tools (also used by node-gyp for native npm addons)
  home.packages = with pkgs; [
    gcc
    gnumake
    cmake
    pkg-config
    python3
    rustup
    go
    ninja
    gdb
  ];
}
