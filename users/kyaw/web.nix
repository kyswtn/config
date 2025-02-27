{ pkgs, ... }: {
  home.packages = with pkgs; [

    # HTML+CSS+JSON and TS/JS LSPs.
    vscode-langservers-extracted
    nodePackages.typescript-language-server

    # JS runtimes.
    bun
    nodejs_22
  ];
}
