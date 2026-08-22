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
      fileHash = "sha256:1jqs7hgkmspbprw874ik0qvjaclv1z244n9wn903j5j8mywqzg5y";
      certHash = "96:DD:8E:A1:94:8A:EB:BB:7A:05:B2:C3:61:06:01:88:FA:2C:85:1D:29:DD:AB:C9:EB:5E:15:DF:14:E9:23:0D";
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
