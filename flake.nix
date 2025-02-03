{
  description = ''
    Flake for AwesomeRC

    My Awesome Windows Manager configuration
  '';

  inputs = {
    # Stable Nix Packages
    nixpkgs = {
      url = "nixpkgs/nixos-unstable";
      # url = "github:nixos/nixpkgs/nixos-unstable";
    };
    # Flake Utils Lib
    utils = {
      url = "github:numtide/flake-utils";
    };
    awesome = {
      url = "github:awesomeWM/awesome/master";
      flake = false;
    };
    bling = {
      url = "github:BlingCorp/bling/master";
      flake = false;
    };
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
  in {
    # TOOLING
    # ========================================================================
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (
      system:
        (pkgsForSystem system).alejandra
    );

    homeManagerModules = {
      awesomerc = import ./modules/home-manager.nix self;
    };
    homeManagerModule = self.homeManagerModules.awesomerc;

    packages = forAllSystems (system: rec {
      awesomerc = with import inputs.nixpkgs {inherit system;};
        callPackage ./package.nix {inherit inputs;};
      default = awesomerc;
    });
  };
}
# END DOTGIT-SYNC BLOCK MANAGED
