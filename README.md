# Nix User Repository of Lorenz Leutgeb

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

## WSL

Use `wsl --import` to create the distro, then start it with `wsl --distribution`.

Copy `wsl.con` from this repo to [`/etc/wsl.conf`](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configuration-settings-for-wslconf).

Configure Nix via `~/.config/nix/nix.conf`:

```
sandbox = false
use-sqlite-wal = false
filter-syscalls = false
experimental-features = nix-command flakes
```

Install Nix in single-user mode:

```
$ sh <(curl -L https://nixos.org/nix/install) --no-daemon
```

Install Home Manager, then import the configuration in this repository via `~/.config/nixpkgs/home.nix`

Create `/run/user/$UID`:

```
sudo mkdir /run/user/$UID
sudo chown $UID:$GID /run/user/$UID
sudo mount -t tmpfs -o size=4G,uid=$UID,gid=$GID /run/user/$UID
```

## Bluetooth

See [NixOS Wiki][wiki-bt]. Gist is:

```
$ bluetoothctl
power on
agent on
default-agent
scan on
pair $ADDR
connect $ADDR
```

### Known Devices

| Address             | Description |
|---------------------|-------------|
| `78:2B:64:CC:E4:40` | Headset     |
| `CE:B5:52:D6:EA:8C` | Trackball   |

## SSD Partitioning

`fdisk -c -u /dev/x`

https://www.thomas-krenn.com/de/wiki/Partition_Alignment

[man-machine-id]: https://man7.org/linux/man-pages/man5/machine-id.5.html
[wiki-bt]: https://nixos.wiki/wiki/Bluetooth
