{pkgs, ...}: let
  fetchcert = {
    url,
    fileHash,
    certHash,
  }:
    pkgs.stdenv.mkDerivation {
      src = builtins.fetchurl {
        inherit url;
        sha256 = fileHash;
      };

      outputHash = fileHash;
      outputHashAlgo = "sha256";

      name = baseNameOf url;

      buildInputs = [pkgs.openssl];

      dontUnpack = true;
      dontInstall = true;

      buildPhase = ''
        actual=$(openssl x509 -in $src -noout -sha256 -fingerprint | cut -d= -f2)
        if [ "${certHash}" != "$actual" ]
        then
          echo "Fingerprint mismatch!"
          echo "  Certificate: ${url}"
          echo "  Expected:    ${certHash}"
          echo "  Actual:      $actual"
          echo "  Algorithm:   SHA-256 (computed using OpenSSL)"
          exit 1
        fi
        cp $src $out
      '';

      preferLocalBuild = true;
    };
in {
  security.pki.certificateFiles = [
    # https://plex.mpi-klsb.mpg.de/display/Documentation/UntrustedCertificates#UntrustedCertificates-InternalRoot-CADownload
    (fetchcert {
      url = "https://ca.mpi-klsb.mpg.de/klsb.crt";
      fileHash = "0lqgqn110b52c0vgrfahdc7k4gfrbxz47ckk6ghqn4491q9h4njc";
      certHash = "FE:F6:82:83:A9:10:34:D0:7C:19:BE:BF:F7:04:8B:C4:D5:E6:CF:D9:F4:A4:5C:EB:46:79:33:65:BD:94:CF:44";
    })

    # https://plex.mpi-klsb.mpg.de/display/Documentation/eduroam#eduroam-Servercertificates
    # nix store add-file IST_Radius_CA_2.crt
    (fetchcert {
      url = "https://plex.mpi-klsb.mpg.de/download/attachments/13908369/IST_Radius_CA_2.crt";
      fileHash = "0jmc8762fhswh3lhbbw0mkkc6irdba2cg4xjc8wbcj7i54j2zqj8";
      certHash = "AD:85:F8:B1:FA:99:13:71:EF:B1:B6:1C:69:32:8E:DE:93:07:8A:B3:FE:FA:A2:B1:84:EC:F7:3B:62:37:71:B3";
    })
  ];
}
