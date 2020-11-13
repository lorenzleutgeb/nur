{ stdenv, fetchurl }:

let
  version = "0.4.1";

  srcs = {
    x86_64-linux = fetchurl {
      url =
        "https://github.com/david-janssen/kmonad/releases/download/${version}/kmonad-${version}-linux";
      sha256 = "g55Y58wj1t0GhG80PAyb4PknaYGJ5JfaNe9RlnA/eo8=";
    };
  };
in stdenv.mkDerivation rec {
  pname = "kmonad-bin";
  inherit version;

  src = srcs.${stdenv.hostPlatform.system} or (throw
    "unsupported system: ${stdenv.hostPlatform.system}");

  buildCommand = ''
    mkdir -p $out/bin
    install -Dm755 $src "$out"/bin/kmonad
  '';

  meta = with stdenv.lib; {
    description = "An advanced keyboard manager";
    homepage = "https://github.com/david-janssen/kmonad";
    platforms = attrNames srcs;
    maintainers = with maintainers; [ terlar ];
    license = licenses.mit;
  };
}
