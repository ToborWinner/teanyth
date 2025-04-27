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
    rev = "570fdb88451522a8dca6c55a23c0e041060b7ead";
    sha256 = "sha256-jBZNVaDUCINHzfwKvZMRaGj6JCLoM0b/M11eU5zGWEo=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    pixman
    cairo
    pango
  ];

  npmDepsHash = "sha256-kmHS/bEO3I2rZ+y+FJ2I1G7FVloImVFEn5s5dhBwMUk=";

  dontNpmBuild = true;

  meta.mainProgram = pname;
}
