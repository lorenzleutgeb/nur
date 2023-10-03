{
  lib,
  stdenv,
  fetchFromGitHub,
  libcap,
}:
stdenv.mkDerivation rec {
  pname = "cpu-energy-meter";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "sosy-lab";
    repo = pname;
    rev = version;
    hash = "sha256-QW65Z8mRYLHcyLeOtNAHjwPNWAUP214wqIYclK+whFw=";
  };

  patchPhase = ''
    substituteInPlace Makefile \
      --replace "DESTDIR :=" "DESTDIR := $out" \
      --replace "PREFIX := /usr/local" "PREFIX :="
  '';

  buildInputs = [libcap];

  env.NIX_CFLAGS_COMPILE = "-fcommon";

  postInstall = ''
    install -D --mode=444 --target-directory=$out/etc/udev/rules.d \
      $src/debian/additional_files/59-msr.rules
  '';

  meta = {
    description = "A tool for measuring energy consumption of Intel CPUs";
    homepage = "https://github.com/sosy-lab/cpu-energy-meter";
    changelog = "https://github.com/sosy-lab/cpu-energy-meter/blob/c528f65/CHANGELOG.md#cpu-energy-meter-12";
    maintaners = with lib.maintaners; [lorenzleutgeb];
    license = lib.licenses.bsd3;
    mainProgram = pname;
  };
}
