{
  pkgs,
  ...
}: pkgs.writeShellApplication {
    name = "gettex";

    runtimeInputs = with pkgs; [
      bash
      curl
      dateutils
      sqlite
    ];

    text = builtins.readFile ./gettex.sh;
  }
