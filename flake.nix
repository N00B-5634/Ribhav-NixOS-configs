{
  description = "Unified Master Multi-Machine Flake Workspace";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      
      # 1. Your original active server profile
      nixos-lamp = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration.nix ];
      }; # <- This block ends cleanly here!

      # 2. Your resurrected laptop profile (matching the attribute to your rebuild command target!)
      nixos-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./laptop-configuration.nix ];
      };

    };
  };
}
