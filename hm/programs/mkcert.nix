{ pkgs, super, ... }:

{
  home.packages = [ pkgs.mkcert ];
  xdg.dataFile."mkcert/rootCA.pem".source = super.environment.etc."mkcert/rootCA.pem".source;
  xdg.dataFile."mkcert/rootCA-key.pem".source = super.environment.etc."mkcert/rootCA-key.pem".source;
}
