{
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "0mqr.lorenz.hs.leutgeb.xyz";
        maxJobs = 8;
        protocol = "ssh-ng";
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSURRTTJVTngzTFJ1dURNOG5IRmNDLzIxUjk3YWp4YzFTbUZPS3pZZ0NSa0Ygcm9vdEBuaXhvcwo=";
        speedFactor = 9000;
        sshKey = "/home/lorenz/.ssh/id_ed25519";
        sshUser = "lorenz";
        supportedFeatures = ["kvm"];
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
      }
    ];
  };
}
