{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:

with lib;

# TODO: Remove uwsm. Idk why i bothered to add it, it sucks.

let
  cfg = config.pers.hyprland;
in
{
  options.pers.hyprland = {
    enable = mkEnableOption "hyprland";
    asahiSupport = mkEnableOption "Asahi Hyprland support";
    monitor = mkOption {
      type = types.nullOr (types.attrsOf (types.either types.int types.str));
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
      # TODO: hyprpolkitagent. Keep in mind uwsm.
      # TODO: Figure out uwsm, app slices, performance, whatnot.

      # Screenshots
      grim
      slurp
      swappy

      # Counting
      # TODO: Fix cause openjdk 23 end of life
      # pers.keybindcount
    ];

    # Screenshots
    home.file = {
      ".config/swappy/config".text = ''
        [Default]
        save_dir=$HOME/Images
        save_filename_format=%Y-%m-%dT%H:%M:%S.png
      '';
    };

    wayland.windowManager.hyprland =

      let
        makeBinds = builtins.map (x: {
          _args = x;
        });
      in

      {
        enable = true;
        systemd.enable = false;

        configType = "lua";

        settings = {
          monitor = mkIf (cfg.monitor != null) cfg.monitor;

          config = [
            {
              general = {
                resize_on_border = false; # Can't resize windows by clicking on borders
                allow_tearing = false;
                layout = "dwindle"; # Normal Hyprland layout. Alternative is master.
              };

              dwindle = {
                # pseudotile = true; doesn't work when converting to lua
                preserve_split = true;
              };

              misc = {
                force_default_wallpaper = 0;
                disable_hyprland_logo = true;
              };

              input = {
                kb_layout = pers.mkIfNotNull config.pers.info.kb_layout;
                kb_variant = pers.mkIfNotNull config.pers.info.kb_variant;
                kb_options = pers.mkIfNotNull config.pers.info.kb_options;

                repeat_delay = 150;
                repeat_rate = 40; # Does not work, along with many of those settinsg because of nixos I think.

                follow_mouse = 1;

                accel_profile = "flat";

                sensitivity = 1;

                touchpad = {
                  natural_scroll = true;
                  tap_to_click = false;
                  disable_while_typing = false;
                  clickfinger_behavior = 1;
                };
              };

              cursor = {
                inactive_timeout = 5;
                enable_hyprcursor = true;
              };
            }
          ];

          device = [
            {
              name = "primax-electronics-apple-optical-usb-mouse";
              sensitivity = 0.6; # Doubled cause scaling
            }
          ];

          bind =
            let
              brightnessctlBin = getExe pkgs.brightnessctl;
              wpctlBin = "${osConfig.services.pipewire.wireplumber.package}/bin/wpctl";
            in
            makeBinds (
              [
                (mkIf (config.pers.info.menu != null) [
                  "SUPER + D"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.pers.info.menu}\")")
                ])
                [
                  "SUPER + RETURN"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.pers.info.terminal}\")")
                ]
                (mkIf config.pers.tmux.enable [
                  "SUPER + T"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"alacritty -e tmux -S /run/user/1000/tmux-1000/default\")")
                ])
                (mkIf (config.pers.tmux.enable && config.pers.neovim.enable) [
                  "SUPER + Y"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"alacritty -e tmux -S /run/user/1000/tmux-1000/default new-session -A -s notes 'cd ~/Documents/Vaults/personal && nvim -c \\\":Obsidian quick_switch\\\"'\")")
                ])
                [
                  "SUPER + Q"
                  (lib.generators.mkLuaInline "hl.dsp.window.close()")
                ]
                (mkIf config.programs.wlogout.enable [
                  "SUPER + M"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wlogout\")")
                ])
                (mkIf (config.pers.info.fileManager != null) [
                  "SUPER + E"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.pers.info.fileManager}\")")
                ])
                (mkIf (config.pers.info.music != null) [
                  "SUPER + A"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.pers.info.music}\")")
                ])
                (mkIf (config.pers.info.wallpaperPickerCommand != null) [
                  "SUPER + Z"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.pers.info.wallpaperPickerCommand}\")")
                ])
                [
                  "SUPER + V"
                  (lib.generators.mkLuaInline "hl.dsp.window.float({ action = \"toggle\" })")
                ]
                [
                  "SUPER + P"
                  (lib.generators.mkLuaInline "hl.dsp.window.pin({})")
                ]
                [
                  "SUPER + S"
                  (lib.generators.mkLuaInline "hl.dsp.layout(\"togglesplit\")")
                ]
                [
                  "SUPER + F"
                  (lib.generators.mkLuaInline "hl.dsp.window.fullscreen({ action = \"toggle\" })")
                ]
                [
                  "SUPER + C"
                  (lib.generators.mkLuaInline "hl.dsp.window.center({})")
                ]
                [
                  "SUPER + U"
                  (lib.generators.mkLuaInline "hl.dsp.focus({ urgent_or_last = true })")
                ]
                [
                  "SUPER + O" # Schreenshot to clipboard
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"grim -g \\\"$(slurp -w 0)\\\" - | wl-copy\")")
                ]
                [
                  "SUPER + SHIFT + O" # Schreenshot to swappy
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"grim -g \\\"$(slurp -w 0)\\\" - | swappy -f -\")")
                ]
                [
                  "SUPER + ALT + O" # Schreenshot to file
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"grim -g \\\"$(slurp -w 0)\\\" \\\"$HOME/Images/$(date +'%Y-%m-%dT%H:%M:%S').png\\\"\")")
                ]
                [
                  "SUPER + CTRL + O" # Screenshot of screen to clipboard
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"grim - | wl-copy\")")
                ]
                [
                  "SUPER + SHIFT + CTRL + O" # Screenshot of screen to swappy
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"grim - | swappy -f -\")")
                ]
                [
                  "SUPER + H"
                  (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"left\" })")
                ]
                [
                  "SUPER + J"
                  (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"down\" })")
                ]
                [
                  "SUPER + K"
                  (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"up\" })")
                ]
                [
                  "SUPER + L"
                  (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"right\" })")
                ]
                [
                  "SUPER + SHIFT + H"
                  (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"left\" })")
                ]
                [
                  "SUPER + SHIFT + J"
                  (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"down\" })")
                ]
                [
                  "SUPER + SHIFT + K"
                  (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"up\" })")
                ]
                [
                  "SUPER + SHIFT + L"
                  (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"right\" })")
                ]
                [
                  "SUPER + G"
                  (lib.generators.mkLuaInline "hl.dsp.window.set_prop({ prop = \"opacity\", value = 0.0 })")
                ]
                [
                  "SUPER + SHIFT + G"
                  (lib.generators.mkLuaInline "hl.dsp.window.set_prop({ prop = \"opacity\", value = 1.0 })")
                ]
                [
                  "SUPER + N"
                  (lib.generators.mkLuaInline "hl.dsp.submap(\"counting\")")
                ]
                [
                  "SUPER + CTRL + SHIFT + P"
                  (lib.generators.mkLuaInline "hl.dsp.submap(\"passthru\")")
                ]
                [
                  "SUPER + ALT + H"
                  (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = -40, y = 0, relative = true })")
                  { repeating = true; }
                ]
                [
                  "SUPER + ALT + J"
                  (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = -40, relative = true })")
                  { repeating = true; }
                ]
                [
                  "SUPER + ALT + K"
                  (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = 40, relative = true })")
                  { repeating = true; }
                ]
                [
                  "SUPER + ALT + L"
                  (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 40, y = 0, relative = true })")
                  { repeating = true; }
                ]
                [
                  "SUPER + SHIFT + ALT + H"
                  (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = -10, y = 0, relative = true })")
                  { repeating = true; }
                ]
                [
                  "SUPER + SHIFT + ALT + J"
                  (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = -10, relative = true })")
                  { repeating = true; }
                ]
                [
                  "SUPER + SHIFT + ALT + K"
                  (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = 10, relative = true })")
                  { repeating = true; }
                ]
                [
                  "SUPER + SHIFT + ALT + L"
                  (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 10, y = 0, relative = true })")
                  { repeating = true; }
                ]
                [
                  "SUPER + BACKSPACE"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"hyprctl switchxkblayout all next\")")
                ]
                [
                  "SUPER + mouse:272"
                  (lib.generators.mkLuaInline "hl.dsp.window.drag()")
                  { mouse = true; }
                ]
                [
                  "SUPER + mouse:273"
                  (lib.generators.mkLuaInline "hl.dsp.window.resize()")
                  { mouse = true; }
                ]
                [
                  "XF86AudioMute"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${wpctlBin} set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
                  { locked = true; }
                ]
                [
                  "XF86MonBrightnessDown"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${brightnessctlBin} set 5%-\")")
                  {
                    locked = true;
                    repeating = true;
                  }
                ]
                [
                  "XF86MonBrightnessUp"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${brightnessctlBin} set 5%+\")")
                  {
                    locked = true;
                    repeating = true;
                  }
                ]
              ]
              ++ (optionals config.pers.mpd.enable [
                [
                  "XF86AudioPrev"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"mpc prev\")")
                  { locked = true; }
                ]
                [
                  "XF86AudioNext"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"mpc next\")")
                  { locked = true; }
                ]
                [
                  "XF86AudioPlay"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"mpc toggle\")")
                  { locked = true; }
                ]
              ])
              ++ (optionals osConfig.services.pipewire.wireplumber.enable [
                [
                  "XF86AudioRaiseVolume"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${wpctlBin} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+\")")
                  {
                    locked = true;
                    repeating = true;
                  }
                ]
                [
                  "XF86AudioLowerVolume"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${wpctlBin} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-\")")
                  {
                    locked = true;
                    repeating = true;
                  }
                ]
              ])
              ++ (
                # workspaces
                # binds SUPER + [shift +] {1..10} to [move to] workspace {1..10}
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
                      [
                        "SUPER + ${ws}"
                        (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = ${toString (x + 1)} })")
                      ]
                      [
                        "SUPER + SHIFT + ${ws}"
                        (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = ${toString (x + 1)}, follow = true })")
                      ]
                    ]
                  ) 10
                )
              )
            );

          window_rule = [
            {
              # Ignore maximize requests from all apps. You'll probably like this.
              name = "suppress-maximize-events";
              match = {
                class = ".*";
              };
              suppress_event = "maximize";
            }
            {
              # Fix some dragging issues with XWayland
              name = "fix-xwayland-drags";
              match = {
                class = "^$";
                title = "^$";
                xwayland = true;
                float = true;
                fullscreen = false;
                pin = false;
              };

              no_focus = true;
            }
          ];
        };

        submaps.passthru.settings = {
          bind = makeBinds [
            [
              "SUPER + CTRL + SHIFT + P"
              (lib.generators.mkLuaInline "hl.dsp.submap(\"reset\")")
            ]
          ];
        };

        submaps.counting.settings = {
          # TODO: Finish countig submap

          # # Counting
          # submap = counting
          # bind = , r, exec, rm ~/.cache/dct/num.txt; mkdir -p ~/.cache/dct
          # bind = , c, exec, keybindcount
          # bind = , x, exec, keybindcount x
          # bind = , e, exec, keybindcount exp
          # bind = , g, exec, keybindcount egexp
          # bind = , l, exec, keybindcount l
          # bind = , k, exec, keybindcount classic
          # bind = , s, exec, notify-send "Current status: `cat ~/.cache/dct/num.txt`"
          # ${builtins.concatStringsSep "\n" (
          #   builtins.genList (
          #     index:
          #     "bind = , ${toString index}, exec, mkdir -p ~/.cache/dct && echo -n '${toString index}' >> ~/.cache/dct/num.txt"
          #   ) 10
          # )}
          # bind = , escape, submap, reset
          # submap = reset
          bind = makeBinds [
            [
              "SUPER + N"
              (lib.generators.mkLuaInline "hl.dsp.submap(\"reset\")")
            ]
          ];
        };
      };
  };
}
