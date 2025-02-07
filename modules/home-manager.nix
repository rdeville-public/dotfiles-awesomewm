self: {
  pkgs,
  lib,
  config,
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
            luarocks
            luajitPackages.lgi
          ];
          package = awesome;
        };
      };
    };
  };
}
