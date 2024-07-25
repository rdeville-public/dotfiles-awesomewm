{
  stdenv,
  pkgs,
  ...
}:
stdenv.mkDerivation {
  name = "awesomerc";
  srcs = [
    (pkgs.fetchFromGitHub {
      owner = "BlingCorp";
      repo = "bling";
      rev = "master";
      name = "bling";
      sha256 = "sha256-6NZSUb7sSBUegSIPIubQUOZG3knzXfnyfEbCoEyggtc=";
    })
    (builtins.path {
      name = "awesome";
      path = ./.;
    })
  ];
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out;
    cp -r \
      awesome/*.md \
      awesome/LICENSE* \
      awesome/config \
      awesome/theme \
      awesome/utils \
      awesome/widgets \
      awesome/rc.lua \
      awesome/xinitrc \
      bling \
      $out
  '';
}
