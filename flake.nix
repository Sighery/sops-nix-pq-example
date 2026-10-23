{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix }: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed function;

    newSystem = hostname: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        {
          system.stateVersion = "26.05";
          networking.hostName = hostname;
        }
        ./configuration.nix
        ./secrets-${hostname}.nix

        sops-nix.nixosModules.sops
      ];
    };
  in {
    devShells = forAllSystems (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          sops
          age
          ssh-to-age
        ];
      };
    });

    nixosConfigurations = nixpkgs.lib.genAttrs ["pq" "ssh" "ssh_age"] newSystem;
  };
}
