{
  buildNpmPackage,
  jollybotsrc,
  rustc,
  cargo,
  vips,
  pkg-config,
}:

buildNpmPackage {
  pname = "jollybot";
  version = "1.0.0";

  nativeBuildInputs = [
    rustc
    cargo
    pkg-config
  ];

  buildInputs = [
    vips
  ];

  # TODO: Use fetchFromGitHub private version (it supports private fetching). This will require some more advanced setup since I don't want to have to set the USERNAME and PASSWORD environment variables.
  src =
    if jollybotsrc == null then throw "Please override the package with a source." else jollybotsrc;

  npmDepsHash = "sha256-+n6wLxvyOvtzXsQEEB3H+mclMtcNJSiJ7yc2RWeSK6A=";

  meta.mainProgram = "jollybot";
}
