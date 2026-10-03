# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

PS1='\u@\h:\w\$ '

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -e ~/.bash_functions ]; then
  . ~/.bash_functions
fi

# normalize_path defined in .bash_functions (fixes windows path, no-op on unix)
command -v >/dev/null 2>&1 normalize_path && export PATH=$(normalize_path "$PATH")

export PATH="$HOME/.local/bin:$PATH"

if command -v >/dev/null 2>&1 configure-ssh-pubkey; then
    configure-ssh-pubkey
fi

for bashrc_module in ~/.bashrc.*; do
    if [ -f "$bashrc_module" ]; then
	. $bashrc_module
    fi
done

for complete_script in .bash_completion_*; do
    [ -f "$complete_script" ] && . $complete_script
done

# makefile target completion
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make

command -v >/dev/null 2>&1 vim && export VISUAL=$(command -v vim)
export PAGER='less -QR'
export GIT_PAGER=$PAGER
export COLORTERM=truecolor

# set block cursor
echo -e '\e[1 q'
