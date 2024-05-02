# https://github.com/sebastiant/dotfiles/blob/367668f28ca6770493c78f4306338dcfbddbccff/programs/wayland-overlay.nix
# ~/config/zoomus.conf: enableWaylandShare=true
_: final: prev: {
  zoom-us = prev.zoom-us.overrideAttrs (oldAttrs: {
    postFixup =
      oldAttrs.postFixup
      + ''
        mv $out/bin/{zoom,zoom-x11}
        makeWrapper $out/bin/zoom-x11 $out/bin/zoom \
          --unset XDG_SESSION_TYPE
      '';
  });
}
