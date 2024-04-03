{
  "wsl" = [
    ./profiles/common.nix
    ./profiles/latex.nix
    ./profiles/mpi-klsb.nix
    ./profiles/terminal.nix
    ./profiles/spass.nix
    ./profiles/summer-of-nix.nix
    ./programs/vscode.nix
    ./profiles/wsl.nix
    #./profiles/vtsa.nix
  ];

  "0mqr267g9pkn4i0dfgs03y0w3anzrhnr44jz4k0x0n19k4xwgbgn" = [
    ./profiles/common.nix
    ./profiles/development.nix
    ./profiles/gaming.nix
    ./profiles/latex.nix
    ./profiles/mpi-klsb.nix
    #./services/v4lbridge.nix
    ./profiles/spass.nix
    ./profiles/summer-of-nix.nix
    ./profiles/gettex.nix
  ];

  "nc" = [
    ./profiles/common.nix
    ./profiles/terminal.nix
    ./profiles/gettex.nix
    ({
      pkgs,
      lib,
      ...
    }: {
      # TODO: This is quite hacky, remove once leutgeb.xyz has moved to nc.
      systemd.user.services."gettex".Service.ExecStop = "${lib.getExe pkgs.bash} -c 'gettex query-all | tee /var/www/falsum.org/gettex.json'";
    })
  ];
}
