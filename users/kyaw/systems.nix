{ pkgs, ... }: {
  home.packages = with pkgs; [
    zig
    zls

    rustup
    grafana
  ];
}
