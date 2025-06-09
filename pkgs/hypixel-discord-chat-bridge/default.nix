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
    rev = "2d588c8edd69d81df76bda6665128a452c023c6b";
    sha256 = "sha256-LoPYRvlLo3QZnvcKMdvFWq88qr3GYQ56NRZlqUR1L68=";
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
