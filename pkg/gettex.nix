{pkgs, ...}:
pkgs.writeShellApplication {
  name = "gettex";

  runtimeInputs = with pkgs; [
    coreutils
    bash
    gnugrep
    curl
    gzip
    dateutils
    sqlite
    miller
  ];

  text = builtins.readFile ./gettex.sh;
}
