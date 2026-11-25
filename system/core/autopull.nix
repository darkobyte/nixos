{ pkgs, owner, ... }:
let
  repo = "/home/${owner}/nixos";
in
{
  # Pulls the config repo once the network is up after boot. Fast-forward only:
  # a diverged or conflicting checkout is left alone for `rebuild` to sort out.
  systemd.services.nixos-config-pull = {
    description = "Pull the NixOS config repo";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    path = [ pkgs.git pkgs.openssh ];
    serviceConfig = {
      Type = "oneshot";
      User = owner;
      WorkingDirectory = repo;
    };
    # Wi-Fi can come up well after network-online, so retry for ~5 minutes
    script = ''
      for _ in $(seq 20); do
        git -c pull.rebase=false pull --ff-only && exit 0
        sleep 15
      done
      exit 1
    '';
  };
}
