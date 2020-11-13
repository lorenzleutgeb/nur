# NixOS

## `os/host`

The naming scheme of files in `os/host` is based on
the contents of [`/etc/machine-id`][man-machine-id].

The following script illustrates the idea:

```sh
# This (re-)generates /etc/machine-id
systemd-machine-id-setup

# This function hashes the machine-id, since it should be
# treated as a secret (according to the manpage).
function machine-hash {
	nix-hash --type sha256 --base32 --flat /etc/machine-id
}

# Copy over the configuration file name for this machine:
cp hardware/$(machine-hash).nix /etc/nixos/hardware-configuration.nix
```

[man-machine-id]: https://man7.org/linux/man-pages/man5/machine-id.5.html
