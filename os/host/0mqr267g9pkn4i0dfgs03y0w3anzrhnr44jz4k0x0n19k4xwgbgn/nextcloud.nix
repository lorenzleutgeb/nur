# Config that allows Nextcloud via SSH.
{...}: {
  services.openssh = {
    settings.Macs = [
      "hmac-sha2-256"
    ];
    hostKeys = [
      {
        bits = 1024;
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
    ];
  };
}
