{ ... }:

{
  sops.defaultSopsFile = ./host_ssh.yaml;
  sops.age.sshKeyFile = "/mnt/custom-credentials/ssh_ed25519_key";

  sops.secrets."val3" = { };
}
