{
  description = "System Config Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs = inputs @ {self, nixpkgs, chaotic, home-manager, ...}:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in rec {
      nixosConfigurations = {
        nixpc = lib.nixosSystem {
          inherit system;
	        specialArgs = { inherit inputs; };
          modules = [
            ./hosts/pc/configuration.nix
            ./common/configuration.nix
            ./common/environmentPackages.nix
	          home-manager.nixosModules.home-manager
            chaotic.nixosModules.default
	          {
              home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.nixuser = import ./common/home.nix;
              home-manager.backupFileExtension = "backupfile";
            }
          ];
        };
        nixlaptop = lib.nixosSystem {
          inherit system;
	        specialArgs = { inherit inputs; };
          modules = [
            ./hosts/laptop/configuration.nix
	          ./common/configuration.nix
            ./common/environmentPackages.nix
	          home-manager.nixosModules.home-manager
            chaotic.nixosModules.default
	          {
              home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.nixuser = import ./common/home.nix;
              home-manager.backupFileExtension = "backupfile";
            }
          ];
        };

      };

      homeConfigurations = {
        nixuser = home-manager.lib.homeManagerConfiguration {
          specialArgs = { inherit inputs; };
          inherit pkgs;
          modules = [./common/home.nix];
        };
      };
    };
  

}
