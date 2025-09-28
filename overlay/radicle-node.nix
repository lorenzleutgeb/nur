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
      rev = "5e430f4483665a28061029783e97cc7f65571ed9";
      hash = "sha256-MaLweunmIfNLcvisLtAir35KFYEWre8t9t+8ESqG7qk=";
      leaveDotGit = true;
      postFetch = ''
        git -C $out rev-parse HEAD > $out/.git_head
        git -C $out log -1 --pretty=%ct HEAD > $out/.git_time
        rm -rf $out/.git
      '';
    };

    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = "sha256-iJE6lSx1o6qQqomHI3myIxIBol99Ev+5O/XTiyZT0B0=";
    };

    doCheck = false;
  });
}
