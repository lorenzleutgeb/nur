{
  lib,
  fetchFromGitHub,
  mkSbtDerivation,
  jdk,
}: let
  owner = "informalsystems";
  version = "0.42.0";
  rev = "v${version}";
in
  mkSbtDerivation rec {
    inherit version;
    pname = "apalache";

    src = fetchFromGitHub {
      inherit owner rev;
      repo = pname;
      hash = "sha256-Z/tmBMv+QshFJLo2kBgBdkqfKwF93CgURVIbYF3dwJE=";
    };

    postPatch = ''
      substituteInPlace ./src/universal/bin/apalache-mc \
        --replace 'exec java' 'exec ${jdk}/bin/java' \
        --replace '$DIR/../lib/apalache.jar' "$out/lib/apalache.jar"

      # Instead of using `git` to get the revision,
      # patch it to the revision used to fetch.
      substituteInPlace ./build.sbt \
        --replace 'Process("git describe --tags --always").!!.trim' '"${rev}"'
    '';

    depsSha256 = "sha256-1/cI5JK1/uYVK7ihoyZwR4cHJqzsNW9eVaF7OKu92IE=";

    buildPhase = ''
      make dist
    '';

    installPhase = ''
      mkdir $out
      tar --strip-components=1 -xvzf target/universal/apalache.tgz -C $out
    '';

    meta = with lib; {
      description = "symbolic model checker for TLA+";
      homepage = "https://github.com/${owner}/${pname}";
      license = licenses.asl20;
    };
  }
