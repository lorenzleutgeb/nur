{
  programs.ssh = {
    extraConfig = ''
      Host 0mqr
        IPQoS throughput
        IdentityFile /home/lorenz/.ssh/id_ed25519
    '';
  };
  nix.settings = let
    substituters = ["ssh://lorenz@0mqr?trusted=true"];
  in {
    inherit substituters;
    trusted-substituters = substituters;
  };
}
