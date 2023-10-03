{
  lib,
  fetchFromGitHub,
  python3,
  libseccomp,
  nixosTests,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "benchexec";

  # Using branch `cgroupsv2`, which is
  # 145 commits ahead, 3 commits behind `main`
  # as of 2023-10-03 but supports cgroups2.
  # See <https://github.com/sosy-lab/benchexec/pull/791>.
  version = "unstable-2023-09-05";

  src = fetchFromGitHub {
    owner = "sosy-lab";
    repo = pname;
    rev = "2a0eec264d37b18b8bc15e72625a16edf2c54293";
    hash = "sha256-wbVrkX/8SDE/8B9deBLYYYO2+rjgPq+JQTe7tx0w99I=";
  };

  format = "pyproject";

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs =
    [
      # CPU Energy Meter is not added here, because BenchExec should call the
      # wrapper configured via `security.wrappers.cpu-energy-meter`
      # in `programs.cpu-energy-meter`, which will have the required
      # capabilities to access MSR.
      # If we add `cpu-energy-meter` here, BenchExec will instead call an executable
      # without `CAP_SYS_RAWIO` and fail.
      #pkgs.cpu-energy-meter
      libseccomp.lib
    ]
    ++ (with python3.pkgs; [
      coloredlogs
      pystemd
      pyyaml
    ]);

  makeWrapperArgs = ["--set-default LIBSECCOMP ${lib.getLib libseccomp}/lib/libseccomp.so"];

  passthru.tests.benchexec = nixosTests.benchexec;

  meta = with lib; {
    description = "A Framework for Reliable Benchmarking and Resource Measurement.";
    homepage = "https://github.com/sosy-lab/benchexec";
    maintaners = with maintaners; [lorenzleutgeb];
    license = licenses.asl20;
    mainProgram = pname;
  };
}
