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
    rev = "2017a6369477f999c5c6f094dbfb1437e51af0d7";
    sha256 = "sha256-a8RzdY1qLOsvQ/y9+md1zK5q8EvnCSxt7uPIBBV0JoU=";
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
