{ system, pkgs, lib, config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  arch = (builtins.elemAt (builtins.split "-" system) 0);
  os = (builtins.elemAt (builtins.split "-" system) 2);

  credentials = import ../../credentials.nix;
  thisFlakeAbsolutePath = "${config.home.homeDirectory}/config";
in
{
  programs.ssh = {
    enable = true;
    package = null;
    includes = [ "~/.ssh/extra_config" ];
  };

  programs.gpg = {
    enable = true;
    package = pkgs.gnupg;
  };

  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = credentials.name;
    userEmail = credentials.email;
    signing.key = credentials.primarySshKey;
    extraConfig = {
      init.defaultBranch = "main";
      commit.gpgSign = true;
      tag.gpgSign = true;
    };
    includes = [
      {
        condition = "gitdir:~/work/";
        path = "~/work/.gitconfig";
      }
    ];
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

  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    settings = {
      command = "${pkgs.fish}/bin/fish";
      config-file = "${thisFlakeAbsolutePath}/extras/ghostty.conf";
    };
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
      set -x DIRENV_LOG_FORMAT ""

      # I once accidentally `rm -rf` all my assignments. Lesson learned.
      if type -q trash
        abbr -a rm "trash"
      end

      # Set bat's theme.
      export BAT_THEME="ansi"
    '';
  };

  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    escapeTime = 0;
    extraConfig = ''
      set -sg escape-time 0 
      set -g status-interval 0
    '';
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

  programs.gh = {
    enable = true;
    package = pkgs.gh;
  };

  # Text editors and their configs.

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
  };
  xdg.configFile."nvim".source =
    mkOutOfStoreSymlink "${thisFlakeAbsolutePath}/extras/nvim";

  programs.helix = {
    enable = true;
    package = pkgs.helix;
  };
  xdg.configFile."helix".source =
    mkOutOfStoreSymlink "${thisFlakeAbsolutePath}/extras/helix";

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
  };
  xdg.configFile."emacs".source =
    mkOutOfStoreSymlink "${thisFlakeAbsolutePath}/extras/emacs";

  xdg.configFile."flow".source =
    mkOutOfStoreSymlink "${thisFlakeAbsolutePath}/extras/flow";

  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
  };

  programs.vscode = {
    enable = os == "linux";
    package = pkgs.vscode;
    mutableExtensionsDir = true;
  };

  # VSCode's configurations are managed by this patch, to allow editing of it
  # within the editor.
  vscode-config = {
    enable = true;
    packageName = "vscode";
    userSettingsFile = "${thisFlakeAbsolutePath}/extras/vscode/settings.jsonc";
    keybindingsFile = "${thisFlakeAbsolutePath}/extras/vscode/keybindings.jsonc";
  };

  home.packages = with pkgs; [
    # Preferred C compiler and Make needed for most tools.
    clang
    gnumake

    # Fonts - Sans, Serif, Mono, Fallback, Emoji and Icons.
    geist-font
    source-serif
    input-fonts
    noto-fonts
    noto-fonts-color-emoji
    font-awesome
    nerd-fonts.symbols-only

    # Extra fonts.
    libertinus
    monaspace

    # Browser.
    brave

    # When I need to pipe a password to SSH directly from 1password without typing it in.
    sshpass

    # These are usually required by text editors such as neovim.
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

    # Markdown LSP.
    marksman

    # Nix LSP & formatter.
    nil
    nixpkgs-fmt

    # Bash LSP & formatter.
    bash-language-server
    shfmt

    # Lua LSP & formatter.
    lua-language-server
    stylua

    # TOML, YAML, and Dockerfile LSPs for system configurations.
    taplo
    yaml-language-server
    dockerfile-language-server-nodejs

    # JS runtimes.
    bun
    nodejs_24

    # HTML, CSS, JSON and TS/JS LSPs.
    vscode-langservers-extracted
    nodePackages.typescript-language-server

    # Generic mostly-web formatters.
    prettierd
    biome

    # Rust with LSP & formatter.
    (rust-bin.stable.latest.default.override { extensions = [ "rust-src" "rust-analyzer" ]; })

    # Python with LSP & formatter.
    python3
    ruff

    # ...
    netcat-gnu
    qemu
    hyperfine

    # Games.
    prismlauncher
  ]
  ++ (lib.optionals (system != "aarch64-linux") [
    slack
    discord
  ]);

  imports = [ ]
    ++ (lib.optional (os == "linux") ./linux.nix)
    ++ (lib.optional (builtins.pathExists ./secrets.nix) ./secrets.nix);

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
