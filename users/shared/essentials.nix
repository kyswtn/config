{ flakeInputs, pkgs, system, ... }:
{
  programs.ssh = {
    enable = true;
    package = null;
    includes = [ "~/.ssh/extra_config" ];
  };

  programs.git = {
    enable = true;
    package = pkgs.git;
    settings = {
      init.defaultBranch = "main";
      commit.gpgSign = true;
      tag.gpgSign = true;
    };
    includes = [
      { path = "~/.gitconfig"; }
      { condition = "gitdir:~/git/"; path = "~/git/.gitconfig"; }
    ];
  };

  programs.ghostty = {
    enable = true;
    systemd.enable = false;
    package = null;
    settings = {
      command = "${pkgs.fish}/bin/fish";
      macos-titlebar-style = "tabs";
      theme = "Kitty Default";
      # Font, no bold.
      font-family = "Comic Code";
      font-size = 17;
      font-style = "Medium";
      font-style-bold = "Medium";
      adjust-cell-width = -1;
      adjust-cell-height = 5;
      # No changing or blinking cursor.
      cursor-style = "block";
      cursor-style-blink = false;
      shell-integration-features = "no-cursor,ssh-terminfo";
      # Enable OSC 52.
      clipboard-read = "allow";
      clipboard-write = "allow";
    };
  };

  programs.fish = {
    enable = true;
    package = pkgs.fish;
    plugins = [{
      name = "tide";
      src = pkgs.fishPlugins.tide.src;
    }];
    interactiveShellInit = ''
      # Turn off fish's greetings.
      set -g fish_greeting

      # Without this Ctrl-Z and fg don't work.
      set -Ux tide_jobs_number_threshold 1

      # If tide is not configured; configure it.
      if not set -q tide_character_icon
        tide configure \
          --auto \
          --style=Lean \
          --prompt_colors='16 colors' \
          --show_time=No \
          --lean_prompt_height='Two lines' \
          --prompt_connection=Disconnected \
          --prompt_spacing=Compact \
          --icons='Few icons' \
          --transient=No
      end
      set -U tide_character_icon ">"

      # Disable command_duration.
      set -U tide_right_prompt_items (string match -rv cmd_duration $tide_right_prompt_items)

      # Hide direnv logs.
      set -x DIRENV_LOG_FORMAT ""
    '';
    shellAbbrs = {
      rm = "trash";
    };
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
    '';
  };

  home.packages = with pkgs; [
    flakeInputs.self.packages.${system}.language-support
  ];
}
