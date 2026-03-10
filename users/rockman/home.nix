{ pkgs, ... }: {
  programs._1password = {
    enable = true;
    cli.enable = true;
    enableSshAgent = true;
    enableGitSigning = true;
  };

  programs.claude-code = {
    enable = true;
    package = pkgs.claude-code;
  };
}
