export PATH="$PATH:~/scripts";

# Show only directory on terminal line
            # Yellow time     \cyan direcotry \ White $ on new line
export PS1="\n\[\e[00;33m\]\t \[\e[01;36m\]\w  \[\033[00m\] \n$ "

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

taylorGIT(){
	git config user.email guevarez30@gmail.com
	git config user.name 'Taylor Guevarez'
	#git config --list --local
}

newBranch(){
	echo Checking out $@
	git fetch origin
	git checkout -b"$@" "origin/$@"
  src
}

checkout(){
  git checkout $@
  src
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
# alias nvim-qt='/usr/bin/nvim-qt'
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
alias ebash='g ~/.bashrc'
alias vim='nvim'
alias n='nodemon '
alias gomon='nodemon --exec go run'
alias c='code .'
alias Downloads='cd ~/Downloads'
alias downloads='Downloads'
alias cat='bat'
alias nvim='nvim-qt'
alias e='nvim-qt'
alias eVim='e ~/.config/nvim/init.vim' 
alias evim='eVim'
alias ebash='e ~/.bashrc'
alias eBash='ebash'
alias dot='cd ~/.dotfiles'
#####################################################################################
#Python
#####################################################################################
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


source ~/.mapwarerc
