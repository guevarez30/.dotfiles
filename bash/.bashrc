alias src='source ~/.bashrc'
export PATH="$PATH:~/scripts";

###################################################################################
# PS1
###################################################################################
source ~/.git-prompt.sh

PINK="\[\e[91m\]"
GREEN="\[\e[92m\]"
PURPLE="\[\e[00;34m\]"
CYAN="\[\e[01;36m\]"
WHITE="\[\033[00m\]"

update_PS1(){
  PS1=""
  PS1+="${PURPLE}\T"
  PS1+=" ${CYAN}\W"
  PS1+=" ${PINK}$(__git_ps1 " %s")"
  PS1+="\n"
  PS1+="${GREEN}"
  PS1+=" ${WHITE}"
  PS1=$"\n""$PS1"
}

PROMPT_COMMAND=update_PS1

###################################################################################
# Functions
###################################################################################
killport() {
	fuser -k $@/tcp
}

alias killPort='killport';

term() { printf "\033]0;$*\007"; }

taylorGIT(){
	git config user.email guevarez30@gmail.com
	git config user.name 'Taylor Guevarez'
}

count(){
	ls $@ -1 | wc -l
}

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#####################################################################################
#Aliases
#####################################################################################
#Protects from copying or renaming a file to a place where it already exist
alias mv='mv -i'
alias clc='clear'
alias cls='clear'
alias clera='clear'
alias ckear='clear'
alias got='git'
alias ipconfig='ifconfig'
alias ll='ls -la'
alias dc='cd'
alias killscreens="screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill"
alias vim='nvim'
alias v='vim'
alias n='nodemon '
alias Downloads='cd ~/Downloads'
alias downloads='Downloads'
alias cat='bat'
alias dot='cd ~/.dotfiles'
alias find="fd"
alias settings="gnome-control-center"
alias lg='lazygit'
alias luaG='cd ~/.dotfiles/nvim/.config/nvim/lua/guevarez' 
alias luag='luaG' 
alias logger='docker run --detach --volume=/var/run/docker.sock:/var/run/docker.sock -p 8082:8080 amir20/dozzle'
#####################################################################################
#RUST
#####################################################################################
. "$HOME/.cargo/env"

#####################################################################################
#Python
#####################################################################################
alias python='python3'
alias pip='pip3'
alias py3='nodemon --exec python3'
alias py2='nodemon --exec python2'
alias py='py3'
alias g='git'

#####################################################################################
#Include Scripts to Path and Custom Functions
#####################################################################################
export PATH="$PATH:~/scripts";
export PATH="$PATH:/usr/local/go/src"

#####################################################################################
# Node Version Manager
#####################################################################################
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#####################################################################################
# Go
#####################################################################################
export PATH="$PATH:/usr/local/go/bin";

#####################################################################################
# Notes
#####################################################################################
note () {
  term Notes $(date '+%Y-%m-%d')
  \nvim ~/notes/$(date '+%Y-%m-%d').md
}

alias notes='note'

#####################################################################################
# Local .rc file
#####################################################################################
source ~/.localrc
