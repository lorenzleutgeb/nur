{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}: let
  pname = "quint";
  owner = "informalsystems";
  version = "0.14.0";
  repo = fetchFromGitHub {
    inherit owner;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4F7yRt+j31guxlVMByGdS8LqgUumCCFNq0cohVSQUwo=";
  };
in
  buildNpmPackage {
    inherit pname version;

    src = "${repo}/quint";

    npmDepsHash = "sha256-wt3eOl3InozZgUToBLBoy9S7pgDJdgORyFPUtP9zbeA=";
    npmBuildScript = "compile";

    meta = with lib; {
      description = "Quint is an executable specification language with design and tooling focused on usability. It is based on the Temporal Logic of Actions.";
      homepage = "https://github.com/${owner}/${pname}";
      license = licenses.asl20;
    };
  }
