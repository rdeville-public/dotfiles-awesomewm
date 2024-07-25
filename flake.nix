# BEGIN DOTGIT-SYNC BLOCK MANAGED
{
  description = ''
    Flake for AwesomeRC

    My Awesome Windows Manager configuration
  '';

  inputs = {
    # Stable Nix Packages
    nixpkgs = {
      url = "nixpkgs/nixos-24.05";
      # url = "github:nixos/nixpkgs/nixos-unstable";
    };
    # Flake Utils Lib
    utils = {
      url = "github:numtide/flake-utils";
    };
    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # BEGIN DOTGIT-SYNC BLOCK EXCLUDED NIX_FLAKE_INPUT

    # END DOTGIT-SYNC BLOCK EXCLUDED NIX_FLAKE_INPUT
  };

  outputs = inputs @ {self, ...}: let
    pkgsForSystem = system:
      import inputs.nixpkgs {
        inherit system;
      };

    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = inputs.nixpkgs.lib.genAttrs allSystems;

    allSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    # BEGIN DOTGIT-SYNC BLOCK EXCLUDED NIX_FLAKE_CUSTOM_VARS
    # END DOTGIT-SYNC BLOCK EXCLUDED NIX_FLAKE_CUSTOM_VARS
  in {
    # TOOLING
    # ========================================================================
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (
      system:
        inputs.alejandra.defaultPackage.${system}
    );
    homeManagerModules = {
      awesomerc = import ./modules/home-manager.nix self;
    };
    homeManagerModule = self.homeManagerModules.awesome;

    # BEGIN DOTGIT-SYNC BLOCK EXCLUDED NIX_FLAKE_OUTPUTS_CUSTOM
    # Exemple of package
    overlays.default = final: prev: {
      awesomerc = final.callPackage ./package.nix {};
    };
    packages = forAllSystems (system: rec {
      awesomerc = with import inputs.nixpkgs {inherit system;};
        callPackage ./package.nix {};
      default = awesomerc;
    });
    # END DOTGIT-SYNC BLOCK EXCLUDED NIX_FLAKE_OUTPUTS_CUSTOM
  };
}
# END DOTGIT-SYNC BLOCK MANAGED
