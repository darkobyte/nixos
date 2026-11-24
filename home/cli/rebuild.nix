{ config, pkgs, ... }:
let
  repo = "${config.home.homeDirectory}/nixos";

  # rebuild <host> [donotpush] [-m "message"]
  # Pulls, switches to hosts/<host>, and on success commits local changes and pushes.
  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    set -euo pipefail

    usage() {
      echo "usage: rebuild <host> [donotpush] [-m \"commit message\"]" >&2
      echo "hosts: $(ls ${repo}/hosts | tr '\n' ' ')" >&2
      exit 1
    }

    host="" push=1 msg=""
    while (( $# )); do
      case "$1" in
        donotpush|--no-push) push=0 ;;
        -m) shift; msg="''${1:-}" ;;
        -h|--help) usage ;;
        *) [[ -z "$host" ]] && host="$1" || usage ;;
      esac
      shift
    done
    [[ -n "$host" && -d "${repo}/hosts/$host" ]] || usage

    cd ${repo}

    echo ":: pulling"
    git pull --rebase --autostash

    # Flakes only see tracked files, so new modules must be in the index to build
    git add -A

    echo ":: building $host"
    sudo nixos-rebuild switch --flake ".#$host"

    if (( ! push )); then
      echo ":: build ok, not pushing (changes left staged)"
      exit 0
    fi

    if ! git diff --cached --quiet; then
      git status --short
      if [[ -z "$msg" ]]; then
        read -rp "commit message [chore($host): rebuild]: " msg
      fi
      git commit -q -m "''${msg:-chore($host): rebuild}"
    fi

    if [[ -n "$(git log --oneline @{u}..)" ]]; then
      echo ":: pushing"
      git push
    else
      echo ":: build ok, nothing to push"
    fi
  '';
in
{
  home.packages = [ rebuild ];
}
