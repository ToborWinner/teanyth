{
  buildNpmPackage,
  jollydashboardsrc ? null,
  lib,
}:

buildNpmPackage {
  pname = "jollydashboard";
  version = "1.0.0";

  # TODO: Use fetchFromGitHub private version (it supports private fetching). This will require some more advanced setup since I don't want to have to set the USERNAME and PASSWORD environment variables.
  src =
    if jollydashboardsrc == null then
      lib.warn "Please override the package with a source." ./default.nix
    else
      jollydashboardsrc;

  npmDepsHash = "sha256-xNB/BaqMSi585373YsyqiGdXCkL4ED3XvOT6Eyq66J0=";

  meta.mainProgram = "jollydashboard";
}
