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
    impermanence.enable = true;
    hyprland.enable = true;
    postgresql.enable = true;
    virtualisation.enable = true;
    git.enable = true;
    ssh-agent.enable = true;
    nh.enable = true;
    greetd = {
      enable = true;
      startCommand = "Hyprland";
    };
    pipewire.enable = true;
    networkmanager.enable = true;
    users = {
      enable = true;
      extraGroups = [
        "video"
        "dialout"
      ];
    };
    basic.enable = true;
    shell.enable = true;
    sops.enable = true;
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

      rice.enabled = "newconfig";
    };

    home.packages = with pkgs; [
      prismlauncher
      obs-studio
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
}
