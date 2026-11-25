{ lib, user, ... }:
{
  # Git identity from users/<name>.nix (fullName, email)
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = lib.optionalAttrs (user ? fullName) { name = user.fullName; }
        // lib.optionalAttrs (user ? email) { email = user.email; };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # GitHub CLI, also registered as git credential helper for github.com and gist.github.com
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
}
