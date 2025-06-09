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
    rev = "9115ae5ce5fa9ec493713061bbacb57bde81afa7";
    hash = "sha256-Csnvt7UATQjs1zARvpyorGhEjN+Auu+EOp4cLS2bwGI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LhFnk+xOefeDhDAhkwyxF0tVePJjh6BZPfuytMg6Pb8=";

  meta.mainProgram = "guildbot";
}
