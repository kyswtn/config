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
    delta = {
      enable = true;
      package = pkgs.delta;
    };
  };

  # Password manager & also an ssh-agent.
  # I don't use system default ssh-agent at all.
  programs._1password = {
    enable = true;
    enableSshAgent = true;
    enableGitSigning = true;
    sshKeys = [
      { vault = "Personal"; item = "SSH Key"; }
    ];
  };

  # I don't chsh. I just use my terminal emulator to specify fish as main program.
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

      # If tide is not configured; configure it.
      if not set -q tide_character_icon
        tide configure \
          --auto \
          --style=Lean \
          --prompt_colors='True color' \
          --show_time=No \
          --lean_prompt_height='Two lines' \
          --prompt_connection=Disconnected \
          --prompt_spacing=Compact \
          --icons='Few icons' \
          --transient=No
      end

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

  # My favourite terminal emulator.
  programs.ghostty = {
    enable = true;
    package = if isLinux then pkgs.ghostty else null;
    settings = {
      command = "${pkgs.fish}/bin/fish";
      macos-option-as-alt = true;
      # I'm beta-testing ghostty so i'm modifying the config a lot and i don't want
      # to have to reload home-manager always, therefore this symlink.
      config-file = "${thisFlakeAbsolutePath}/extras/ghostty.conf";
    };
  };

  # Switch shell envs based on directory.
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  # I don't use nix to manage neovim config, because i want to be able to use
  # neovim outside of nix; also because i really like lazy.nvim.
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
  };
  xdg.configFile."nvim".source =
    mkOutOfStoreSymlink "${thisFlakeAbsolutePath}/extras/nvim";

  # I don't have a lot of git integrations configured in neovim. I use GitUI.
  programs.gitui = {
    enable = true;
    package = pkgs.gitui;
  };

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
    enable = isLinux;
    package = pkgs.vscode;
    extensions = with vscode-marketplace; [
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

  # Orbstack replaces docker for me. I also use LXC machines a lot because they're faster and 
  # easier to spin up than traditional VMs.
  programs.orbstack = {
    enable = isDarwin;
    package = null;
  };

  # Some of my machines use Gnome on NixOS because it's the simplest to setup.
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      font-name = "Monaspace Krypton 10";
      monospace-font-name = "Monaspace Krypton 10";
      enable-animations = false;
    };
  };

  home.packages = with pkgs; [
    # I feel like all unix users expect me to have these.
    fastfetch
    htop
    fzf
    lf

    # These are faster coreutils replacements usually required by most tools like neovim & helix.
    fd
    ripgrep

    # Modern versions of jq, ls and cat.
    jaq
    eza
    bat

    # Well, "modern" jaq sometimes don't work lol.
    jq

    # Darwin comes with a custom wrapped version of netcat-openbsd; i prefer netcat-gnu.
    # https://opensource.apple.com/source/netcat/netcat-49.40.1/netcat.c
    netcat-gnu

    # Most add syntax-highlighting to man pages which i really like.
    most

    # TUI markdown viewer and markdown LSP.
    glow
    marksman

    # When I need to pipe a password to SSH directly from 1password without typing it in.
    sshpass

    # Colorful hexdump.
    _0x

    # I like `xh :PORT` a lot; saves tons of time having to type `http://localhost:PORT`
    # and hurl replaces postman for me. Thinking about postman gives me PTSD.
    xh
    hurl

    # Nix & friends.
    nil
    nixpkgs-fmt

    # Bash LSP & formatter.
    bash-language-server
    shfmt

    # These are only here for neovim configs.
    lua-language-server
    stylua
    tree-sitter

    # Required by neovim & helix for DAP.
    lldb

    # Favorite monospace fonts.
    roboto-mono
    inconsolata
    monaspace
    jetbrains-mono
    agave

    # My webistes' DNS, provisioning, and deployment is managed via Terraform.
    terraform
    terraform-ls

    # I use nerd fonts separately, instead of patched versions. Thanks ghostty!
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })

  ]
  ++ (lib.optional isDarwin darwin.trash)
  ++ (lib.optional isLinux trash-cli);

  imports = [ ]
    ++ (lib.optional features.web ./web.nix)
    ++ (lib.optional (builtins.pathExists ./secrets.nix) ./secrets.nix);

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
