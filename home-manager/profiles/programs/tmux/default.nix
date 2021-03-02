{ ... }:

{
  programs.tmux = {
    enable = true;

    extraConfig = ''
       # ==========================
       # ===  General settings  ===
       # ==========================

       set  -g default-terminal "tmux-256color"
       set -ag terminal-overrides ",alacritty:RGB"
       # set -g default-terminal "screen-256color"

       set -g history-limit 20000
       set -g buffer-limit 20
       set -sg escape-time 0
       set -g display-time 1500
       set -g remain-on-exit off
       set -g repeat-time 300
       setw -g allow-rename off
       setw -g automatic-rename off
       setw -g aggressive-resize on

       # Change prefix key to C-a, easier to type, same to "screen"
       unbind C-b
       set -g prefix C-a

       # Set parent terminal title to reflect current window in tmux session 
       set -g set-titles on
       set -g set-titles-string "#I:#W"

       # Start index of window/pane with 1, because we're humans, not computers
       set -g base-index 1
       setw -g pane-base-index 1

       # Enable mouse support
       set -g mouse on

       # ==========================
       # ===   Key bindings     ===
       # ==========================

       # Unbind default key bindings, we're going to override
       #unbind "\$" # rename-session
       #unbind ,    # rename-window
       #unbind %    # split-window -h
       #unbind '"'  # split-window
       #unbind }    # swap-pane -D
       #unbind {    # swap-pane -U
       #unbind [    # paste-buffer
       #unbind ]
       #unbind "'"  # select-window
       #unbind n    # next-window
       #unbind p    # previous-window
       #unbind l    # last-window
       #unbind M-n  # next window with alert
       #unbind M-p  # next window with alert
       #unbind o    # focus thru panes
       #unbind &    # kill-window
       #unbind "#"  # list-buffer
       #unbind =    # choose-buffer
       #unbind z    # zoom-pane
       #unbind M-Up  # resize 5 rows up
       #unbind M-Down # resize 5 rows down
       #unbind M-Right # resize 5 rows right
       #unbind M-Left # resize 5 rows left

       # Edit configuration and reload
       bind C-e new-window -n 'tmux.conf' "sh -c '\${
         "EDITOR:-vim"
       } ~/.tmux.conf && tmux source ~/.tmux.conf && tmux display \"Config reloaded\"'"

       # Reload tmux configuration
       bind C-r source-file ~/.tmux.conf \; display "Config reloaded"

       # new window and retain cwd
       bind c new-window -c "#{pane_current_path}"

       # Prompt to rename window right after it's created
       set-hook -g after-new-window 'command-prompt -I "#{window_name}" "rename-window '%%'"'

       # Rename session and window
       bind r command-prompt -I "#{window_name}" "rename-window '%%'"
       bind R command-prompt -I "#{session_name}" "rename-session '%%'"

       # Split panes
       bind | split-window -h -c "#{pane_current_path}"
       bind _ split-window -v -c "#{pane_current_path}"

       # Select pane and windows
       bind -r C-[ previous-window
       bind -r C-] next-window
       bind -r [ select-pane -t :.-
       bind -r ] select-pane -t :.+
       bind -r Tab last-window   # cycle thru MRU tabs
       bind -r C-o swap-pane -D

       # Zoom pane
       bind + resize-pane -Z

       # Link window
       bind L command-prompt -p "Link window from (session:window): " "link-window -s %% -a"

       # Swap panes back and forth with 1st pane
       # When in main-(horizontal|vertical) layouts, the biggest/widest panel is always @1
       bind \ if '[ #{pane_index} -eq 1 ]' \
            'swap-pane -s "!"' \
            'select-pane -t:.1 ; swap-pane -d -t 1 -s "!"'

       # Kill pane/window/session shortcuts
       bind x kill-pane
       bind X kill-window
       bind C-x confirm-before -p "kill other windows? (y/n)" "kill-window -a"
       bind Q confirm-before -p "kill-session #S? (y/n)" kill-session

       # Merge session with another one (e.g. move all windows)
       # If you use adhoc 1-window sessions, and you want to preserve session upon exit
       # but don't want to create a lot of small unnamed 1-window sessions around
       # move all windows from current session to main named one (dev, work, etc)
       bind C-u command-prompt -p "Session to merge with: " \
          "run-shell 'yes | head -n #{session_windows} | xargs -I {} -n 1 tmux movew -t %%'"

       # Detach from session
       bind d detach
       bind D if -F '#{session_many_attached}' \
           'confirm-before -p "Detach other clients? (y/n)" "detach -a"' \
           'display "Session has only 1 client attached"'

       # Hide status bar on demand
       bind C-s if -F '#{s/off//:status}' 'set status off' 'set status on'

       # ==================================================
       # === Window monitoring for activity and silence ===
       # ==================================================
       bind m setw monitor-activity \; display-message 'Monitor window activity [#{?monitor-activity,ON,OFF}]'
       bind M if -F '#{monitor-silence}' \
           'setw monitor-silence 0 ; display-message "Monitor window silence [OFF]"' \
           'command-prompt -p "Monitor silence: interval (s)" "setw monitor-silence %%"'

       # Activity bell and whistles
       set -g visual-activity on

       # TODO: Does not work as well, check on newer versions
       # set -g visual-silence on

       # BUG: bell-action other ignored · Issue #1027 · tmux/tmux · GitHub - https://github.com/tmux/tmux/issues/1027
       # set -g visual-bell on
       # setw -g bell-action other

       # ================================================
       # ===     Copy mode, scroll and clipboard      ===
       # ================================================
       set -g @copy_use_osc52_fallback on

       # Prefer vi style key table
       setw -g mode-keys vi

       bind p paste-buffer
       bind C-p choose-buffer

       # trigger copy mode by
       bind -n M-Up copy-mode

       # Scroll up/down by 1 line, half screen, whole screen
       bind -T copy-mode-vi M-Up              send-keys -X scroll-up
       bind -T copy-mode-vi M-Down            send-keys -X scroll-down
       bind -T copy-mode-vi M-PageUp          send-keys -X halfpage-up
       bind -T copy-mode-vi M-PageDown        send-keys -X halfpage-down
       bind -T copy-mode-vi PageDown          send-keys -X page-down
       bind -T copy-mode-vi PageUp            send-keys -X page-up

       # When scrolling with mouse wheel, number of scrolled rows per tick
       bind -T copy-mode-vi WheelUpPane       select-pane \; send-keys -X -N 5 scroll-up
       bind -T copy-mode-vi WheelDownPane     select-pane \; send-keys -X -N 5 scroll-down

       # wrap default shell in reattach-to-user-namespace if available
       # there is some hack with `exec & reattach`, credits to "https://github.com/gpakosz/.tmux"
       # don't really understand how it works, but at least window are not renamed to "reattach-to-user-namespace"
       if -b "command -v reattach-to-user-namespace > /dev/null 2>&1" \
           "run 'tmux set -g default-command \"exec $(tmux show -gv default-shell) 2>/dev/null & reattach-to-user-namespace -l $(tmux show -gv default-shell)\"'"

       #yank="~/.tmux/yank.sh"

       # Copy selected text
       #bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "$yank"
       #bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "$yank"
       #bind -T copy-mode-vi Y send-keys -X copy-line \;\
           #run "tmux save-buffer - | $yank"
       #bind-key -T copy-mode-vi D send-keys -X copy-end-of-line \;\
           #run "tmux save-buffer - | $yank"
       #bind -T copy-mode-vi C-j send-keys -X copy-pipe-and-cancel "$yank"
       #bind-key -T copy-mode-vi A send-keys -X append-selection-and-cancel \;\
           #run "tmux save-buffer - | $yank"

       # Copy selection on drag end event, but do not cancel copy mode and do not clear selection
       # clear select on subsequence mouse click
       #bind -T copy-mode-vi MouseDragEnd1Pane \
           #send-keys -X copy-pipe "$yank"
       bind -T copy-mode-vi MouseDown1Pane select-pane \;\
          send-keys -X clear-selection

       # iTerm2 works with clipboard out of the box, set-clipboard already set to "external"
       # tmux show-options -g -s set-clipboard
       # set-clipboard on|external

       # =====================================
       # ===           Theme               ===
       # =====================================

       # Feel free to NOT use this variables at all (remove, rename)
       # this are named colors, just for convenience
       color_orange="colour166" # 208, 166
       color_purple="colour134" # 135, 134
       color_green="colour076" # 070
       color_blue="colour39"
       color_yellow="colour220"
       color_red="colour160"
       color_white="white" # 015

       # This is a theme CONTRACT, you are required to define variables below
       # Change values, but not remove/rename variables itself
       color_dark="default"
       color_light="$color_white"
       color_session_text="$color_blue"
       color_status_text="colour245"
       color_main="$color_orange"
       color_secondary="$color_purple"
       color_level_ok="$color_green"
       color_level_warn="$color_yellow"
       color_level_stress="$color_red"
       color_window_off_indicator="colour088"
       color_window_off_status_bg="colour238"
       color_window_off_status_current_bg="colour254"

       # =====================================
       # ===    Appearence and status bar  ===
       # ======================================

       set -g mode-style "fg=default,bg=$color_main"

       # command line style
       set -g message-style "fg=$color_main,bg=$color_dark"

       # status line style
       set -g status-style "fg=$color_status_text,bg=$color_dark"

       # window segments in status line
       set -g window-status-separator ""
       separator_powerline_left=" "
       separator_powerline_right=" "

       # setw -g window-status-style "fg=$color_status_text,bg=$color_dark"
       setw -g window-status-format " #I:#W "
       setw -g window-status-current-style "fg=$color_light,bold,bg=$color_main"
       setw -g window-status-current-format "#[fg=$color_dark,bg=$color_main]$separator_powerline_right#[default] #I:#W# #[fg=$color_main,bg=$color_dark]$separator_powerline_right#[default]"

       # when window has monitoring notification
       setw -g window-status-activity-style "fg=$color_main"

       # outline for active pane
       setw -g pane-active-border-style "fg=$color_main"

       # general status bar settings
       set -g status on
       set -g status-interval 5
       set -g status-position top
       set -g status-justify left
       set -g status-right-length 100

       set -g status-left "$wg_session"

       # Configure tmux-prefix-highlight colors
       set -g @prefix_highlight_output_prefix '['
       set -g @prefix_highlight_output_suffix ']'
       set -g @prefix_highlight_fg "$color_dark"
       set -g @prefix_highlight_bg "$color_secondary"
       set -g @prefix_highlight_show_copy_mode 'on'
       set -g @prefix_highlight_copy_mode_attr "fg=$color_dark,bg=$color_secondary"

       # =====================================
       # ===        Renew environment      ===
       # =====================================
       set -g update-environment \
         "DISPLAY\
         SSH_ASKPASS\
         SSH_AUTH_SOCK\
         SSH_AGENT_PID\
         SSH_CONNECTION\
         SSH_TTY\
         WINDOWID\
         XAUTHORITY"

      set -g status-bg default
             '';
  };

  home.file."bin/tmux-window-name".source = ./window-name.sh;
}
