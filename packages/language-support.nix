{ pkgs, symlinkJoin, ... }: symlinkJoin {
  name = "language-support";
  paths = with pkgs; [
    nil
    nixpkgs-fmt

    bash-language-server
    shfmt

    lua-language-server
    stylua

    taplo
    yaml-language-server
    dockerfile-language-server

    vscode-langservers-extracted
    nodePackages.typescript-language-server
    astro-language-server

    prettierd
    biome
  ];
}
