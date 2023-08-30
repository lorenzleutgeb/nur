{
  lib,
  fetchFromGitLab,
  mkSbtDerivation,
  jre,
  makeWrapper,
}: let
  pname = "tessla";
  domain = "${pname}.io";
  version = "2.0.0";
in
  mkSbtDerivation rec {
    inherit version pname;

    src = fetchFromGitLab {
      domain = "git.${domain}";
      repo = pname;
      owner = pname;
      rev = version;
      hash = "sha256-UnMOWhfjJiQohwUKa/EBNXiWErsDTLWlTYYmkdL0ESU=";
    };

    depsSha256 = "sha256-2SNVw0ZZxfAaXl5OGZQVCBoaBR05tesmJZyZ3OBTouo=";

    nativeBuildInputs = [makeWrapper];

    buildPhase = "sbt assembly";

    installPhase = let
      jar = "$out/lib/${pname}.jar";
    in ''
      mkdir -p $out/{bin,lib}
      cp target/scala-*/${pname}-assembly-${version}.jar ${jar}
      makeWrapper ${jre}/bin/java $out/bin/${pname} \
        --add-flags "-jar ${jar}"
    '';

    meta = with lib; {
      description = "A Convenient Language for Specification and Verification of Your System";
      homepage = "https://${domain}/";
      license = licenses.asl20;
    };
  }
