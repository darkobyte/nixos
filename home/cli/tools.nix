{ pkgs, ... }:
{
  # Everyday command line utilities
  home.packages = with pkgs; [
    # Network
    wget
    rsync

    # Hardware info
    pciutils
    usbutils
    lsof

    # Archives (zip, rar, 7z, tar.zst/xz, ...)
    zip
    unzip
    p7zip
    unrar
    zstd
    xz

    # Search, inspect, monitor
    jq
    htop
    btop
    ripgrep
    fd
    tree
    ncdu
    kdePackages.filelight # graphical ncdu: ring chart of what eats disk space
    file
    which
    tldr
  ];
}
