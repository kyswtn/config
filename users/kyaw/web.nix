{ pkgs, ... }: {
  home.packages = with pkgs; [

    # HTML+CSS+JSON and TS/JS LSPs.
    vscode-langservers-extracted
    nodePackages.typescript-language-server

    # Begone prettier, begone eslint.
    biome

    # JS runtimes.
    bun
    nodejs_22
  ];
}
