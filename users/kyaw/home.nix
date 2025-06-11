{ pkgs, lib, config, features, ... }:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (pkgs.vscode-extensions) vscode-marketplace;

  credentials = import ../../credentials.nix;
  thisFlakeAbsolutePath = "${config.home.homeDirectory}/config";
in
{
  programs.ssh = {
    enable = true;
    package = null;
    includes = [ "~/.ssh/extra_config" ];
  };

  # PUBLICLY COMMITTED private key to only be used for testing purposes.
  # Fingers crossed I won't ever make a typo and expose my infrastructure public.
  home.file.".ssh/local_ssh".source =
    mkOutOfStoreSymlink "${thisFlakeAbsolutePath}/extras/local_ssh";

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
    delta = {
      enable = true;
      package = pkgs.delta;
    };
  };

  # Password manager & also an ssh-agent.
  # I don't use system default ssh-agent at all.
  programs._1password = {
    enable = true;
    cli.enable = true;
    # I'm using SSH Agent forward on the only Linux VM I have atm, so no need for SSH_AUTH_SOCK.
    enableSshAgent = isDarwin;
    enableGitSigning = true;
    sshKeys = [
      { vault = "Personal"; item = "SSH Key"; }
    ];
  };

  # Ghostty is the only terminal to work flawlessly with OSC 52 & DEC mode 2031.
  programs.ghostty = {
    enable = true;
    package = if isDarwin then null else pkgs.ghostty;
    settings = {
      command = "${pkgs.zellij}/bin/zellij options --default-shell ${pkgs.fish}/bin/fish";
      macos-option-as-alt = true;
      # I'm modifying Ghotty config a lot and i don't want
      # to have to reload home-manager always, therefore this symlink.
      config-file = "${thisFlakeAbsolutePath}/extras/ghostty.conf";
    };
  };

  # On macOS I don't chsh. I just use fish as main program for terminal/tmux/zellij.
  # That way I won't be locked out in case fish breaks.
  programs.fish = {
    enable = true;
    package = pkgs.fish;
    plugins = [
      # Very famous starship prompt is much slower compared to this, especially in git repos,
      # due to starship not being able to render git status asynchronously.
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

      # Disable command_duration.
      set --universal tide_right_prompt_items (string match -rv cmd_duration $tide_right_prompt_items)

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
  };

  # Switch shell envs based on directory.
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
    config = {
      log_format = "";
    };
  };

  programs.zellij = {
    enable = true;
    settings = { };
  };
  xdg.configFile."zellij".source =
    mkOutOfStoreSymlink "${thisFlakeAbsolutePath}/extras/zellij";

  # I don't use nix to manage neovim config, because i want to be able to use
  # neovim outside of nix; also because lazy.nvim works really well.
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
  };
  xdg.configFile."nvim".source =
    mkOutOfStoreSymlink "${thisFlakeAbsolutePath}/extras/nvim";

  # Helix is mostly here because i really like `--health` function which is like mason.nvim but 
  # outside of nvim where it actually makes sense because LSPs & formatters should be shared 
  # between editors.
  programs.helix = {
    enable = true;
    package = pkgs.helix;
    settings = {
      theme = "base16_transparent";
      editor = {
        line-number = "relative";
        cursor-shape.insert = "bar";
        auto-format = true;
      };
    };
  };

  # I love Visual Studio Code as much as i love Neovim, I also use it as much.
  # Nothing beats Neovim's simplicity. Nothing beats VS Code's extensions.
  programs.vscode = {
    enable = isLinux; # Install via Homebrew on macOS.
    package = pkgs.vscode;
    profiles.default.extensions = with vscode-marketplace; [
      vscodevim.vim
      mkhl.direnv
      frenco.vscode-vercel
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

  # Emacs.
  xdg.configFile."emacs".source =
    mkOutOfStoreSymlink "${thisFlakeAbsolutePath}/extras/emacs";

  # Flow - has the potential to become my next favourite text editor.
  xdg.configFile."flow".source =
    mkOutOfStoreSymlink "${thisFlakeAbsolutePath}/extras/flow";

  home.packages = with pkgs; [
    # I feel like all unix users expect me to have these.
    fastfetch
    htop
    fzf
    lf

    # These are faster coreutils replacements usually required by most tools like neovim & helix.
    fd
    ripgrep

    # These are also required by neovim and helix for syntax-highlighting and DAP.
    tree-sitter
    lldb

    # Modern versions of jq, ls and cat.
    jaq
    eza
    bat

    # Well, "modern" jaq sometimes don't work lol.
    jq

    # Darwin comes with a custom wrapped version of netcat-openbsd; i prefer netcat-gnu.
    # https://opensource.apple.com/source/netcat/netcat-49.40.1/netcat.c
    netcat-gnu

    # When I need to pipe a password to SSH directly from 1password without typing it in.
    sshpass

    # I like `xh :PORT` a lot; saves tons of time having to type `http://localhost:PORT`
    # and hurl replaces postman for me. Thinking about postman gives me PTSD.
    xh
    hurl

    # Favourite emulator.
    qemu

    # I use this for reviewing PRs and also for `gh browse`. Less commands to type, much convenient.
    gh

    # Benchmark stuff.
    hyperfine

    # For python slop. 
    uv

    # For javascript slop.
    bun
    nodejs_22

    # Handy scripts.
    (pkgs.writeShellScriptBin "rot13" ''
      tr 'A-Za-z' 'N-ZA-Mn-za-m'
    '')

    # Fonts.
    nerd-fonts.symbols-only
    noto-fonts
  ]
  ++ (lib.optional isDarwin darwin.trash)
  ++ (lib.optional isLinux trash-cli);

  imports = [ ]
    ++ (lib.optional features.language-support ./language-support.nix)
    ++ (lib.optional (builtins.pathExists ./secrets.nix) ./secrets.nix);

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
