{
  stdenv,
  inputs,
  ...
}:
stdenv.mkDerivation {
  name = "awesomerc";
  srcs = [
    (builtins.path {
      name = "bling";
      path = inputs.bling;
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
