{ ... }: {
  programs._1password = {
    enable = true;
    cli.enable = true;
    enableGitSigning = true;
    # Alesis is on a VPS over SSH. It gets forwarded agent from parent.
    enableSshAgent = false;
  };
}
