{ pkgs, ... }:
{
  # CLI tools used by the shell aliases below
  home.packages = with pkgs; [
    eza
    bat
    fastfetch
    lazygit
  ];

  # Zsh configuration and aliases
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "eza -l --icons";
      la = "eza -la --icons";
      lt = "eza --tree --level=2 --icons";
      cat = "bat --paging=never";
      pulsar = "./pulsar.sh";
      gc = "nix-collect-garbage -d";
      # Remote hosts rarely ship foot's terminfo, so TERM=foot breaks clear/htop/vim there
      ssh = "TERM=xterm-256color ssh";
    };
    # Up/Down search history for lines starting with what's already typed
    historySubstringSearch.enable = true;
    history = {
      size = 50000;
      save = 50000;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };
    initContent = ''
      # Tab completion: arrow-key menu, case-insensitive and partial-word matching
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

      # PULSAR Environment
      if [ -z "$PULSAR_SHELL_INITIALIZED" ]; then
        export PULSAR_SHELL_INITIALIZED=1
      fi

      # fastfetch greeting, only in the first foot window: editor terminals (Zed,
      # VSCodium, ...) are ignored and get no greeting
      if [[ -o interactive && "$TERM" == foot* ]] \
        && (( $(pgrep -u "$USER" -x foot | wc -l) == 1 )); then
        fastfetch
      fi
    '';
  };

  # Fuzzy finder: Ctrl+R history, Ctrl+T files, Alt+C cd into a folder
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --exclude .git";
  };

  # `z <part of a path>` jumps to the best-matching folder you've visited, `zi` picks with fzf
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Starship prompt configuration (Clean & minimal)
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$character";
      directory = {
        style = "bold cyan";
        truncation_length = 3;
      };
      character = {
        success_symbol = "[❯](bold green) ";
        error_symbol = "[❯](bold red) ";
      };
      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
        style = "bold purple";
      };
    };
  };
}
