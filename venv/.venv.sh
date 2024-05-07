#!/bin/bash

venv() {
	local RED='\e[31m'
	local GREEN='\e[32m'
	local NC='\e[0m'
	local GIVEATRY="${GREEN}venv help ${NC}"

	venv_dir(){
		local _D1='venv'
		local _D2='.venv'
		if [ -d "${PWD}/${_D1}" ]; then
			echo $_D1
		elif [ -d "${PWD}/${_D2}" ]; then
			echo $_D2
		fi
	}

	if ([ $# -eq 0 ] || ([ $# -eq 1 ] && [ $1 == "help" ])) ; then
		echo -e "\tinit    - call venv molude to create virtual environment as .venv"
		echo -e "\tinstall - install libs from requirements.txt"
		echo -e "\tsave    - save requirements to requirements.txt"
		echo -e "\tin      - load virtual environment from [ .venv || venv ]"
		echo -e "\tout     - deactivate virtual environment"
		echo -e "\thelp    - venv function description"
		echo -e "\tremove  - revome venv directory"
	elif ([ $# -eq 1 ] && [ $1 == "remove" ]) ; then
		local DIR=$(venv_dir)
		if [[ ${#DIR} -gt 3 ]]; then
			rm -rf "$DIR"
			echo -e "removed ${GREEN}${DIR} ${NC}" > /dev/stderr
		else
			echo -e "${RED} venv directory not found${NC}" > /dev/stderr
		fi
	elif ([ $# -eq 1 ] && [ $1 == "init" ]) ; then
		python -m venv .venv
	elif ([ $# -eq 2 ] && [ $1 == "init" ]) ; then
		eval "python${2} -m venv .venv"
		# python -m venv .venv
	elif ([ $# -eq 1 ] && [ $1 == "save" ]) ; then
		pip freeze > requirements.txt
	elif ([ $# -eq 1 ] && [ $1 == "install" ]) ; then
		local _F='requirements.txt'
		local FILE="`pwd`/${_F}"
		if [ -f "$FILE" ]; then
			pip install -r requirements.txt
		else 
			echo -e "${_F} ${RED}does not exist.${NC}" > /dev/stderr
		fi
	elif ([ $# -eq 1 ] && [ $1 == "in" ]) ; then
		local DIR=$(venv_dir)
		if [[ ${#DIR} -gt 3 ]]; then
			echo -e "found ${GREEN}${DIR} ${NC} > activate" > /dev/stderr
			source "${PWD}/${DIR}/bin/activate"
		else
			echo -e "venv directory ${RED}does not exist.${NC}" > /dev/stderr
		fi
	elif ([ $# -eq 1 ] && [ $1 == "out" ]) ; then
		deactivate
	else
		echo -e "${RED}venv $1 command not exist${NC} try: ${GIVEATRY}" > /dev/stderr
	fi
}
