# nixos

My NixOS configuration as a flake, with Home Manager, for two hosts: `laptop` and `workstation`.
The desktop runs on the Mango Wayland compositor with the Noctalia shell.

## Structure

```
.
├── flake.nix          # inputs and host definitions
├── hosts/
│   ├── laptop/        # default.nix (system), home.nix (Home Manager), hardware-configuration.nix
│   └── workstation/
├── system/            # NixOS modules
│   ├── core/          # boot, nix, users, locale, networking, audio, packages
│   ├── desktop/       # mango, greetd, plymouth, graphics, theme
│   ├── development/   # docker, embedded
│   ├── gaming/        # steam
│   ├── hardware/      # bluetooth, power
│   └── services/      # ssh
├── home/              # Home Manager modules (browsers, cli, office, gaming, ...)
├── config/            # dotfiles (mango, noctalia, kde)
└── assets/            # wallpapers
```

## Usage

```sh
sudo nixos-rebuild switch --flake .#laptop
sudo nixos-rebuild switch --flake .#workstation
```

Before using this on another machine, change `username`, `hostname` and the other values in `fallbackEnv` in `flake.nix`, and replace `hardware-configuration.nix` with your own.
