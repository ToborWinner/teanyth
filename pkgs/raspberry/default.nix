{
  rustPlatform,
  lib,
  pkg-config,
  openssl,
  alsa-lib,
  speechd-minimal,
  stdenv,
  fetchFromGitHub,
  pers,
}:

rustPlatform.buildRustPackage {
  pname = "raspberry";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "ToborWinner";
    repo = "raspberry";
    rev = "0d68ccb5e1da0db056b9004c2c53e7756aec943f";
    hash = "sha256-szBAdZPj+eA7sDJqEvlWI/P5nOQcBcPhzWbFbSQRFyQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-RyHxaJwI+OmHHIDlfWYFYw071PRW6rbu1G+DR2bc5ZQ=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    alsa-lib
    speechd-minimal
    stdenv.cc.cc.lib
    rustPlatform.bindgenHook
    pers.onnxruntime-bin
    pers.vosk-api-bin
  ];

  doCheck = false;

  meta = {
    description = "A voice assistant project intended to run on a Raspberry Pi";
    mainProgram = "raspberry";
    platforms = lib.platforms.unix;
  };
}
