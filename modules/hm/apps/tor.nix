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

    # WARNING: This is an alpha build, it may not be safe
    # TODO: Switch to stable normal package once aarch64 support is released.
    home.packages = [
      (pkgs.tor-browser.overrideAttrs (
        finalAttrs: previousAttrs: {
          src = pkgs.fetchurl {
            urls = [
              "https://archive.torproject.org/tor-package-archive/torbrowser/16.0a5/tor-browser-linux-aarch64-16.0a5.tar.xz"
            ];
            hash = "sha256-9elX8PRDtpWPevgsiNwldmKEb09MbJr4GYMmljIJwkw=";
          };
          meta.platforms = [ "aarch64-linux" ];
          buildPhase =
            builtins.replaceStrings [ "TorBrowser/Data/Tor/torrc-defaults" ] [ "TorBrowser/Tor/torrc-defaults" ]
              previousAttrs.buildPhase;
        }
      ))
    ];
  };
}
