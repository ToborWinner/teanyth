{
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  postgresql_17,
}:

rustPlatform.buildRustPackage {
  pname = "guildbot";
  version = "0.0.1";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    postgresql_17.lib
  ];

  src = fetchFromGitHub {
    owner = "ToborWinner";
    repo = "guildbot";
    rev = "0731a533c9433ee5cd657ba1e4b251d1163682db";
    hash = "sha256-x3JXbqhwVdbTAY+1Xds2MM+3S8f/KKTavxy020unJiQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LhFnk+xOefeDhDAhkwyxF0tVePJjh6BZPfuytMg6Pb8=";

  meta.mainProgram = "guildbot";
}
