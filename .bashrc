# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

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
HISTSIZE=20000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

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

export PATH=/usr/local/mpi/bin:/usr/include/python3.6m/:/usr/local/cuda-10.1/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/mpi/lib:/usr/local/cuda-10.1/lib64:$LD_LIBRARY_PATH
export TF_CPP_MIN_LOG_LEVEL=2

alias xdg-open="xdg-open 2> /dev/null 1> /dev/null"
alias ipython=ipython3
alias jnb='jupyter notebook --no-browser'
alias docker='sudo docker'
alias docker-cur='sudo docker ps -a -q'
alias clear='clear; echo -e "$GREETING"'
alias map_csl425="ssh -N -f -L localhost:8888:localhost:8888 abalak8@csl-425-05.csl.illinois.edu"
# bc i am a cheater
alias sudo='sudo '
# typos
alias co=cp
alias 'cd..'='cd ..'
alias 'code.'='code .'
alias sudp=sudo
alias sudu=sudo
alias gut=git
alias got=git

# night/daylight redshift aliases
alias night="redshift -P -O 1500 >/dev/null 2>&1"
alias day="redshift -P -O 6000 >/dev/null 2>&1"

repo_status()
{
    ret=$?
    status="$(tput setaf 5){$ret}"
    prompt=""
    if [ -d .git ]; then
        prompt="$(tput setaf 2)$(__git_ps1 ' (%s')"
        if [[ `git status --porcelain 2> /dev/null` ]]; then
            prompt="$prompt $(tput setaf 1)*%$(tput setaf 2))"
        else
            prompt="$prompt)"
        fi
    fi
    echo "$prompt $status"
}

# special fix for garbageOS
# > dont have __git_ps1 in 2020
# > dont have autocd
if [ $(uname) != "Linux" ]; then
    source ~/.bash_git
else
    shopt -s autocd
fi

export PS1="\[$(tput bold)$(tput setaf 1)\]~\@~ \[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 6)\]\h \[$(tput sgr0)$(tput bold)\][\W]\$(repo_status)\n\[$(tput setaf 1)\]└─ \\$ \[$(tput sgr0)\$(tput bold)\]"

export PS2="\[$(tput bold)$(tput setaf 1)\]└── $\[(tput sgr0)\$(tput bold)\]"

export GREETING="$(tput sgr0)$(tput setaf 6)Welcome back, $(tput setaf 1)$USER!\n$(tput setaf 6)Right now is $(tput setaf 3)$(date)$(tput sgr0).
"
echo -e $GREETING

bind 'set show-all-if-ambiguous off'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind 'TAB:menu-complete'

# bind 'set editing-mode vim'
# bind 'set vi-ins-mode-string \1\e[6 q\2'
# bind 'set vi-cmd-mode-string \1\e[2 q\2'
# bind '"\e[1;5D": backward-word'
# bind '"\e[1;5C": forward-word'

export EDITOR='code --wait'

# add default transparancy in st
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    transset -a 0.95 > /dev/null 2>&1
else
    transset -a 0.80 > /dev/null 2>&1
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
