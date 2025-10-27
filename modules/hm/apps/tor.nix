{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.tor.enable = lib.mkEnableOption "tor";

  config = lib.mkIf config.pers.tor.enable {
    assertions = lib.singleton {
      assertion = true;
      message = "Tor nightly build needs to be updated";
    };

    # WARNING: This is a nightly build, it may not be safe
    # Nightly builds can be found here: https://nightlies.tbb.torproject.org/nightly-builds/
    # To re-install, updating to a new nightly build is required
    home.packages = [
      (pkgs.tor-browser.overrideAttrs (
        finalAttrs: previousAttrs: {
          src = pkgs.fetchurl {
            urls = [
              "https://nightlies.tbb.torproject.org/nightly-builds/tor-browser-builds/tbb-nightly.2025.10.26/nightly-linux-aarch64/tor-browser-linux-aarch64-tbb-nightly.2025.10.26.tar.xz"
            ];
            hash = "sha256-iUu5cyfPdRpuMg+5adLwpbK4cYll6uaEs2FpGl/H5Qc=";
          };
          meta.platforms = [ "aarch64-linux" ];
          buildPhase =
            builtins.replaceStrings [ "fontconfig/fonts.conf" ] [ "fonts/fonts.conf" ]
              previousAttrs.buildPhase;
        }
      ))
    ];
  };
}
