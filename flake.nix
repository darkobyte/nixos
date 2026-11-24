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
      envPath = ./.env.json;
      fallbackEnv = {
        username = "gianluca";
        hostname = "dumbledore";
        timezone = "Europe/Rome";
        locale = "en_US.UTF-8";
      };
      env =
        if builtins.pathExists envPath
        then builtins.fromJSON (builtins.readFile envPath)
        else fallbackEnv;

      # Builds hosts/<name>: default.nix is the system layer, home.nix the Home Manager layer
      mkHost = name: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs env;
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
              inherit inputs env;
            };
            home-manager.users.${env.username}.imports = [
              ./home
              ./hosts/${name}/home.nix
            ];
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
