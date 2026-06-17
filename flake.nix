{
  description = "SRVBCK02617133849";

  inputs = {
    # We lock down nixpkgs. No more surprise channel updates breaking your PHP environment.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos-lamp = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # This pulls in your main config, which already points to your modules!
        ./configuration.nix
      ];
    };
  };
}
