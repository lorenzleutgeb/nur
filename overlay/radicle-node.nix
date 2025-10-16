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
      rev = "615e37652285c6f06dc5bc28c8a13d4656f95104";
      hash = "sha256-Kaam2qvoQn1wp1EYwm/nF0KXs52AUQDEkN01KMyBEY0=";
      leaveDotGit = true;
      postFetch = ''
        git -C $out rev-parse HEAD > $out/.git_head
        git -C $out log -1 --pretty=%ct HEAD > $out/.git_time
        rm -rf $out/.git
      '';
    };

    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = "sha256-OVHkufdivsCMW9AVTtXpmBQkFOPbgusqGQLaxX3TxAU=";
    };

    doCheck = false;
  });
}
