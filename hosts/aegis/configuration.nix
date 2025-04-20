{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  # System
  pers = {
    tty.enable = true;
    openssh.enable = true;
    home-manager.enable = true;
    impermanence.enable = true;
    disko.enable = true;
    hyprland.enable = true;
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
    sops = {
      enable = true;
      accounts = true;
      user = true;
    };
  };

  # Home Manager
  pers.home-manager.imports = lib.singleton {
    pers = {
      hyprland.monitor = "eDP-1,2560x1600@60,auto,1";
      tmux.enable = true;
      rofi.enable = true;
      yazi.enable = true;
      zsh.enable = true;
      starship.enable = true;
      nixcord.enable = true;
      firefox.enable = true;
      mako.enable = true;
      hypridle.enable = true;
      wlogout.enable = true;
      gh.enable = true;
      mpv.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      zoxide.enable = true;
      mods.enable = true;
      git.enable = true;
      reb.enable = true;
      twofa.enable = true;
      neovim.enable = true;
      zathura.enable = true;
      cava.enable = true;
      btop.enable = true;

      rice.enabled = "newconfig";
    };

    home.packages = with pkgs; [
      calc
      ffmpeg
    ];
  };

  services.udisks2.enable = true; # Manage disks / usb inputs.
  services.printing.enable = true; # Enable CUPS to print documents.
  time.timeZone = config.sensitive.timeZone;
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
  documentation.nixos.enable = false;
}
