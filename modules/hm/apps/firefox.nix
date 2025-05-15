{
  lib,
  config,
  inputs,
  pkgs,
  settings,
  osConfig,
  ...
}:

{
  options.pers.firefox = {
    enable = lib.mkEnableOption "firefox";
    asahiSupport = lib.mkEnableOption "Asahi support for firefox";
  };

  config = lib.mkIf config.pers.firefox.enable {
    home.packages = with pkgs; [ nixos-icons ];

    programs.firefox = {
      enable = true;

      languagePacks = [ "en-US" ];

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        SearchBar = "unified";
      };

      profiles.${settings.username} = {
        id = 0;
        isDefault = true;

        bookmarks.force = true;
        bookmarks.settings = [
          {
            name = "Wikipedia";
            tags = [ "wiki" ];
            keyword = "wiki";
            url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
          }
          {
            name = "Nix sites";
            toolbar = true;
            bookmarks = [
              {
                name = "Homepage";
                url = "https://nixos.org/";
              }
              {
                name = "Wiki";
                tags = [
                  "wiki"
                  "nix"
                ];
                url = "https://wiki.nixos.org/";
              }
              {
                name = "Homemanager";
                tags = [
                  "home"
                  "manager"
                  "nix"
                ];
                url = "https://nix-community.github.io/home-manager/options.xhtml";
              }
            ];
          }
        ];

        settings = {
          "extensions.autoDisableScopes" = 0;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.tabs.closeWindowWithLastTab" = false;
          "browser.startup.page" = 3;
        };

        extensions = {
          # Override old settings and use JSON instead of SQLITE
          # force = true;

          packages = with inputs.firefox-addons.packages.${osConfig.nixpkgs.hostPlatform.system}; [
            ublock-origin
            privacy-badger
            user-agent-string-switcher
            tridactyl
            stylus
            firefox-color
            videospeed
          ];

          # Go to about:debugging
          settings = {
            # Stylus
            # "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".settings = {
            #   dbInChromeStorage = true;
            # };

            # User-Agent Switcher and Manager
            # "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}".settings = {
            #   blacklist = [ ];
            #   custom = {
            #     # https://docs.fedoraproject.org/en-US/fedora-asahi-remix/faq/#widevine
            #     "www.netflix.com" =
            #       lib.mkIf config.pers.firefox.asahiSupport "Mozilla/5.0 (X11; CrOS aarch64 15329.44.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36";
            #   };
            #   exactMatch = false;
            #   faqs = true;
            #   log = false;
            #   cache = false;
            #   mode = "custom";
            #   parser = { };
            #   userAgentData = true;
            #   protected = [
            #     "google.com/recaptcha"
            #     "gstatic.com/recaptcha"
            #     "accounts.google.com"
            #     "accounts.youtube.com"
            #     "gitlab.com/users/sign_in"
            #   ];
            #   whitelist = [ ];
            # };

            # "FirefoxColor@mozilla.com".settings = {
            #   firstRunDone = true;
            #   images = { };
            # };
          };
        };

        search.default = "google";
        search.force = true;
        search.engines = {
          nix-packages = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          nixos-wiki = {
            urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nw" ];
          };

          google.metaData.alias = "@g";
          wikipedia.metaData.alias = "@w";
        };
      };
    };
  };
}
