{
  "wsl" = [
    #./profiles/spass.nix

    ./profiles/bpfverify.nix
    ./profiles/common.nix
    ./profiles/development.nix
    ./profiles/latex.nix
    ./profiles/mpi-klsb.nix
    ./profiles/radicle.nix
    ./profiles/sops
    ./profiles/summer-of-nix.nix
    ./profiles/terminal.nix
    ./profiles/wsl.nix
    ./programs/atuin.nix
    ./programs/vscode.nix
    ./services/radicle.nix
  ];

  "0mqr267g9pkn4i0dfgs03y0w3anzrhnr44jz4k0x0n19k4xwgbgn" = [
    ./profiles/junk.nix
    ./profiles/common.nix
    ./profiles/development.nix
    ./profiles/gaming.nix
    ./profiles/latex.nix
    ./profiles/mpi-klsb.nix
    ./profiles/radicle.nix
    #./services/v4lbridge.nix
    ./profiles/sops
    ./profiles/spass.nix
    ./profiles/summer-of-nix.nix
    ./programs/atuin.nix
    ./services/radicle.nix
  ];

  "nc" = [
    ./profiles/common.nix
    ./profiles/sops
    ./profiles/terminal.nix
    ./programs/atuin.nix

    {services.radicle-mirror = {};}
  ];
}
