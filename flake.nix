{
  description = "PULSAR - Systemic Modular NixOS Infrastructure & Deployment Framework";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, antigravity-nix, noctalia, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;

      # Owns the config repo (~/nixos): autopull, login default, trusted Nix user
      owner = "gianluca";

      # Accounts: every users/<name>.nix is picked up automatically
      userFiles = lib.filterAttrs (file: type: type == "regular" && lib.hasSuffix ".nix" file)
        (builtins.readDir ./users);
      users = lib.mapAttrs' (file: _:
        lib.nameValuePair (lib.removeSuffix ".nix" file) (import ./users/${file})
      ) userFiles;

      # Accounts on one host, with their app list resolved (shared apps + this host's)
      usersOn = host: lib.mapAttrs (name: u: removeAttrs u [ "hosts" ] // {
        inherit name;
        admin = u.admin or false;
        apps = (u.apps or [ ]) ++ u.hosts.${host};
      }) (lib.filterAttrs (_: u: (u.hosts or { }) ? ${host}) users);

      # Builds hosts/<name> (system layer) with every account from users/ that lists it
      mkHost = name:
        let
          hostUsers = usersOn name;
        in
        nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs owner hostUsers;
          # Users on this host whose apps include home/<prefix> (e.g. "gaming"):
          # system features like Steam or Docker turn on only when someone needs them
          usersNeeding = prefix: lib.attrNames (lib.filterAttrs (_: u:
            lib.any (app: app == prefix || lib.hasPrefix "${prefix}/" app) u.apps
          ) hostUsers);
        };
        modules = [
          {
            nixpkgs.overlays = [
              antigravity-nix.overlays.default
              (final: prev:
                let
                  unstable = import inputs.nixpkgs-unstable {
                    system = prev.stdenv.hostPlatform.system;
                    config.allowUnfree = true;
                  };
                in {
                  claude-code = unstable.claude-code;
                  # 26.05 ships mango 0.12, which lacks the IPC socket Noctalia uses for workspaces
                  mangowc = unstable.mangowc;
                  photocraft = unstable.photocraft;
                  filmcraft = unstable.filmcraft;
                  soundcraft = unstable.soundcraft;
                  wordcraft = unstable.wordcraft;
                  gridcraft = unstable.gridcraft;
                  deckcraft = unstable.deckcraft;
                  pdfcraft = unstable.pdfcraft;
                })
            ];
          }
          ./hosts/${name}
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
            # Base profile for everyone (home/default.nix) + the user's own apps
            home-manager.users = lib.mapAttrs (_: user: {
              _module.args.user = user;
              imports = [
                ./home
                { imports = map (app: ./home + "/${app}") user.apps; }
              ];
            }) hostUsers;
          }
        ];
      };
    in
    {
      nixosConfigurations = {
        workstation = mkHost "workstation";
        laptop = mkHost "laptop";
      };
    };
}
