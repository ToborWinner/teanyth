lib: colors:

with colors;
with lib;

# This template is taken from https://github.com/danth/stylix/blob/aeb550add3bfa1ce3ce249c3b3dad71ebb018318/modules/gtk/gtk.mustache
let
  patchColor = color: substring (stringLength color - 1) (stringLength color + 5) ("00000" + color);
  rgb =
    colorUnpatched:
    let
      color = patchColor colorUnpatched;
    in
    {
      r = toString (fromHexString (substring 0 2 color));
      g = toString (fromHexString (substring 2 4 color));
      b = toString (fromHexString (substring 4 6 color));
    };
  rgb4 = rgb color4;
in
''
  @define-color accent_color #${color13};
  @define-color accent_bg_color #${color13};
  @define-color accent_fg_color #${background};
  @define-color destructive_color #${color8};
  @define-color destructive_bg_color #${color8};
  @define-color destructive_fg_color #${background};
  @define-color success_color #${color11};
  @define-color success_bg_color #${color11};
  @define-color success_fg_color #${background};
  @define-color warning_color #${color14};
  @define-color warning_bg_color #${color14};
  @define-color warning_fg_color #${background};
  @define-color error_color #${color8};
  @define-color error_bg_color #${color8};
  @define-color error_fg_color #${background};
  @define-color window_bg_color #${background};
  @define-color window_fg_color #${foreground};
  @define-color view_bg_color #${background};
  @define-color view_fg_color #${foreground};
  @define-color headerbar_bg_color #${color1};
  @define-color headerbar_fg_color #${foreground};
  @define-color headerbar_border_color rgba(${rgb4.r}, ${rgb4.g}, ${rgb4.b}, 0.7);
  @define-color headerbar_backdrop_color @window_bg_color;
  @define-color headerbar_shade_color rgba(0, 0, 0, 0.07);
  @define-color headerbar_darker_shade_color rgba(0, 0, 0, 0.07);
  @define-color sidebar_bg_color #${color1};
  @define-color sidebar_fg_color #${foreground};
  @define-color sidebar_backdrop_color @window_bg_color;
  @define-color sidebar_shade_color rgba(0, 0, 0, 0.07);
  @define-color secondary_sidebar_bg_color @sidebar_bg_color;
  @define-color secondary_sidebar_fg_color @sidebar_fg_color;
  @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
  @define-color secondary_sidebar_shade_color @sidebar_shade_color;
  @define-color card_bg_color #${color1};
  @define-color card_fg_color #${foreground};
  @define-color card_shade_color rgba(0, 0, 0, 0.07);
  @define-color dialog_bg_color #${color1};
  @define-color dialog_fg_color #${foreground};
  @define-color popover_bg_color #${color1};
  @define-color popover_fg_color #${foreground};
  @define-color popover_shade_color rgba(0, 0, 0, 0.07);
  @define-color shade_color rgba(0, 0, 0, 0.07);
  @define-color scrollbar_outline_color #${color2};
  @define-color blue_1 #${color12};
  @define-color blue_2 #${color12};
  @define-color blue_3 #${color12};
  @define-color blue_4 #${color12};
  @define-color blue_5 #${color12};
  @define-color green_1 #${color10};
  @define-color green_2 #${color10};
  @define-color green_3 #${color10};
  @define-color green_4 #${color10};
  @define-color green_5 #${color10};
  @define-color yellow_1 #${color11};
  @define-color yellow_2 #${color11};
  @define-color yellow_3 #${color11};
  @define-color yellow_4 #${color11};
  @define-color yellow_5 #${color11};
  @define-color orange_1 #${color3};
  @define-color orange_2 #${color3};
  @define-color orange_3 #${color3};
  @define-color orange_4 #${color3};
  @define-color orange_5 #${color3};
  @define-color red_1 #${color9};
  @define-color red_2 #${color9};
  @define-color red_3 #${color9};
  @define-color red_4 #${color9};
  @define-color red_5 #${color9};
  @define-color purple_1 #${color5};
  @define-color purple_2 #${color5};
  @define-color purple_3 #${color5};
  @define-color purple_4 #${color5};
  @define-color purple_5 #${color5};
  @define-color brown_1 #${color1};
  @define-color brown_2 #${color1};
  @define-color brown_3 #${color1};
  @define-color brown_4 #${color1};
  @define-color brown_5 #${color1};
  @define-color light_1 #${color15};
  @define-color light_2 #${color15};
  @define-color light_3 #${color15};
  @define-color light_4 #${color15};
  @define-color light_5 #${color15};
  @define-color dark_1 #${color0};
  @define-color dark_2 #${color0};
  @define-color dark_3 #${color0};
  @define-color dark_4 #${color0};
  @define-color dark_5 #${color0};
''
