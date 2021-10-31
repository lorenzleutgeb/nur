{ pkgs, ... }:

let
  mkcert = pkgs.mkcert;
  root = pkgs.runCommand "root" { buildInputs = [ mkcert ]; } ''
    CAROOT=$out TRUST_STORES=system mkcert -install
  '';
in {
  environment.systemPackages = [ mkcert ];
  environment.etc."mkcert/rootCA-key.pem".source = "${root}/rootCA-key.pem";
  environment.etc."mkcert/rootCA.pem".source = "${root}/rootCA.pem";
  security.pki.certificateFiles = [ "${root}/rootCA.pem" ];
}
