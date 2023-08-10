{...}: {
  programs.opam = {enable = true;};

  # TODO: Not sure if I really need a global opam...

  home.file.".opam/config".text = ''
    opam-version: "2.0"
    repositories: "default"
    installed-switches: ["raml" "default"]
    switch: "raml"
    jobs: 3
    download-jobs: 3
    eval-variables: [
      sys-ocaml-version
      ["ocamlc" "-vnum"]
      "OCaml version present on your system independently of opam, if any"
    ]
    default-compiler: [
      "ocaml-system" {>= "4.02.3"}
      "ocaml-base-compiler"
    ]
  '';

  home.file.".opam/repo/repos-config".text = ''
    repositories: [
      "coq-released" {"https://coq.inria.fr/opam/released"}
      "default" {"https://opam.ocaml.org/"}
    ]
  '';
}
