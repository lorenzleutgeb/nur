{ pkgs, super, ... }:

let
  mkcert = pkgs.mkcert;
  root = {
    cert = super.environment.etc."mkcert/rootCA.pem";
    key = super.environment.etc."mkcert/rootCA-key.pem";
  };
  #root = pkgs.runCommand "root" { buildInputs = [ mkcert ]; } ''
  #  CAROOT=$out TRUST_STORES=system mkcert -install
  #'';
in {
  home.packages = [ mkcert ];

  xdg.dataFile."mkcert/rootCA.pem".source = root.cert.source;
  xdg.dataFile."mkcert/rootCA-key.pem".source = root.key.source;
}
