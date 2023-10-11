final: prev: {
  zoom-us = prev.zoom-us.overrideAttrs (oldAttrs: rec {
    postPatch =
      oldAttrs.postPatch
      + ''
        substituteInPlace cmd/caddy/main.go --replace \
          '// plug in Caddy modules here" \
          '_ "github.com/caddy-dns/cloudflare"'
      '';
  });
}