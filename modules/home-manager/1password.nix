{ config, lib, pkgs, ... }:
with lib;
let
  inherit (pkgs.stdenv) isDarwin;
  filterOutNullValues = a: attrsets.filterAttrsRecursive (k: v: v != null) a;

  cfg = config.programs._1password;
  tomlFormat = pkgs.formats.toml { };
  sshKeyModule = types.submodule {
    options = {
      item = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The item name or ID.
        '';
      };
      account = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The account name sign-in address or ID
        '';
      };
      vault = mkOption {
        type = types.str;
        default = null;
        description = ''
          The vault name or ID.
        '';
      };
    };
  };
in
{
  options.programs._1password = {
    enable = mkEnableOption "1password";

    package = mkOption {
      type = types.package;
      default = pkgs._1password-gui;
      defaultText = literalExpression "pkgs._1password-gui";
      description = ''
        Version of 1Password to install.
      '';
    };

    cli = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable 1Password CLI.
        '';
      };

      package = mkPackageOption pkgs "_1password-cli" { };
    };

    enableSshAgent = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable 1Password's SSH agent as SSH_AUTH_SOCK.
      '';
    };

    sshKeys = mkOption {
      type = types.listOf sshKeyModule;
      default = [ ];
      example = literalExpression ''
        [
          { item = "Git Authentication Key"; vault = "Work"; }
          { item = "Git Signing Key"; vault = "Work"; }
        ]
      '';
      description = "List of ssh keys for 1Password's SSH agent to use.";
    };

    enableGitSigning = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable signing commits and tags with SSH keys.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # Manually install 1Password on Darwin :(
      # https://github.com/NixOS/nixpkgs/issues/254944
      # https://1password.community/discussion/108493/browser-not-inside-applications-folder
      home.packages = if isDarwin then [ ] else [ cfg.package ];

      home.sessionVariables = mkIf cfg.enableSshAgent {
        SSH_AUTH_SOCK =
          if isDarwin then
            "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
          else
            "${config.home.homeDirectory}/.1password/agent.sock";
      };

      xdg.configFile."1Password/ssh/agent.toml" = mkIf (cfg.sshKeys != [ ]) {
        source = tomlFormat.generate "1password-ssh-agents-config" {
          ssh-keys = lists.map filterOutNullValues cfg.sshKeys;
        };
      };

      programs.git.extraConfig = mkIf cfg.enableGitSigning {
        gpg.format = "ssh";
        gpg.ssh.program =
          if isDarwin then
          # This will be changed once 1Password can be installed on Darwin via Nixpkgs.
            "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
          else
            "${cfg.package}/bin/op-ssh-sign";
      };
    }
    (mkIf cfg.cli.enable {
      home.packages = [ cfg.cli.package ];
    })
  ]);
}
