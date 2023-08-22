{modulesPath, ...}: {
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
  ];
}
