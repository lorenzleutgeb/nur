{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [libvirt virt-manager];
  xdg.configFile."libvirt/libvirt.conf".text = ''
    uri_default = "qemu:///system"
  '';
}
