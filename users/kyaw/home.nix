{ pkgs, lib, config, ... }:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (pkgs.vscode-extensions) vscode-marketplace;

  credentials = import ../../credentials.nix;
  thisFlakeAbsolutePath = "${config.home.homeDirectory}/config";
in
{
  # SSH should be installed at system-level.
  programs.ssh = {
    enable = true;
    package = null;
    includes = [ "~/.ssh/extra_config" ];
  };

  # GPG is only used for signing binaries and occassionally verifying them.
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
        condition = "gitdir:~/work";
        path = "~/work/.gitconfig";
      }
    ];
    delta = {
      enable = true;
      package = pkgs.delta;
    };
  };

  # Password manager and SSH agent.
  programs._1password = {
    enable = true;
    cli.enable = true;
    enableSshAgent = true;
    enableGitSigning = true;
    sshKeys = [
      { vault = "Personal"; item = "SSH Key"; }
    ];
  };

  programs.ghostty = {
    enable = true;
    package = if isDarwin then null else pkgs.ghostty;
    settings = {
      command = "${pkgs.zellij}/bin/zellij options --default-shell ${pkgs.fish}/bin/fish";
      config-file = "${thisFlakeAbsolutePath}/extras/ghostty.conf";
    };
  };

  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
    settings = { };
  };
  xdg.configFile."zellij".source =
    mkOutOfStoreSymlink "${thisFlakeAbsolutePath}/extras/zellij";

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
      set --universal tide_right_prompt_items (string match -rv cmd_duration $tide_right_prompt_items)

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

  programs.vscode = {
    enable = isLinux;
    package = pkgs.vscode;
    profiles.default.extensions = with vscode-marketplace; [
      vscodevim.vim
      mkhl.direnv
    ];
  };

  # On macOS, VS Code is installed externally becuase i want to modify interface font but 
  # settings and keybindings are still synced with this.
  vscode-config-dir = {
    enable = true;
    packageName = "vscode";
    userSettingsFile = "${thisFlakeAbsolutePath}/extras/vscode/settings.jsonc";
    keybindingsFile = "${thisFlakeAbsolutePath}/extras/vscode/keybindings.jsonc";
  };

  programs.gh = {
    enable = true;
    package = pkgs.gh;
  };

  home.packages = with pkgs; [
    # Fonts - Sans, Serif, Mono, Fallback and Icons.
    paratype-pt-sans
    source-serif
    ibm-plex
    noto-fonts
    nerd-fonts.symbols-only

    # When I need to pipe a password to SSH directly from 1password without typing it in.
    sshpass

    # Preferred C compiler and Make needed for most tools.
    clang
    gnumake

    # These are usually required by text editors such as neovim.
    fd
    ripgrep
    tree-sitter
    lldb

    # Colorful ls and cat replacements.
    eza
    bat

    # CLI text manipulation tools.
    jq

    # Handy scripts.
    (pkgs.writeShellScriptBin "rot13" ''
      tr 'A-Za-z' 'N-ZA-Mn-za-m'
    '')

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
  ]
  ++ (lib.optional isDarwin darwin.trash)
  ++ (lib.optional isLinux trash-cli);

  imports = [ ]
    ++ (lib.optional (builtins.pathExists ./secrets.nix) ./secrets.nix);

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
