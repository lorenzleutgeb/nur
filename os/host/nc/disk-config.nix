{lib, ...}: {
  disko.devices = {
    disk.main = {
      device = lib.mkDefault "/dev/vda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = let
                mountOptions = ["compress=zstd" "discard=async" "noatime"];
              in {
                "/root" = {
                  inherit mountOptions;
                  mountpoint = "/";
                };
                "/home" = {
                  inherit mountOptions;
                  mountpoint = "/home";
                };
                "/nix" = {
                  inherit mountOptions;
                  mountpoint = "/nix";
                };
              };
            };
          };
        };
      };
    };
  };
}
