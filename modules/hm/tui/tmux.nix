{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.pers.tmux;

  askai-tmux = (
    pkgs.writeShellScriptBin "askai-tmux" ''
      set -e
      read -r input
      tmux new-window -n "LLAMA-3" \; send-keys -t "LLAMA-3" "clear; m \"$input\"; tmux copy-mode" Enter
    ''
  );
in
{
  options.pers.tmux.enable = mkEnableOption "tmux";

  # TODO: Refine this module

  # TODO: Fix nvim -c ":ObsidianQuickSwitch" not working (temporarily switched to nvim) and also -c ":Telescope find_files"

  config = mkIf cfg.enable {
    home.packages = [ pkgs.sesh ];

    programs.tmux = {
      enable = true;
      keyMode = "vi";
      escapeTime = 0;
      historyLimit = 3000;
      terminal = "tmux-256color";
      sensibleOnTop = false;
      disableConfirmationPrompt = true;

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavor 'mocha' # latte, frappe, macchiato or mocha
            set -g @catppuccin_status_default "on"
          '';
        }
      ];

      # TODO: Add the source-file to onChange
      extraConfig = ''
        # Refresh config with keybinding
        bind R source-file ~/.config/tmux/tmux.conf

        # Vim hjkl rather than arrow keys
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        # Allow resizing with hjkl
        bind C-h resize-pane -L
        bind C-j resize-pane -D
        bind C-k resize-pane -U
        bind C-l resize-pane -R

        # Also add Ctrl+n and Ctrl+p rather than just n and p so you can hold it and spam them
        bind C-n next-window
        bind C-p previous-window

        # Stay in the same directory when a new window is opened
        bind % split-window -h -c "#{pane_current_path}"
        bind '"' split-window -v -c "#{pane_current_path}"

        # Smart pane switching with awareness of Vim splits.
        # See: https://github.com/christoomey/vim-tmux-navigator
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
        bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
        bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
        bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
        bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
        tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
        if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
            if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
              "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

                bind-key -T copy-mode-vi 'C-h' select-pane -L
                bind-key -T copy-mode-vi 'C-j' select-pane -D
                bind-key -T copy-mode-vi 'C-k' select-pane -U
                bind-key -T copy-mode-vi 'C-l' select-pane -R
                bind-key -T copy-mode-vi 'C-\' select-pane -l

        # Status bar
        set -g status-position top

        # Sesh
        set -g detach-on-destroy off # don't exit from tmux when closing a session
        bind -N "last-session (via sesh) " L run-shell "sesh last"

        bind-key "T" run-shell "sesh connect \"$(
            sesh list | fzf-tmux -p 55%,60% \
            --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
            --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
            --bind 'tab:down,btab:up' \
            --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list)' \
            --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t)' \
            --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c)' \
            --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z)' \
            --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
            --bind 'ctrl-d:execute(tmux kill-session -t {})+change-prompt(⚡  )+reload(sesh list)'
            )\""

        # Copy mode
        bind -T copy-mode-vi v send -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-pipe
        bind P paste-buffer

        # AI Question
        bind-key "C-h" popup -E -T "Enter your prompt" ${getExe askai-tmux}

        bind-key "C-t" popup -w 70% -h 70% -E -T "Temporary Shell"
        ${optionalString config.pers.btop.enable "bind-key \"C-s\" popup -w 80% -h 80% -E -T \"Computer Statistics\" ${getExe config.programs.btop.package}"}

        # Notes
        bind-key "N" new-session -A -s notes 'cd ~/Documents/Vaults/personal && nvim'

        # Image rendering for image.nvim
        set -gq allow-passthrough on
        set -g visual-activity off

        # Mouse support (scrolling)
        setw -g mouse on
      '';
    };

    home.file = {
      ".config/sesh/sesh.toml".text = ''
        [default_session]
        startup_command = "nvim"
      '';
    };
  };
}
