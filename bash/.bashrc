# ---------- UBUNTU DEFAULT BASHRC ----------

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
HISTSIZE=1000
HISTFILESIZE=2000

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

# ---------- Not necessary, own prompt ----------
# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi
# unset color_prompt force_color_prompt
#
# # If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


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

# ---------- BASHRC LOCAL ----------
# You may want to put all your custom configuration into a separate file like
# ~/.bashrc_local, instead of adding them here directly.

if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi

# ---------- My Prompt PS1 ---------- 
PROMPT_LONG=40

__ps1() {

  local P='$' # Prompt

  # ANSI Escape colors
  # Black       0;30     Dark Gray     1;30
  # Blue        0;34     Light Blue    1;34
  # Green       0;32     Light Green   1;32
  # Cyan        0;36     Light Cyan    1;36
  # Red         0;31     Light Red     1;31
  # Purple      0;35     Light Purple  1;35
  # Brown       0;33     Yellow        1;33
  # Light Gray  0;37     White         1;37
  #                      Following text needs to be reseted

  local r='\[\e[31m\]'    # root color
  local g='\[\e[30m\]'    # graphics color
  local h='\[\e[34m\]'    # hostname color
  local u='\[\e[33m\]'    # username color
  local p='\[\e[33m\]'    # prompt color
  local w='\[\e[32m\]'    # workpath color
  local b='\[\e[36m\]'    # git branch color
  local x='\[\e[0m\]'     # reset color

  local dir;
  local B=$(git branch --show-current 2>/dev/null)


  if [ $EUID -eq 0 ]; then
    P='#'
    u=$r
    p=$u
  fi

  if [ "${PWD}" = "$HOME" ]; then
    dir='~'
  else
    dir="${PWD}"
  fi

  local countme="$USER@$(hostname):$dir($B)\$ "

  if [ $B ]; then
    B="$g ($b$B$g)"
  fi

  local short="$u\u$x$g@$h\h$g:$w$dir$B$p$P$x "
  local long="$g╔ $u\u$x$g@$h\h$g:$w$dir$B\n$g╚ $p$P$x "
  local double="$g╔ $u\u$x$g@$h\h$g:$w$dir\n$g║ $B\n$g╚ $p$P$x "


  if [ "${#countme}" -gt "${PROMPT_LONG}" ]; then
    PS1="$long"
  else
    PS1="$short"
  fi

}

PROMPT_COMMAND="__ps1"

# ---------- ENV ----------
export REPOS="${HOME}/repos"
export UTILS="${REPOS}/utils/utils"

# ---------- PATH ----------
PATH="${UTILS}:${PATH}"


# ---------- ALIASES ----------
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
