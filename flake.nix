{
  description = "Unified Master Multi-Machine Flake Workspace";

inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
   };
 };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }@inputs: {
  nixosConfigurations = {
    nixos-lamp = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        sops-nix.nixosModules.sops
      ];
    };
      # 2. Laptop Profile: Weaponized with Home Manager integration
      nixos-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; 
        modules = [ 
          ./laptop-configuration.nix
          
          # Inject the Home Manager NixOS module into the system evaluation loop
          home-manager.nixosModules.home-manager
          {
            # Global configuration parameters for cleanly handling configurations
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
	    home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

    };
  };
}
