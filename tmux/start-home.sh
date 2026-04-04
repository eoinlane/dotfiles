#!/bin/bash
# Start the "home" tmux session with claude + two shell panes
# Layout: left side split top/bottom (shells), right side (claude)

SESSION="home"
DIR="$HOME/Documents/home"

# Attach if already running
if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux attach -t "$SESSION"
    exit 0
fi

# Create session with first pane (top-left shell)
tmux new-session -d -s "$SESSION" -c "$DIR"

# Split horizontally: left shell (40%) | right claude (60%)
tmux split-window -h -t "$SESSION:1" -c "$DIR" -l 60%

# Split the left pane vertically: top-left shell / bottom-left shell
tmux split-window -v -t "$SESSION:1.0" -c "$DIR"

# Start claude in the right pane (pane 2 after splits)
tmux send-keys -t "$SESSION:1.2" 'claude' Enter

# Focus the claude pane
tmux select-pane -t "$SESSION:1.2"

# Attach
tmux attach -t "$SESSION"
