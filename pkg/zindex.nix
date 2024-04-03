{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  ...
}: let
  owner = "mattgodbolt";
  version = "unstable-2022-10-14";
  rev = "860ededff9fa2978e31121d966ecc5b1b0fa0524";
in
  stdenv.mkDerivation rec {
    inherit version;
    pname = "zindex";

    src = fetchFromGitHub {
      inherit owner rev;
      repo = pname;
      hash = "sha256-uXv0HvmsjlssKYgf/OQWtKE7UT4ES4QzUFQqMTRK90k=";
    };

    patches = [./zindex-no-tests.patch];

    nativeBuildInputs = with pkgs; [cmake zlib];

    doCheck = false;

    installPhase = ''
      mkdir -p $out/bin
      cp z{index,q} $out/bin
    '';

    meta = with lib; {
      description = "Create an index on a compressed text file";
      homepage = "https://github.com/${owner}/${pname}";
      license = licenses.bsd2;
    };
  }
