# BEGIN DOTGIT-SYNC BLOCK MANAGED
self: {
  pkgs,
  lib,
  config,
  # BEGIN DOTGIT-SYNC BLOCK EXCLUDED NIX_HOME_MANAGER_MODULE_CUSTOM
  ...
}: let
  cfg = config.awesomerc;
  awesome = let
    extraGIPackages = with pkgs; [networkmanager upower];
  in
    ((pkgs.awesome.override {gtk3Support = true;}).overrideAttrs (old: {
      version = "git-main";
      src = self.inputs.awesome;
      patches = [];
      postPatch = ''
        patchShebangs tests/examples/_postprocess.lua
        patchShebangs tests/examples/_postprocess_cleanup.lua
      '';
      cmakeFlags = old.cmakeFlags ++ ["-DGENERATE_MANPAGES=OFF"];
      GI_TYPELIB_PATH = let
        mkTypeLibPath = pkg: "${pkg}/lib/girepository-1.0";
        extraGITypeLibPaths = pkgs.lib.forEach extraGIPackages mkTypeLibPath;
      in
        pkgs.lib.concatStringsSep ":" (extraGITypeLibPaths ++ [(mkTypeLibPath pkgs.pango.out)]);
    }))
    .override {
      lua = pkgs.luajit;
      gtk3Support = true;
    };
in {
  options = {
    awesomerc = {
      enable = lib.mkEnableOption "Install my awesome config and xsession";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      configFile = {
        awesome = {
          source = lib.mkDefault self.packages.${pkgs.stdenv.hostPlatform.system}.default;
        };
      };
    };
    home = {
      file = {
        ".xinitrc" = {
          source = "${self.packages.${pkgs.stdenv.hostPlatform.system}.default}/xinitrc";
        };
      };
    };
    xsession = {
      windowManager = {
        awesome = {
          enable = true;
          luaModules = with pkgs.luaPackages; [
            luarocks # is the package manager for Lua modules
            luajitPackages.lgi
          ];
          package = awesome;
        };
      };
    };
  };
  # END DOTGIT-SYNC BLOCK EXCLUDED NIX_HOME_MANAGER_MODULE_CUSTOM
}
# END DOTGIT-SYNC BLOCK MANAGED
