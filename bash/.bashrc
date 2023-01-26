alias src='source ~/.bashrc'
export PATH="$PATH:~/scripts";

###################################################################################
# PS1
###################################################################################
source ~/.git-prompt.sh

RED="\[\e[0;31m\]"
GREEN="\[\e[0;32m\]"
YELLOW="\[\e[0;33m\]"
BLUE="\[\e[0;34m\]"
PURPLE="\[\e[0;35m\]"
CYAN="\[\e[0;36m\]"
WHITE="\[\e[0;37m\]"

update_PS1(){
  PS1=""
  PS1+="${GREEN}\T"
  PS1+=" ${BLUE}\W"
  PS1+=" ${RED}$(__git_ps1 " %s")"
  PS1+="\n"
  PS1+="${YELLOW}"
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


#####################################################################################
#Aliases
#####################################################################################
#Protects from copying or renaming a file to a place where it already exist
alias ls='lsd'
alias vim='nvim'
alias mv='mv -i'
alias clc='clear'
alias cls='clear'
alias clera='clear'
alias ckear='clear'
alias got='git'
alias ipconfig='ifconfig'
alias ll='ls -la'
alias Downloads='cd ~/Downloads'
alias downloads='Downloads'
alias cat='bat'
alias dot='cd ~/.dotfiles'
alias find="fd"
alias settings="gnome-control-center"
alias lg='lazygit'
alias luaG='cd ~/.dotfiles/nvim/.config/nvim/lua/guevarez' 
alias luag='luaG' 
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
