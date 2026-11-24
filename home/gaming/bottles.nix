{ pkgs, ... }:
let
  bottles-unwrapped = pkgs.bottles-unwrapped.overrideAttrs (old: {
    # usebottles.com is broken for Bottles' own requests: the online check (ping.) is down with a
    # Cloudflare 522, and the repo proxy (proxy.) 403s pycurl's User-Agent-less requests. Either
    # one leaves first-run setup stuck on "Loading bottles…" forever, so go to GitHub directly,
    # which is what the proxy fronts anyway.
    postPatch = (old.postPatch or "") + ''
      substituteInPlace bottles/backend/utils/connection.py \
        --replace-fail '"https://ping.usebottles.com"' '"https://github.com"'
      substituteInPlace bottles/backend/managers/repository.py \
        --replace-fail 'https://proxy.usebottles.com/repo/components/' 'https://raw.githubusercontent.com/bottlesdevs/components/main' \
        --replace-fail 'https://proxy.usebottles.com/repo/dependencies/' 'https://raw.githubusercontent.com/bottlesdevs/dependencies/main' \
        --replace-fail 'https://proxy.usebottles.com/repo/programs/' 'https://raw.githubusercontent.com/bottlesdevs/programs/main'
    '';
  });
in
{
  # Wine prefix manager. The nixpkgs wrapper is an FHS env that already ships the
  # 32/64-bit Wine libs plus gamemode, gamescope and mangohud for the per-bottle toggles.
  home.packages = [
    # Drop the "unofficial package, don't report bugs upstream" popup on every launch
    (pkgs.bottles.override {
      inherit bottles-unwrapped;
      removeWarningPopup = true;
    })
  ];
}
