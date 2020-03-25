
#default editor is vim, also for fixcommand
export EDITOR=/usr/local/bin/vim
export FCEDIT=/usr/local/bin/vim
export PGHOST=localhost

# INCREASE history length, ERASE duplicates, and PRESERVE history after exiting shell
export HISTCONTROL=ignoredups:erasedups # no dupes
export HISTSIZE=20000 # lots of history
export HISTFILESIZE=20000 # lots of history
export HISTFILE="$HOME/dotfiles/dotfiles/.bash_history"

shopt -s histappend # append to history, don't overwrite
shopt -s histverify # don't immediately execute history shortcuts (because i should check them before submitting)

# Get the rest of my stuff
source $HOME/.config/bash/bash_prompt.sh
source $HOME/.config/bash/aliases.sh
source $HOME/.bashrc

# Start tmux if not in iTerm
if command -v tmux &> /dev/null && \
  [ -n "$PS1" ] && \
  [[ ! "$TERM" =~ screen ]] && \
  [[ ! "$TERM" =~ tmux ]] && \
  [ -z "$ITERM_SESSION_ID" ] && \
  [ -z "$TMUX" ]; then
    tmux
fi

