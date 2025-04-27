{
  buildNpmPackage,
  jollybotsrc ? null,
  rustc,
  cargo,
  vips,
  pkg-config,
  lib,
}:

buildNpmPackage {
  pname = "jollybot";
  version = "1.0.0";

  nativeBuildInputs = [
    rustc
    cargo
    pkg-config
  ];

  buildInputs = [ vips ];

  # TODO: Use fetchFromGitHub private version (it supports private fetching). This will require some more advanced setup since I don't want to have to set the USERNAME and PASSWORD environment variables.
  src =
    if jollybotsrc == null then
      lib.warn "Please override the package with a source." ./default.nix
    else
      jollybotsrc;

  npmDepsHash = "sha256-+n6wLxvyOvtzXsQEEB3H+mclMtcNJSiJ7yc2RWeSK6A=";

  meta.mainProgram = "jollybot";
}
