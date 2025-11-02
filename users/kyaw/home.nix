{ system, pkgs, lib, config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  os = (builtins.elemAt (builtins.split "-" system) 2);

  credentials = import ../../credentials.nix;
  thisFlakeAbsolutePath = "${config.home.homeDirectory}/config";
in
{
  programs.ghostty = {
    enable = true;
    package = null;
    settings = {
      command = "${pkgs.tmux}/bin/tmux";
      config-file = "${thisFlakeAbsolutePath}/extras/ghostty.conf";
    };
  };

  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    escapeTime = 0;
    extraConfig = ''
      set -sg escape-time 0 
      set -g status-interval 0
      set -g default-shell ${pkgs.fish}/bin/fish
    '';
  };

  programs.fish = {
    enable = true;
    package = pkgs.fish;
    plugins = [
      # Tide is one of the very few prompts that can asynchronously render
      # and therefore feels significantly faster on refreshes.
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
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
      set --universal tide_character_icon ">"

      # Disable command_duration.
      set -U tide_right_prompt_items (string match -rv cmd_duration $tide_right_prompt_items)

      # Hide direnv logs.
      # set -x DIRENV_LOG_FORMAT ""

      # I once accidentally `rm -rf` all my assignments. Lesson learned.
      if type -q trash
        abbr -a rm "trash"
      end
    '';
  };

  programs.ssh = {
    enable = true;
    package = null;
    includes = [ "~/.ssh/extra_config" ];
  };

  programs.git =
    let
      mkIncludes = lib.mapAttrsToList (path: contents: {
        condition = "gitdir:${path}";
        contents = contents;
      });
    in
    {
      enable = true;
      package = pkgs.git;
      userName = credentials.name;
      userEmail = credentials.email;
      signing.key = credentials.sshKeys.main;
      extraConfig = {
        init.defaultBranch = "main";
        commit.gpgSign = true;
        tag.gpgSign = true;
      };
      includes = mkIncludes {
        "~/work/" = { user.signingKey = credentials.sshKeys.work; };
      };
      delta = {
        enable = true;
        package = pkgs.delta;
      };
    };

  programs._1password = {
    enable = true;
    cli.enable = true;
    enableSshAgent = true;
    enableGitSigning = true;
    sshKeys = [
      { vault = "Personal"; item = "SSH Key"; }
      { vault = "Work"; item = "work-work-work-work-work"; }
    ];
  };

  programs.fzf = {
    enable = true;
    package = pkgs.fzf;
  };

  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
  };
  xdg.configFile."nvim".source =
    mkOutOfStoreSymlink "${thisFlakeAbsolutePath}/extras/nvim";

  home.packages = with pkgs; [
    # Preferred C compiler and Make needed for most tools.
    clang
    gnumake

    # These are usually required by text editors such as neovim and plugins.
    fd
    ripgrep
    tree-sitter
    lldb

    # Colorful ls and cat replacements.
    eza
    bat

    # CLI text manipulation tools and handy scripts.
    jq
    (writeShellScriptBin "rot13" "tr 'A-Za-z' 'N-ZA-Mn-za-m'")

    # For networking.
    netcat-gnu

    # When I need to pipe a password to SSH directly from 1password without typing it in.
    sshpass

    # For emulations.
    qemu

    # For benchmarkings.
    hyperfine

    # Fonts.
    geist-font
    source-serif
    monaspace
    noto-fonts
    noto-fonts-color-emoji
    font-awesome
    nerd-fonts.symbols-only
  ];

  imports = [ ]
    ++ (lib.optional (os == "linux") ./linux.nix)
    ++ (lib.optional (builtins.pathExists ./secrets.nix) ./secrets.nix);

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
