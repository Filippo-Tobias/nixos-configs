{
  description = "System Config Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, nixpkgs, chaotic, home-manager, stylix, ...}:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        nixpc = lib.nixosSystem {
          inherit system;
	        specialArgs = { inherit inputs; inherit system; };
          modules = [
            ./hosts/pc/configuration.nix
            ./common/configuration.nix
            ./common/environmentPackages.nix
	          home-manager.nixosModules.home-manager
            chaotic.nixosModules.default
            stylix.nixosModules.stylix
	          {
              home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.nixuser = lib.mkMerge [
                      (import ./common/home.nix)
                      (import ./hosts/pc/home.nix)
                    ];
              home-manager.backupFileExtension = "backupfile";
            }
          ];
        };
        nixlaptop = lib.nixosSystem {
          inherit system;
	        specialArgs = { inherit inputs; inherit system;};
          modules = [
            ./hosts/laptop/configuration.nix
	          ./common/configuration.nix
            ./common/environmentPackages.nix
	          home-manager.nixosModules.home-manager
            chaotic.nixosModules.default
            stylix.nixosModules.stylix
	          {
              home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.nixuser = lib.mkMerge [
                      (import ./common/home.nix)
                      (import ./hosts/laptop/home.nix)
                    ];
              home-manager.backupFileExtension = "backupfile";
            }
          ];
        };
      };
    };
}
