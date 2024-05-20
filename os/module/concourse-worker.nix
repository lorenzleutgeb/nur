{
  config,
  options,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.concourse-worker;
  opt = options.services.concourse-worker;
in {
  meta.maintainers = with lib.maintainers; [lorenzleutgeb];
  options.services.concourse-worker = {
    enable = lib.mkEnableOption "Concourse CI Worker Node";
    package = lib.mkPackageOption pkgs "concourse" {};
    settings = lib.mkOption {
      type = lib.submodule {freeformType = lib.types.attrsOf [lib.types.str lib.types.path];};
      description = "Concourse CI settings mapped to environment variables.";
      default = {
        CONCOURSE_RUNTIME = "containerd";
        CONCOURSE_TSA_HOST = "127.0.0.1:2222";
        CONCOURSE_TSA_PUBLIC_KEY = (lib.head config.openssh.hostKeys).path + ".pub";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services."concourse-worker" = {
      documentation = [
        "https://concourse-ci.org/concourse-worker.html"
      ];
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} worker";
      };
    };

    security.allowUserNamespaces = true;
    systemd.enableUnifiedCgroupHierarchy = true;
  };
}
