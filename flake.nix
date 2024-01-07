{
  description = "nixOS public flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs, ... }:
  let 

    lib = nixpkgs.lib;
    systemArc = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${systemArc};

    essentials = ./essentials.nix;

    # Script Imports
    hwconf = pkgs.writeShellApplication {
      name = "hwconf";
      text = ''
nixos-generate-config --show-hardware-config > /etc/nixos/hardware-configuration.nix
      '';
    };

  in { 

    # nixOS configurations (nixos-rebuild --flake, nixos-install --flake)
    # Does not provide hardware-configuration.nix, but is required to work - nixos-generate-configuration
    # Will need to pass --impure for /etc/nixos/hardware-configuration.nix
    nixosConfigurations = {
      basicNix = lib.nixosSystem {
        system = systemArc;
        modules = [ 
          essentials
          ./basic-configuration.nix 
        ];
      };

      terminalNix = lib.nixosSystem {
        system = systemArc;
        modules = [ 
          essentials
          ./terminal/configuration.nix 
        ];
      };
    };

    # Nix Apps/Derivaions (nix run /path/to/flake#app)
    apps.${systemArc} = {
      hwconf = {
        type = "app";
        program = "${hwconf}/bin/hwconf";
      };
    };

  };  
}

