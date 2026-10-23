# sops-nix-pq-example

An example post-quantum safe sops-nix setup.

## Systems

This repository will have three NixOS systems, that can then be build as a VM
and run to check sops-nix in action.

* `pq`: Fully post-quantum-safe system. The secret is encrypted with
  `admin_pq`, a post-quantum Age key, and only decryptable with `host_pq`,
  another post-quantum Age key.
* `ssh_age`: Hybrid post-quantum Age and classic SSH system. The secret is
  encrypted with `admin_pq`, a post-quantum Age key, but is decryptable with
  the Age key derived from `ssh_ed25519_key`, so a classic Age key from a
  classic SSH key.
* `ssh`: Hybrid post-quantum Age and classic SSH system. The same as
  `ssh_age`, but instead uses [SSH recipients][Age SSH recipients] directly,
  rather than derive an Age key from the SSH key.

## Post-quantum Age keys

https://github.com/filosottile/age#post-quantum-keys

```sh
age-keygen -pq -o admin_pq
age-keygen -pq -o host_pq
```

## SSH keys

```sh
yes | ssh-keygen -t ed25519 -f "$PWD/ssh_ed25519_key" -C "" -q -N ""
```

## Write the encrypted files with PQ Age key

https://getsops.io/docs/usage/identities/age/

```sh
SOPS_AGE_KEY_FILE=credentials/admin_pq sops host_pq.yaml
```

## SSH recipients not yet supported by sops-nix

While
[Age supports SSH recipients][Age SSH recipients],
and so does [Sops](https://getsops.io/docs/usage/identities/age/), sops-nix
still does not natively support them, although there are workarounds to get it
to work. [Issue](https://github.com/Mic92/sops-nix/issues/695) and related
[PR](https://github.com/Mic92/sops-nix/pull/970).

For the `ssh_age` system, the `host_ssh_age` recipient will be used. The
`host_ssh` recipient will sadly not work as is. To convert from the SSH public
key to Age:

```sh
cat credentials/ssh_ed25519_key.pub | ssh-to-age
```

The `ssh` system age uses the classic SSH `host_ssh` recipient. This is not
natively supported by sops-nix and requires passing an environment variable to
sops. Check [`secrets-ssh.nix`](./secrets-ssh.nix) for info on how to set this
up, until the sops-nix PR is merged (if ever).

## Running VMs of config

https://nix.dev/tutorials/nixos/nixos-configuration-on-vm.html

```sh
nix build .#nixosConfigurations.pq.config.system.build.vm
./result/bin/run-pq-vm
```



[Age SSH recipients]: https://github.com/FiloSottile/age#ssh-keys
