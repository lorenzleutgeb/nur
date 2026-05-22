final: prev: let
  version = "1.9.1";
  prevName = "radicle-node";
  finalName = "${prevName}-overlay";
in {
  ${finalName} = prev.${prevName}.overrideAttrs (finalAttrs: prevAttrs: {
    inherit version;
    pname = finalName;

    src = final.fetchgit {
      inherit (prevAttrs.src) url;
      tag = "releases/${version}";
      hash = "sha256-8wLVNHF9qkKBK2s6RdH0/2To2zamx8RON5iBjkQoQY4=";
      leaveDotGit = true;
      postFetch = ''
        git -C $out rev-parse HEAD > $out/.git_head
        git -C $out log -1 --pretty=%ct HEAD > $out/.git_time
        rm -rf $out/.git
      '';
    };

    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = "sha256-holYrCL0FApbnFRj0+bVnjkiNL14jclaM8xIqRHfEkc=";
    };

    doCheck = false;
  });
}
