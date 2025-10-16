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
      rev = "54fdbbfce3e12655d08c20112024859c9aa32cab";
      hash = "sha256-NLO0rdw8uecNRn9Fnzb7ldtI/SV+YziC4bWeAE3BeCg=";
      leaveDotGit = true;
      postFetch = ''
        git -C $out rev-parse HEAD > $out/.git_head
        git -C $out log -1 --pretty=%ct HEAD > $out/.git_time
        rm -rf $out/.git
      '';
    };

    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = "sha256-dJloJf9dwnpOUjkpzL80jEmNa+ksbGtau5h1oYlO7NI=";
    };

    doCheck = false;
  });
}
