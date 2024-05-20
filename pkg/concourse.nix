{
  lib,
  buildGoModule,
  mkYarnPackage,
  fetchYarnDeps,
  fetchFromGitHub,
  postgresql,
  fixup_yarn_lock,
}: let
  version = "7.11.0";
  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    hash = "sha256-lp6EXdwmgmjhFxRQXn2P4iRrtJS1QTvg4225V/6E7MI=";
  };
  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-jllwHv2XPhgUdQJiOCxWenuviVhiJkbsE9oG1w2aPI8=";
  };
  public = mkYarnPackage {
    inherit src version;
    name = "concourse-public";

    configurePhase = ''
      export HOME=$PWD/yarn
      yarn config --offline set yarn-offline-mirror ${offlineCache}
      ${fixup_yarn_lock}/bin/fixup_yarn_lock yarn.lock
    '';

    buildPhase = ''
      yarn --frozen-lockfile --offline install
      yarn --verbose --offline build
    '';

    installPhase = ''
      mkdir $out
      cp -R dist/* $out
    '';

    doDist = false;
  };
in
  buildGoModule rec {
    inherit src version;
    pname = "concourse";

    vendorHash = "sha256-p3EhXrRjAFG7Ayfj/ArAWO7KL3S/iR/nwFwXcDc+DSs=";

    ldflags = [
      "-s"
      "-w"
      "-X github.com/concourse/concourse.Version=${version}"
    ];

    subPackages = ["cmd/concourse"];

    nativeCheckInputs = [postgresql];

    passthru = {
      inherit public;
    };

    meta = with lib; {
      description = "Concourse CI";
      homepage = "https://concourse-ci.org";
      license = licenses.asl20;
      maintainers = with maintainers; [lorenzleutgeb];
      mainProgram = "concourse";
    };
  }
