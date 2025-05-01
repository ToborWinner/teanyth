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
    rev = "c66a8362c980eb538e7f4c051b8f69d33ecfa078";
    hash = "sha256-10fcP0P+GkNHcPzyzy9fBXgl2HdDO2pmVquYRoThbd8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LhFnk+xOefeDhDAhkwyxF0tVePJjh6BZPfuytMg6Pb8=";

  meta.mainProgram = "guildbot";
}
