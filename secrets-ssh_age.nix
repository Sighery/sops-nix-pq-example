{ ... }:

{
  sops.defaultSopsFile = ./host_ssh_age.yaml;
  sops.age.sshKeyPaths = [ "/mnt/custom-credentials/ssh_ed25519_key" ];

  sops.secrets."val2" = { };
}
