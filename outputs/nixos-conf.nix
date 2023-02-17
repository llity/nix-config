{ inputs, system, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  libx = import ../lib { inherit (inputs.nixpkgs) lib; };

  lib = inputs.nixpkgs.lib.extend (_: _: {
    inherit (libx) secretManager;
  });

  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "xrdp-0.9.9"
      ];
    };
  };
in
{
  dell-xps = nixosSystem {
    inherit lib pkgs system;
    specialArgs = { inherit inputs; };
    modules = [
      ../system/machine/dell-xps
      ../system/configuration.nix
    ];
  };

  vm-nix = nixosSystem {
    inherit lib pkgs system;
    specialArgs = { inherit inputs; };
    modules = [
      ../system/machine/vm-nix
      ../system/configuration.nix
    ];
  };
}
