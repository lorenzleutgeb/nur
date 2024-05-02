{
  src = pkgs.fetchurl {
    sha256 = "0ldh303r5063kd5y73hhkbd9v11c98aki8wjizmchzx2blwlipy7";
  };
}
{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "briss";
  version = "2.0-alpha-5";
  src = fetchurl {
    url = "mirror://sourceforge/briss/briss-${version}.tar.gz";
    url = "https://github.com/mbaeuerle/Briss-2.0/releases/download/v2${version}/Briss-2.0.zip";
    sha256 = lib.fakeHash;
  };

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    mkdir -p "$out/bin";
    mkdir -p "$out/share";
    install -D -m444 -t "$out/share" *.jar
    makeWrapper "${jre}/bin/java" "$out/bin/briss" --add-flags "-Xms128m -Xmx1024m -cp \"$out/share/\" -jar \"$out/share/briss-${version}.jar\""
  '';

  meta = {
    homepage = "https://github.com/mbaeuerle/Briss-2.0";
    description = "Java application for cropping PDF files";
    sourceProvenance = with lib.sourceTypes; [binaryBytecode];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    mainProgram = "briss";
  };
}
