# Home-manager's vscode module patched to be able to accept symlink
# config files so that they're editable from within vscode.
{ config, lib, pkgs, ... }:
with lib;
let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  cfg = config.vscode-config-dir;
  vscodePname = cfg.packageName;

  configDir = {
    "vscode" = "Code";
    "vscode-insiders" = "Code - Insiders";
    "vscodium" = "VSCodium";
  }.${vscodePname};

  userDir =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "Library/Application Support/${configDir}/User"
    else
      "${config.xdg.configHome}/${configDir}/User";

  configFilePath = "${userDir}/settings.json";
  tasksFilePath = "${userDir}/tasks.json";
  keybindingsFilePath = "${userDir}/keybindings.json";
in
{
  options.vscode-config-dir = {
    enable = mkEnableOption "vscode-config-dir";

    packageName = mkOption {
      type = types.str;
      default = null;
      description = "vscode, vscode-insiders, or vscodium";
    };

    userSettingsFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The absolute path of the vscode user settings json file.";
    };

    userTasksFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The absolute path of the vscode user tasks json file.";
    };

    keybindingsFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The absolute path of the vscode user keybindings json file.";
    };
  };

  config = mkIf cfg.enable {
    home.file = mkMerge [
      (mkIf (cfg.userSettingsFile != null) {
        "${configFilePath}".source = mkOutOfStoreSymlink cfg.userSettingsFile;
      })
      (mkIf (cfg.userTasksFile != null) {
        "${tasksFilePath}".source = mkOutOfStoreSymlink cfg.userTasksFile;
      })
      (mkIf (cfg.keybindingsFile != null) {
        "${keybindingsFilePath}".source = mkOutOfStoreSymlink cfg.keybindingsFile;
      })
    ];
  };
}
