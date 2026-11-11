{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Not a flake, just the source; used by home/bash-it.nix.
    bash-it = {
      url = "github:Bash-it/bash-it/v3.2.0";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, bash-it, ... }: {
    nixosConfigurations.nixos-vm = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";

      modules = [
        ./hosts/nixos-vm/configuration.nix

        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit bash-it; };

          home-manager.users.foiki =
            import ./home/foiki.nix;
        }
      ];
    };
  };
}
