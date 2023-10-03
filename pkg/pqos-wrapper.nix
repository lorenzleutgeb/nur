{
  lib,
  intel-cmt-cat,
  fetchFromGitLab,
  python3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "pqos-wrapper";

  version = "unstable-2022-01-31";

  src = fetchFromGitLab {
    group = "sosy-lab";
    owner = "software";
    repo = pname;
    rev = "ce816497a07dcb4b931652b98359e4601a292b15";
    hash = "sha256-SaYr6lVucpJjVtGgxRbDGYbOoBwdfEDVKtvD+M1L0o4=";
  };

  makeWrapperArgs = ["--prefix LD_LIBRARY_PATH : ${lib.getLib intel-cmt-cat}/lib"];

  meta = with lib; {
    description = "Wrapper for Intel PQoS for the purpose of using it in BenchExec";
    homepage = "https://gitlab.com/sosy-lab/software/pqos-wrapper";
    maintaners = with maintaners; [lorenzleutgeb];
    license = licenses.asl20;
    mainProgram = "pqos_wrapper";
  };
}
