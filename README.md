This repo contains `*.nix` files for configuring machines and
user homes, as well as some custom packages and overlays.

## `os/host`

The naming scheme of files in `os/host` is based on
the contents of [`/etc/machine-id`][man-machine-id].

The following script illustrates the idea:

```sh
# This (re-)generates /etc/machine-id
systemd-machine-id-setup

# This function hashes /etc/machine-id, since it should be
# treated as a secret (according to the manpage).
function machine-hash {
	nix-hash --type sha256 --base32 --flat /etc/machine-id
}

# Rebuild for current machine
nixos-rebuild switch --flake .#$(machine-hash)
```

# Setup Notes

## SSD Partitioning

`fdisk -c -u /dev/x`

https://www.thomas-krenn.com/de/wiki/Partition_Alignment

[man-machine-id]: https://man7.org/linux/man-pages/man5/machine-id.5.html
