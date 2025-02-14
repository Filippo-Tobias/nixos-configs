{
  description = "System Config Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs = {self, nixpkgs, home-manager, ...}:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        nixpc = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            ./enviromentPackages.nix
	    home-manager.nixosModules.home-manager
	    #xremap-flake.nixosModules.default
	    {
	      home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nixuser = import ./home.nix;
	    }
          ];
        };
      };

      homeConfigurations = {
        nixuser = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [./home.nix];
        };
      };
    };
  

}
