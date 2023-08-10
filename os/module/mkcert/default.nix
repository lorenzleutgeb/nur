{
  pkgs,
  config,
  ...
}: let
  mkcert = pkgs.mkcert;
  root = pkgs.runCommand "root" {buildInputs = [mkcert];} ''
    CAROOT=$out TRUST_STORES=system mkcert -install
  '';
  secretPath = "/run/secrets/mkcert";

  secretConfig = {
    sopsFile = ./sops/mkcert.yaml;
    group = config.users.groups.mkcert.name;
    mode = "0440";
  };
in {
  imports = [../sops.nix];

  users.groups.mkcert = {name = "mkcert";};

  sops.secrets = {
    "mkcert/rootCA.pem" = secretConfig;
    "mkcert/rootCA-key.pem" = secretConfig;
  };

  environment = {
    systemPackages = [mkcert];
    variables.CAROOT = secretPath;
  };
  security.pki.certificateFiles = ["${secretPath}/rootCA.pem"];

  # NOTE: For bootstrapping, mkcert can be used to generate the root CA.
  # comment out the two respective lines above, and nixos-rebuild switch
  # to generate `/etc/mkcert/rootCA{,-key}.pem`.
  #environment.etc."mkcert/rootCA-key.pem".source = "${root}/rootCA-key.pem";
  #environment.etc."mkcert/rootCA.pem".source = "${root}/rootCA.pem";
}
