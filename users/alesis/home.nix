{ pkgs, ... }: {
  programs._1password = {
    enable = true;
    cli.enable = true;
    enableGitSigning = true;
    # Alesis is on a VPS over SSH. It gets forwarded agent from parent.
    enableSshAgent = false;
  };

  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    extraConfig = ''
      set -sg escape-time 0
      set -g status-interval 0
      set -g default-shell ${pkgs.fish}/bin/fish

      set -g default-terminal 'xterm-ghostty'
      set -s extended-keys on
      set -as terminal-features 'xterm*:extkeys'
      set -g set-clipboard on
    '';
  };
}
