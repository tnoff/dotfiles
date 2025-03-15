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
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


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

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Custom prompt
PS1='\W\\$ '

# Alias
alias remove-trailing-whitespaces='echo ":%s/\s\+$//" | pbcopy'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
alias purge-pyc='find . -name "*.pyc" -exec rm -rf {} \;'
alias purge-orig='find . -name "*.orig" -exec rm -rf {} \;'
alias list-file-types='find . -type f | perl -ne '"'"'print $1 if m/\.([^.\/]+)$/'"'"' | sort -u'

# Add custom scripts to path
PATH=${PATH}:~/.custom-scripts/
export PATH

# Function envs

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
        virtualenv --python=$(which python3) ~/.envs/$2
        source ~/.envs/$2/bin/activate
        return
    fi
    source ~/.envs/$1/bin/activate
}

function pretty-script()
{
    cat $1 | perl -pe 's/\e([^\[\]]|\[.*?[a-zA-Z]|\].*?\a)//g' | col -b > $1-pretty
}

function docker-reset()
{
    docker stop $(docker ps | awk '!/CONTAINER/ {print $1}')
    docker rm $(docker ps --all | awk '!/CONTAINER/ {print $1}')
    docker image rm $(docker image ls | awk '!/IMAGE/ {print $3}')
    docker volume rm $(docker volume ls | awk '!/VOLUME/ {print $2}')
    docker system prune
}

source ~/.secrets.sh


# Set up venv
export VIRTUAL_ENV_DISABLE_PROMPT=1
envs main

# Call note script
python ~/.custom-scripts/get_note_folder.py

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Tfenv
export PATH="$HOME/.tfenv/bin:$PATH"
