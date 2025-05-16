{
  stdenv,
  lib,
  fetchzip,
  system,
  autoPatchelfHook,
}:

# https://github.com/Bear-03/vosk-rs/blob/main/nix/shells/default/default.nix
let
  voskVersion = "0.3.45";
  arch = builtins.head (lib.strings.splitString "-" system);
  voskLib = fetchzip {
    url = "https://github.com/alphacep/vosk-api/releases/download/v${voskVersion}/vosk-linux-${arch}-${voskVersion}.zip";
    hash = "sha256-Pve91VpfVAXMY3dqbE9U1gkfQtedHOXj4ikGlWKyezQ=";
  };
in
stdenv.mkDerivation {
  pname = "vosk-api";
  version = "0.3.45";

  src = voskLib;

  dontBuild = true;
  dontUnpack = true;
  dontConfigure = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall
    install -m755 -D $src/libvosk.so $out/lib/libvosk.so
    runHook postInstall
  '';

  meta = with lib; {
    description = "Offline speech recognition API";
    homepage = "https://github.com/alphacep/vosk-api";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
