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
      rev = "46f4c0f38ffb181f6e5787997c6153f18ab22902";
      hash = "sha256-W94Vwf7ozwkENLueKF9Lvkns7HRX7PbMtvMHMCujV/s=";
      leaveDotGit = true;
      postFetch = ''
        git -C $out rev-parse HEAD > $out/.git_head
        git -C $out log -1 --pretty=%ct HEAD > $out/.git_time
        rm -rf $out/.git
      '';
    };

    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = "sha256-9+mlNQwV2bUyAXkPN7aflGuN/Xd32uT+JEjl48ZDeXY=";
    };

    doCheck = false;
  });
}
