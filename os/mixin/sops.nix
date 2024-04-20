{
  config,
  pkgs,
  ...
}: {
  sops.age.sshKeyPaths = map (x: x.path) (builtins.filter (x: x.type == "ed25519") config.services.openssh.hostKeys);

  environment.systemPackages = with pkgs; [
    age
    sops
    ssh-to-age
  ];
}
