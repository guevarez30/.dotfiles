# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -Uz compinit
compinit

###################################################################################
# NVM
###################################################################################
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Source plugins
source ~/.zsh_plugins.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Export Path login 
PATHLOGIN=${PATH}
export PATHLOGIN

#Protects from copying or renaming a file to a place where it already exist
alias mv='mv -i'

###################################################################################
# Functions
###################################################################################
killport() {
	fuser -k $@/tcp
}
alias killPort='killport';

term() { printf "\033]0;$*\007"; }

aerialGIT(){
	git config user.email taylor.guevarez@aerialapplications.com
	git config user.name 'Taylor Guevarez'
}

taylorGIT(){
	git config user.email guevarez30@gmail.com
	git config user.name 'Taylor Guevarez'
}

newBranch(){
	echo Checking out $@
	git fetch origin
	git checkout -b"$@" "origin/$@"
}

count(){
	ls $@ -1 | wc -l
}

e(){
	gnvim $@ & disown 
}

#####################################################################################
#Aliases
#####################################################################################
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
alias n='nodemon '
alias gomon='nodemon --exec go run'
alias c='code .'
alias Downloads='cd ~/Downloads'
alias downloads='Downloads'
alias eVim='nvim ~/.config/nvim/init.vim' 
alias evim='eVim'
alias cat='bat'
alias eRC='nvim ~/.zshrc'
alias erc='eRC'
alias src='source ~/.zshrc'

#####################################################################################
#Python
#####################################################################################
alias pip='pip3'
alias py3='nodemon --exec python3'
alias py2='nodemon --exec python2'
alias py='py3'

#####################################################################################
#Include Scripts to Path and Custom Functions
#####################################################################################
export PATH="$PATH:~/scripts";
export PATH="$PATH:/usr/local/go/src"
export PATH="$PATH:/usr/local/Goneovim"

#####################################################################################
# Custom Services
#####################################################################################
alias statusMariadb='sudo systemctl status mariadb'
alias startMariadb='sudo systemctl start mariadb; statusMariadb'
alias stopMariadb='sudo systemctl stop mariadb; statusMariadb'
alias statusMongo='sudo systemctl status mongod'
alias startMongo='sudo systemctl start mongod; statusMongo'
alias stopMongo='sudo systemctl stop mongod; statusMongo'
alias statusSSH='sudo systemctl status sshd'
alias startSSH='sudo systemctl start sshd; statusSSH'
alias stopSSH='sudo systemctl stop sshd; statusSSH'

# Setting for the new UTF-8 terminal support in Lion
export LC_ALL=C
#####################################################################################
# Local Machine RC Files
#####################################################################################
source ~/.mapwarerc
