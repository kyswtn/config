# These adds LSPs and formatters, nice to have but not necessary at all.

{ pkgs, ... }: {

  home.packages = with pkgs; [
    # Nix LSP & formatter.
    nil
    nixpkgs-fmt

    # Bash LSP & formatter.
    bash-language-server
    shfmt

    # Lua LSP & formatter.
    lua-language-server
    stylua

    # TUI markdown viewer and markdown LSP.
    glow
    marksman

    # HTML+CSS+JSON and TS/JS LSPs.
    # VSCode comes with these out-of-the-box.
    vscode-langservers-extracted
    nodePackages.typescript-language-server

    # Generic mostly-web formatters.
    prettierd
    biome

    # Sysadmin must-haves.
    yaml-language-server
    dockerfile-language-server-nodejs

    # I've switched to OpenTofu, but sometimes need Terraform for formatting.
    # terraform
  ];

  # Helix doesn't come with auto-format for most languages, but I love auto-format on save.
  # Turning them on as much as I can!
  programs.helix.languages = {
    language = [
      {
        name = "nix";
        auto-format = true;
        formatter = { command = "nixpkgs-fmt"; args = [ ]; };
      }
      {
        name = "lua";
        auto-format = true;
      }
      {
        name = "yaml";
        auto-format = true;
        formatter = { command = "prettierd"; args = [ "_.yaml" ]; };
      }
      {
        name = "typescript";
        auto-format = true;
      }
    ];
  };
}
