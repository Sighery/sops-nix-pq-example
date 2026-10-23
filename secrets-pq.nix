{ ... }:

{
  sops.defaultSopsFile = ./host_pq.yaml;
  sops.age.keyFile = "/mnt/custom-credentials/host_pq";

  sops.secrets."val1" = { };
}
