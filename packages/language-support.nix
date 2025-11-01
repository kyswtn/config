{ pkgs, symlinkJoin }: symlinkJoin {
  name = "language-support";
  paths = with pkgs; [
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

    # HTML, CSS, JSON and TS/JS LSPs.
    vscode-langservers-extracted
    nodePackages.typescript-language-server

    # Generic mostly-web formatters.
    prettierd
    biome
  ];
}
