{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ libvirt virt-manager ];
  xdg.configFile."libvirt/libvirt.conf".source = ./libvirt.conf;
}
