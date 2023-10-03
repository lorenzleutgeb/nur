{...}: {
  programs = {
    benchexec.enable = true;
    cpu-energy-meter.enable = true;
    pqos-wrapper.enable = true;
  };
  virtualisation.lxc.lxcfs.enable = true;
}
