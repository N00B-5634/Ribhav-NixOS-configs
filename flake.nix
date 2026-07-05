{
  description = "Unified Master Multi-Machine Flake Workspace";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Introduce Home Manager tracking the unstable branch
    home-manager = {
      url = "github:nix-community/home-manager";
      # The Absolute Holy Grail: Force Home Manager to use your system's exact nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      
      # 1. Server Profile: Intentionally isolated from user-space bloat
      nixos-lamp = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./configuration.nix ];
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
