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
    rev = "c101f10af431e516c7d9ed535a603c071d10ea71";
    hash = "sha256-smiNc5r5zJNM0ukh10DqGtLf5cmBBWVY1+COalhZl24=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LhFnk+xOefeDhDAhkwyxF0tVePJjh6BZPfuytMg6Pb8=";

  meta.mainProgram = "guildbot";
}
