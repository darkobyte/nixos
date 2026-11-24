{ lib, env, ... }:
{
  # Git user settings loaded from env
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
    } // lib.optionalAttrs (env ? fullName) {
      user.name = env.fullName;
    } // lib.optionalAttrs (env ? email) {
      user.email = env.email;
    } // {
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
