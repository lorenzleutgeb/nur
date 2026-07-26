{pkgs, ...}: {
  fonts.packages = [pkgs.fira-code];

  services.kmscon = {
    enable = true;
    config.font-name = "Fira Code";
  };
}
