{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
      age
      sops
      ssh-to-age
  ];
}
