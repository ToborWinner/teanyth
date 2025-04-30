{
  fetchFromGitHub,
  buildNpmPackage,
  pkg-config,
  pixman,
  cairo,
  pango,
}:

buildNpmPackage rec {
  pname = "hypixel-discord-chat-bridge";
  version = "3.1.16.3";

  src = fetchFromGitHub {
    owner = "ToborWinner";
    repo = "hypixel-discord-chat-bridge";
    rev = "0a91a33086030ceb786e79019c16389caa27c9fd";
    sha256 = "sha256-prOtRf5JHqkwfvDEiyOhOV2VgVLdQ5XhJzf2U6/eZrw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    pixman
    cairo
    pango
  ];

  npmDepsHash = "sha256-kmHS/bEO3I2rZ+y+FJ2I1G7FVloImVFEn5s5dhBwMUk=";

  dontNpmBuild = true;

  meta.mainProgram = pname;
}
