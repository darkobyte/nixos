# nixos

My NixOS configuration as a flake, with Home Manager, for two hosts: `laptop` and `workstation`.
The desktop runs on the Mango Wayland compositor with the Noctalia shell.

## Structure

```
.
├── flake.nix          # inputs and host definitions
├── users/             # one file per account: which hosts, admin or not, personal apps
├── hosts/
│   ├── laptop/        # default.nix (system), hardware-configuration.nix
│   └── workstation/
├── system/            # NixOS modules
│   ├── core/          # boot, nix, users, locale, networking, audio, packages
│   ├── desktop/       # mango, greetd, plymouth, graphics, theme
│   ├── development/   # docker, embedded
│   ├── gaming/        # steam
│   ├── hardware/      # bluetooth, power
│   └── services/      # ssh
├── home/              # Home Manager modules; default.nix is the base every user gets
├── config/            # dotfiles (mango, noctalia, kde)
└── assets/            # wallpapers
```

## Usage

```sh
sudo nixos-rebuild switch --flake .#laptop
sudo nixos-rebuild switch --flake .#workstation
```

## Users

Every `users/<name>.nix` becomes an account on the hosts it lists; delete the file and the
account is removed on the next rebuild (the home folder stays on disk).

```nix
# users/test.nix
{
  admin = false;                                  # sudo + `rebuild`
  initialPassword = "changeme";                   # first login only, then `passwd`
  apps = [ "entertainment/discord.nix" ];         # on every host below (paths under home/)
  hosts = { laptop = [ ]; workstation = [ "gaming" ]; };  # per-host extras
}
```

Everyone gets the base from `home/default.nix`: the Mango + Noctalia desktop, CLI, Firefox,
Nemo and the standard folders. Steam and Docker are enabled on a host only when a user there
has `gaming` / `development` apps.

Before using this on another machine, change `owner` in `flake.nix` and `networking.hostName` in `hosts/<name>/default.nix`, add your own `users/<name>.nix`, and replace `hardware-configuration.nix` with your own.
