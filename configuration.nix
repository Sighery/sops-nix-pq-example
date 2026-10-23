{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.sighery = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";
  };

  environment.systemPackages = with pkgs; [
    coreutils
  ];

  # Obviously you wouldn't load credentials like this. Use nixos-anywhere
  # or something else to side-load
  virtualisation.vmVariant.virtualisation.sharedDirectories = {
    credentials = {
      source = toString ./credentials;
      target = "/mnt/custom-credentials";
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
