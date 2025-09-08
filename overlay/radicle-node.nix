final: prev: let
  version = "1.4.0";
  prevName = "radicle-node";
  finalName = "${prevName}-overlay";
in {
  ${finalName} = prev.${prevName}.overrideAttrs (old: {
    inherit version;
    pname = finalName;

    src = final.fetchgit {
      inherit (old.src) url;
      tag = "releases/${version}";
      hash = "sha256-e5Zelu3g8m9u5NtyABkIV4wOed9cq58xSaxginoDb2Q=";
      leaveDotGit = true;
      postFetch = ''
        git -C $out rev-parse HEAD > $out/.git_head
        git -C $out log -1 --pretty=%ct HEAD > $out/.git_time
        rm -rf $out/.git
      '';
    };

    cargoHash = "sha256-64SDz0wHKcp/tPGDDOlCRFr3Z1q6cWOafhP0howSFhA=";
  });
}
