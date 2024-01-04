{
  description = "nixOS public flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs, ... }:
  let 
    lib = nixpkgs.lib;
    sysarc = "x86_64-linux";
  in { 
    nixosConfigurations = {
      basicNix = lib.nixosSystem {
        system = sysarc;
        modules = [ ./basic-configuration.nix ];
      };
      terminalNix = lib.nixosSystem {
        system = sysarc;
        modules = [ ./terminal/configuration.nix ];
      };
    };
  };  
}

