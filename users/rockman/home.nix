{ ... }: {
  programs._1password = {
    enable = true;
    cli.enable = true;
    enableSshAgent = true;
    enableGitSigning = true;
  };
}
