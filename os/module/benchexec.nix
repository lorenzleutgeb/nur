{
  lib,
  pkgs,
  config,
  ...
}: {
  options.programs.benchexec = {
    enable = lib.options.mkEnableOption "BenchExec";
    package = lib.options.mkPackageOption pkgs "benchexec" {};
  };

  config = lib.mkIf config.programs.benchexec.enable {
    environment.systemPackages = [config.programs.benchexec.package];
    security.unprivilegedUsernsClone = true;
    systemd.enableUnifiedCgroupHierarchy = true;
  };
}
