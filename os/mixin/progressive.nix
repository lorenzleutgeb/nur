{lib, ...}: {
  networking = {
    useDHCP = false;

    # https://github.com/moby/moby/issues/26824
    #nftables.enable = false;
  };
}
