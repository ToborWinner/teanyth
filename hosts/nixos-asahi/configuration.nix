{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  # System
  pers = {
    tty.enable = true;
    home-manager.enable = true;
    impermanence = {
      enable = true;
      extraUserDirectories = [
        ".local/share/PrismLauncher"
        ".config/wordtui"
        ".config/raspberry"
        ".config/Element"
      ];
    };
    hyprland.enable = true;
    postgresql = {
      enable = true;
      development = true;
    };
    virtualisation.enable = true;
    git.enable = true;
    ssh-agent.enable = true;
    nh.enable = true;
    greetd = {
      enable = true;
      startCommand = "Hyprland";
    };
    pipewire.enable = true;
    networkmanager = {
      enable = true;
      openconnect = true;
    };
    users = {
      enable = true;
      extraGroups = [
        "video"
        "dialout"
      ];
    };
    basic.enable = true;
    shell.enable = true;
    sops = {
      enable = true;
      accounts = true;
      user = true;
    };
    tailscale.enable = true;
    distrobox.enable = true;
  };

  # Home Manager
  pers.home-manager.imports = lib.singleton {
    pers = {
      hyprland = {
        asahiSupport = true;
        monitor = "eDP-1,2560x1664@60,auto,1";
      };
      tmux.enable = true;
      rofi.enable = true;
      yazi.enable = true;
      zsh.enable = true;
      starship.enable = true;
      nixcord.enable = true;
      firefox = {
        enable = true;
        asahiSupport = true;
      };
      mako.enable = true;
      hypridle.enable = true;
      wlogout.enable = true;
      gh.enable = true;
      mpv.enable = true;
      mpd.enable = true;
      ncmpcpp.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      zoxide.enable = true;
      mods.enable = true;
      git.enable = true;
      reb.enable = true;
      twofa.enable = true;
      neovim.enable = true;
      tor.enable = true;
      zathura.enable = true;
      cava.enable = true;
      btop.enable = true;
      mail.enable = false; # When I add an email client other than thunderbird, I'll probably enable it back
      nix-index-database.enable = true;
      tex.enable = true;

      rice.enabled = "newconfig";
    };

    home.packages = with pkgs; [
      prismlauncher
      element-desktop
      obs-studio # TODO: configure through home-manager instead
      calc
      ffmpeg
      libimobiledevice # Connect to iPhone
      inputs.lobster-rs.packages.${system}.default
      inputs.wordtui.packages.${system}.default
    ];
  };

  services.usbmuxd.enable = true; # Necessary for connecting to iPhone via cable.
  services.udisks2.enable = true; # Manage disks / usb inputs.
  services.printing.enable = true; # Enable CUPS to print documents.
  time.timeZone = config.sensitive.timeZone;
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
  documentation.nixos.enable = false;
  services.avahi.enable = true; # Discover printers and other devices on the network

  # TODO: Switch to commented version when updating nixpkgs
  # services.logind.settings.Login = {
  #   HandleSuspendKey = "ignore";
  #   HandleSuspendKeyLongPress = "ignore";
  #   HandlePowerKey = "ignore";
  # };
  services.logind.powerKey = "ignore";
  services.logind.suspendKey = "ignore";
  services.logind.suspendKeyLongPress = "ignore";

  # Set to false if you have an x86_64 builder available
  # Will default to false if your nixpkgs is new enough
  # Hopefully NixOS cache can help us with this
  # nixpkgs.config.nixos-muvm-fex.mesaDoCross = false;
  # nixpkgs.overlays = [ inputs.nixos-muvm-fex.overlays.default ];
  # environment.systemPackages = [ pkgs.muvm ];

  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
}
