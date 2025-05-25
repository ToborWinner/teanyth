# Using the real onnxruntime with the raspberry package I got illegal instruction on the raspberry pi (using nixos cache).
# TODO: Investigate
{
  stdenv,
  fetchzip,
  autoPatchelfHook,
  lib,
}:

let
  version = "1.20.0";
in
stdenv.mkDerivation {
  pname = "onnxruntime";
  inherit version;

  src = fetchzip {
    url = "https://github.com/microsoft/onnxruntime/releases/download/v1.20.0/onnxruntime-linux-aarch64-1.20.0.tgz";
    hash = "sha256-V5o0X71Z85oCSINGrZxNomdomK9dKIhtAXYcDGlh/Gw=";
  };

  dontBuild = true;
  dontUnpack = true;
  dontConfigure = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    cp -r $src/lib/* $out/lib
    runHook postInstall
  '';

  meta = with lib; {
    description = "Cross-platform, high performance scoring engine for ML models";
    longDescription = ''
      ONNX Runtime is a performance-focused complete scoring engine
      for Open Neural Network Exchange (ONNX) models, with an open
      extensible architecture to continually address the latest developments
      in AI and Deep Learning. ONNX Runtime stays up to date with the ONNX
      standard with complete implementation of all ONNX operators, and
      supports all ONNX releases (1.2+) with both future and backwards
      compatibility.
    '';
    homepage = "https://github.com/microsoft/onnxruntime";
    changelog = "https://github.com/microsoft/onnxruntime/releases/tag/v${version}";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = [ ];
  };
}
