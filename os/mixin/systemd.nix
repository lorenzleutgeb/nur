{
  systemd.services.true = {
    description = "Run `true`.";
    script = "true";
    serviceConfig.type = "oneshot";
  };
}
