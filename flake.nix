{
  description = "Govnixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    unstable,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    homeStateVersion = "24.11";

    user = "beholder";

    hosts = [
      {
        hostname = "thinkpad";
        stateVersion = homeStateVersion;
      }
    ];

    makeSystem = {
      hostname,
      stateVersion,
      user,
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs stateVersion hostname user;
          unstable = unstable.legacyPackages.${system};
        };

        modules = [
          ./hosts/${hostname}/configuration.nix
        ];
      };

    systems = builtins.listToAttrs (
      map (host: {
        name = host.hostname;
        value = makeSystem {
          inherit (host) hostname stateVersion;
          user = user; # передаём сюда user
        };
      })
      hosts
    );
  in {
    nixosConfigurations =
      systems
      // {
        default = systems.thinkpad;
      };
  };
}
