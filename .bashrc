# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
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

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -lh'

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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#Mah edits >:D
#-------------------
#Make prompt all nice
export PS1="\[\e[00;30m\]\W>\[\e[0m\]"

alias gtfo='sudo poweroff'
alias fuck-trailing-whitespaces='echo ":%s/\s\+$//" | pbcopy'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
alias purge-pyc='find . -name "*.pyc" -exec rm -rf {} \;'
alias purge-orig='find . -name "*.orig" -exec rm -rf {} \;'
alias list-file-types='find . -type f | perl -ne '"'"'print $1 if m/\.([^.\/]+)$/'"'"' | sort -u'

#Add custom scripts
PATH=${PATH}:~/.custom-scripts/
export PATH

function envs()
{
    if [ -z "$1" ]; then
        echo "Please input an enviroment name; Press ls to see all available"
        return
    fi
    if [ "$1" == "ls" ]; then
        ls ~/.envs
        return
    fi
    if [ "$1" == "rm" ]; then
        if [ -z "$2" ]; then
            echo "Please input an environment name to delete"
            return
        fi
        rm -rf ~/.envs/$2
        return
    fi
    if [ "$1" == "create" ]; then
        if [ -z "$2" ]; then
            echo "Please input an environment name to create"
            return
        fi
        virtualenv --no-site-packages ~/.envs/$2
        source ~/.envs/$2/bin/activate
        return
    fi
    source ~/.envs/$1/bin/activate
}
function watch-me()
{
    datetime=$(date -u | sed 's/ /-/g' )
    script $1.$datetime
}
function pretty-script()
{
    cat $1 | perl -pe 's/\e([^\[\]]|\[.*?[a-zA-Z]|\].*?\a)//g' | col -b > $1-pretty
}

function shrink-video()
{
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Need two arguments, input and output files"
    fi
    avconv -i "$1" -vcodec libx264 -acodec libmp3lame -ac 2 "$2"
}


# no stupid tab sound
# also needs change to /etc/inputrc http://www.cyberciti.biz/faq/how-to-linux-disable-or-turn-off-beep-sound-for-terminal/
if [ -n "$DISPLAY" ]; then
      xset b off
fi
