final: prev: let
  version = "unstable";
  prevName = "radicle-node";
  finalName = "${prevName}-overlay";
in {
  ${finalName} = prev.${prevName}.overrideAttrs (finalAttrs: prevAttrs: {
    inherit version;
    pname = finalName;

    src = final.fetchgit {
      inherit (prevAttrs.src) url;
      rev = "f953c650e83bb7c94c38a3b4f940081e60a61320";
      hash = "sha256-FzRPz47EtDAcmXAcRrgCREzGsnJ2R3ZO/i1n0HJYe6Y=";
      leaveDotGit = true;
      postFetch = ''
        git -C $out rev-parse HEAD > $out/.git_head
        git -C $out log -1 --pretty=%ct HEAD > $out/.git_time
        rm -rf $out/.git
      '';
    };

    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = "sha256-iFWNGRXxt972qtSpt5y2vgqf3cys59G/qfgEO/BQbNk=";
    };

    doCheck = false;
  });
}
