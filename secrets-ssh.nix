{ ... }:

{
  sops.defaultSopsFile = ./host_ssh.yaml;
  # This bit is not working on its own. It will conver to an age key
  sops.age.sshKeyPaths = [ "/mnt/custom-credentials/ssh_ed25519_key" ];
  # This is the line that makes it actually work
  sops.environment.SOPS_AGE_SSH_PRIVATE_KEY_FILE = "/mnt/custom-credentials/ssh_ed25519_key";

  sops.secrets."val3" = { };
}
