{
  description = "My NixOS and Home Manager flake";

  inputs = {
    # Stable (24.11)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    
    # Unstable
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # home-manager = {
    #   url = "github:nix-community/home-manager/release-24.11";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      
      commonArgs = {
        inherit system;
        pkgs = nixpkgs.legacyPackages.${system};  # По умолчанию используем stable
        unstable = unstable.legacyPackages.${system};  # Передаём unstable-пакеты
      };

    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ 
          ./configuration.nix 
          {
            _module.args.unstable = unstable.legacyPackages.${system};
          }
          # home-manager.nixosModules.home-manager 
          # {
          #   home-manager = {
          #     useGlobalPkgs = true;
          #     useUserPackages = true;
          #     users.beholder = import ./home.nix;
          #   };
          # }
        ];
      };

      # homeConfigurations.beholder = home-manager.lib.homeManagerConfiguration { inherit (commonArgs) pkgs;
      #   modules = [ 
      #     ./home.nix 
      #     {
      #       _module.args.unstable = unstable.legacyPackages.${system};
      #     }
      #   ];
      # };
    };
}
