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
    rev = "7f3dfd340710961d47cbf84ba4ca489e7b3c83ff";
    hash = "sha256-9qbChP9BAVADawXS2LvPbx3DmB0SUQntL7/bmL/TPUM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LhFnk+xOefeDhDAhkwyxF0tVePJjh6BZPfuytMg6Pb8=";

  meta.mainProgram = "guildbot";
}
