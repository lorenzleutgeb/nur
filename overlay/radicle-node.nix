final: prev: (let
  version = "1.4.0";
  overlayRustPackage = {
    final,
    prev,
    old,
    new ? old,
    override,
  }: {
    ${new} = final.callPackage prev.${old}.override {
      rustPlatform =
        final.rustPlatform
        // {
          buildRustPackage = args:
            final.rustPlatform.buildRustPackage (
              args
              // (override args)
            );
        };
    };
  };
in
  overlayRustPackage rec {
    inherit final prev;
    old = "radicle-node";
    new = "${old}-overlay";

    override = args: {
      inherit version;
      name = new;
      env.RADICLE_VERSION = version;

      src = final.fetchgit {
        inherit (args.src) url;
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

      doCheck = false;
      passthru = {};
    };
  })
