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
    rev = "bd3f3fdaa47d86d1aca2814fc4e3695bbda6c9b7";
    sha256 = "sha256-LANxyrlCN2jIRgs6C+ENNBOQ79hRwxhWt2Clq+uO/MM=";
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
