{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.pers.hyprland;
in
{
  options.pers.hyprland = {
    enable = mkEnableOption "hyprland";
    asahiSupport = mkEnableOption "Asahi Hyprland support";
    monitor = mkOption {
      type = types.nullOr types.str;
      description = "Monitor to use in Hyprland configuration";
      default = null;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.pers.hyprland.enable;
        message = "Hyprland System-level support must be enabled for the home-manager module to be enabled.";
      }
      {
        assertion = config.pers.info.terminal != null;
        message = "A terminal must be set for the Hyprland module to be enabled.";
      }
    ];

    pers.wayland.enable = true;

    pers.hyprland.monitor = mkIf osConfig.pers.virtualisation.isVmVariant (mkForce ",preferred,auto,1");

    home.sessionVariables = mkIf cfg.asahiSupport {
      WLR_DRM_DEVICES = "/dev/dri/card0";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    home.packages = with pkgs; [
      brightnessctl

      # Screenshots
      grim
      slurp
      swappy

      # Counting
      pers.keybindcount
    ];

    # Screenshots
    home.file = {
      ".config/swappy/config".text = ''
        [Default]
        save_dir=$HOME/Images
        save_filename_format=%Y-%m-%dT%H:%M:%S.png
      '';
    };

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        "$mod" = "SUPER";

        monitor = mkIf (cfg.monitor != null) cfg.monitor;

        # Set variables in config
        "$terminal" = config.pers.info.terminal;
        "$tmux" = mkIf config.pers.tmux.enable "alacritty -e tmux -S /run/user/1000/tmux-1000/default";
        "$notes" =
          mkIf (config.pers.tmux.enable && config.pers.neovim.enable)
            "alacritty -e tmux -S /run/user/1000/tmux-1000/default new-session -A -s notes 'cd ~/Documents/Vaults/personal && nvim -c \":ObsidianQuickSwitch\"'";
        "$fileManager" = pers.mkIfNotNull config.pers.info.fileManager;
        "$menu" = pers.mkIfNotNull config.pers.info.menu;
        "$music" = pers.mkIfNotNull config.pers.info.music;

        # Startup
        # exec-once = singleton (mkIf config.programs.waybar.enable "waybar");

        general = {
          resize_on_border = false; # Can't resize windows by clicking on borders
          allow_tearing = false;
          layout = "dwindle"; # Normal Hyprland layout. Alternative is master.
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        misc = {
          force_default_wallpaper = "0";
          disable_hyprland_logo = true;
          vfr = true;
        };

        input = {
          kb_layout = pers.mkIfNotNull config.pers.info.kb_layout;
          kb_variant = pers.mkIfNotNull config.pers.info.kb_variant;
          kb_options = pers.mkIfNotNull config.pers.info.kb_options;

          repeat_delay = "250";
          repeat_rate = "20"; # Does not work, along with many of those settinsg because of nixos I think.

          follow_mouse = "1";

          accel_profile = "flat";

          sensitivity = "1";

          touchpad = {
            natural_scroll = true;
            tap-to-click = false;
            disable_while_typing = true;
            clickfinger_behavior = "1";
          };
        };

        device = [
          {
            name = "primax-electronics-apple-optical-usb-mouse";
            sensitivity = "0.6"; # Doubled cause scaling
          }
        ];

        cursor = {
          inactive_timeout = "5";
          enable_hyprcursor = true;
        };

        gestures = {
          workspace_swipe = false;
        };

        bind =
          [
            (mkIf (config.pers.info.menu != null) "$mod, D, exec, $menu")
            "$mod, RETURN, exec, $terminal"
            (mkIf config.pers.tmux.enable "$mod, T, exec, $tmux")
            (mkIf (config.pers.tmux.enable && config.pers.neovim.enable) "$mod, Y, exec, $notes")
            "$mod, Q, killactive"
            (mkIf config.programs.wlogout.enable "$mod, M, exec, wlogout")
            (mkIf (config.pers.info.fileManager != null) "$mod, E, exec, $fileManager")
            (mkIf (config.pers.info.music != null) "$mod, A, exec, $music")
            (mkIf (
              config.pers.info.wallpaperPickerCommand != null
            ) "$mod, Z, exec, ${config.pers.info.wallpaperPickerCommand}")

            "$mod, V, togglefloating"
            "$mod, P, pin" # Pin a floating window so it's visible in all workspaces
            "$mod, S, togglesplit"
            "$mod, F, fullscreen"
            "$mod, C, centerwindow" # Centers window in floating mode
            "$mod, U, focusurgentorlast" # Focuses the window marked as urgent

            "$mod, O, exec, grim -g \"$(slurp -w 0)\" - | wl-copy" # Screenshot to clipboard.
            "$mod&SHIFT, O, exec, grim -g \"$(slurp -w 0)\" - | swappy -f -" # Screenshot to swappy.
            "$mod&ALT, O, exec, grim -g \"$(slurp -w 0)\" \"$HOME/Images/$(date +'%Y-%m-%dT%H:%M:%S').png\"" # Screenshot to file.
            "$mod&CTRL, O, exec, grim - | wl-copy" # Screenshot of screen to clipboard.
            "$mod&CTRL&SHIFT, O, exec, grim - | swappy -f -" # Screenshot of screen to swappy.

            "$mod, H, movefocus, l"
            "$mod, L, movefocus, r"
            "$mod, J, movefocus, d"
            "$mod, K, movefocus, u"
            "$mod&SHIFT, H, movewindow, l"
            "$mod&SHIFT, L, movewindow, r"
            "$mod&SHIFT, J, movewindow, d"
            "$mod&SHIFT, K, movewindow, u"

            "$mod, G, setprop, activewindow alpha 0.0 lock"
            "$mod&SHIFT, G, setprop, activewindow alpha 1.0 lock"

            "$mod, R, submap, resize"
            "$mod, N, submap, counting"
            "$mod&CTRL&SHIFT, P, submap, passthru"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
            builtins.concatLists (
              builtins.genList (
                x:
                let
                  ws =
                    let
                      c = (x + 1) / 10;
                    in
                    builtins.toString (x + 1 - (c * 10));
                in
                [
                  "$mod, ${ws}, workspace, ${toString (x + 1)}"
                  "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                ]
              ) 10
            )
          );

        # Mouse bindings
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        # Binds that work even with an input inhibitor
        bindl =
          [ ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" ]
          ++ optionals config.pers.mpd.enable [
            ", XF86AudioPrev, exec, mpc prev"
            ", XF86AudioNext, exec, mpc next"
            ", XF86AudioPlay, exec, mpc toggle"
          ];

        # Binds that work with an input inhibitor and press and hold
        bindel =
          let
            brightnessctlBin = getExe pkgs.brightnessctl;
            wpctlBin = "${osConfig.services.pipewire.wireplumber.package}/bin/wpctl";
          in
          [
            ", XF86MonBrightnessDown, exec, ${brightnessctlBin} set 5%-"
            ", XF86MonBrightnessUp, exec, ${brightnessctlBin} set 5%+"
          ]
          ++ optionals osConfig.services.pipewire.wireplumber.enable [
            ", XF86AudioRaiseVolume, exec, ${wpctlBin} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, ${wpctlBin} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"
          ];

        windowrulev2 = "suppressevent maximize, class:.*";
      };

      extraConfig = ''
        # will start a submap called "resize"
        submap = resize

        # sets repeatable binds for resizing the active window
        binde = , l, resizeactive, 10 0
        binde = , h, resizeactive, -10 0
        binde = , k, resizeactive, 0 -10
        binde = , j, resizeactive, 0 10

        # use reset to go back to the global submap
        bind = , escape, submap, reset 

        # will reset the submap, which will return to the global submap
        submap = reset

        # Counting
        submap = counting
        bind = , r, exec, rm ~/.cache/dct/num.txt; mkdir -p ~/.cache/dct
        bind = , c, exec, keybindcount
        bind = , x, exec, keybindcount x
        bind = , l, exec, keybindcount l
        bind = , k, exec, keybindcount classic
        bind = , s, exec, notify-send "Current status: `cat ~/.cache/dct/num.txt`"
        ${builtins.concatStringsSep "\n" (
          builtins.genList (
            index:
            "bind = , ${toString index}, exec, mkdir -p ~/.cache/dct && echo -n '${toString index}' >> ~/.cache/dct/num.txt"
          ) 10
        )}
        bind = , escape, submap, reset
        submap = reset

        # Passthru
        submap = passthru
        bind = $mod&CTRL&SHIFT, p, submap, reset
        submap = reset
      '';
    };
  };
}
