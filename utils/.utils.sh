#!/bin/bash

# general
alias ..='cd ..'
alias ll='ls -lFa'
alias gbp='git push --set-upstream origin `git branch --show-current`'
alias gbpf='git push --set-upstream origin `git branch --show-current` --force'
alias dsa='docker stop $(docker ps -q)'
alias usedPorts='netstat -ltnp'
alias reload="source ~/.bashrc"


# terminal copy/paste
alias pbcopy="xclip -sel clip"
alias pbpaste='xclip -selection clipboard -o'

# copy generated uuuid
uuid() {
	# a=$(uuidgen)
	a="$(< /proc/sys/kernel/random/uuid)"
	echo -n "$a" | pbcopy
	echo -e "copied\t$a"
}

# copy current unixtimestamp
dt() {
	a="$(date +%s%3N)"
	echo -n "$a" | pbcopy
	echo -e "copied\t$a"
}

# terminal time counter
timecount() {
	start=$(date +%s)
	while true; do
	    time="$(($(date +%s) - $start))"
	    printf ' %s     \r'"$(date -u -d "@$time" +%H:%M:%S)"
	done
}

# brightness, br 0>1
br() {
	xrandr --query | grep ' connected' | awk $'{print $1}'| while read -r SCREEN ; do
		xrandr --output $SCREEN --brightness $1
	done
}

# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

#################
###### GIT ######
#################

_declare() {
	export GITHUB_ACTOR="foo" GITHUB_TOKEN="bar"
}

_declare

# return git branch
parse_git_branch() {
	git branch 2> /dev/null | sed '/^[^*]/d' | sed 's/* \(.*\)/ \1/'
}

# copy in clipboard the current branch name, need xclip
cb() {
	local BRANCH=$(parse_git_branch)
	local RED='\e[31m'
	local NC='\e[0m'

	if [[ ${#BRANCH} -gt 1 ]];  then
		echo -n "$BRANCH" | pbcopy
		echo -e "copied branch: ${RED}$(pbpaste)${NC}"
	else
		echo -e "${RED}branch not found${FC}"
	fi
}

# rebase interactive [number of last commits]
rebase() {
	local COMMITS=2
	if [[ $(($1)) -gt 2 ]] ; then
		COMMITS="$1"
	fi
	git rebase -i "HEAD~${COMMITS}"
}


#################
###### NPM ######
#################


# Verdaccio use
#export VERDACCIO=--registry=http://localhost:4873


# remove node_modules, install by package.json
npmri() {
	local RED='\033[0;31m'
	local NC='\033[0m'
	local _F='package.json'
	local _D='node_modules'

	local DIR="`pwd`/${_D}"
	if [ -d "$DIR" ]; then
		rm -rf "$DIR"
	else
		echo -e "${_D} ${RED}does not exist.${NC}" > /dev/stderr
	fi

	local FILE="`pwd`/${_F}"
	if [ -f "$FILE" ]; then
		if [ $1 == 'c' ]; then
			npm ci
		else
			npm i
		fi
	else 
		echo -e "${_F} ${RED}does not exist.${NC}" > /dev/stderr
	fi
}

# remove node_modules, install by lock
alias npmrci='npmri c'