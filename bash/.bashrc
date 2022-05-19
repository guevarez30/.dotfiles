export PATH="$PATH:~/scripts";

###################################################################################
# PS1
###################################################################################
source ~/.git-prompt.sh

WHITE="\033[00m"
YELLOW="\e[00;33m"
CYAN="\e[01;36m"
PINK="\e[91m"
PURPLE="\e[00;34m"

update_PS1(){
  PS1="${PINK}┏ "
  PS1+="${PURPLE}\T "                  # Yellow Time
  PS1+="${CYAN}\w "                    # Cyan Directory
  PS1+="${PINK}$(__git_ps1 " (%s)")"
  PS1+="\n"
  PS1+="${PINK}┗ "
  PS1+="${PURPLE}$ ${WHITE}"                  # Promt on new white line
  PS1=$'\n'"$PS1"
}

PROMPT_COMMAND=update_PS1
# Export Path login 
PATHLOGIN=${PATH}
export PATHLOGIN

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
alias src='source ~/.bashrc'
alias vim='nvim-qt'
alias n='nodemon '
alias Downloads='cd ~/Downloads'
alias downloads='Downloads'
alias cat='bat'
alias dot='cd ~/.dotfiles'
alias push='g push'
alias pull='g pull'
alias branch='g branch'
alias status='g status'
alias jsonToCsv='jsonToCSV'

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





