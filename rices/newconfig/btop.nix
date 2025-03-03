{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.btop.settings = {
    color_theme = "current";
    theme_background = false;
  };

  xdg.configFile."btop/themes/current.theme" = lib.mkIf config.pers.btop.enable {
    text = with config.pers.rice.currentTheme.hex; ''
      theme[main_bg]="${background}"
      theme[main_fg]="${foreground}"
      theme[title]="${color5}"
      theme[hi_fg]="${color13}"
      theme[selected_bg]="${color3}"
      theme[selected_fg]="${color13}"
      theme[inactive_fg]="${color4}"
      theme[graph_text]="${color6}"
      theme[meter_bg]="${color3}"
      theme[proc_misc]="${color6}"
      theme[cpu_box]="${color14}"
      theme[mem_box]="${color11}"
      theme[net_box]="${color12}"
      theme[proc_box]="${color13}"
      theme[div_line]="${color1}"
      theme[temp_start]="${color11}"
      theme[temp_mid]="${color10}"
      theme[temp_end]="${color8}"
      theme[cpu_start]="${color11}"
      theme[cpu_mid]="${color10}"
      theme[cpu_end]="${color8}"
      theme[free_start]="${color11}"
      theme[free_mid]="${color10}"
      theme[free_end]="${color8}"
      theme[cached_start]="${color11}"
      theme[cached_mid]="${color10}"
      theme[cached_end]="${color8}"
      theme[available_start]="${color11}"
      theme[available_mid]="${color10}"
      theme[available_end]="${color8}"
      theme[used_start]="${color11}"
      theme[used_mid]="${color10}"
      theme[used_end]="${color8}"
      theme[download_start]="${color11}"
      theme[download_mid]="${color10}"
      theme[download_end]="${color8}"
      theme[upload_start]="${color11}"
      theme[upload_mid]="${color10}"
      theme[upload_end]="${color8}"
      theme[process_start]="${color11}"
      theme[process_mid]="${color10}"
      theme[process_end]="${color8}"
    '';

    onChange = ''
      ${pkgs.procps}/bin/pkill -u $USER -USR2 btop || true
    '';
  };
}
