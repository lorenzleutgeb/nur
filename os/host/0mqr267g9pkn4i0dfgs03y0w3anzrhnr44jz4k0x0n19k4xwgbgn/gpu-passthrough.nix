{ ... }:

{
  boot = {
    kernelParams = [
      "vfio-pci.ids=10de:05e3" # Nvidia GeForce GTX 285
    ];
    blacklistedKernelModules = [ "nvidia" "nouveau" ];
  };
}
