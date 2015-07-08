#!/usr/bin/env bash

GIT_CHECK="/usr/local/bin/git-check"
GIT_INFO="/usr/local/bin/git-info"

# Unicode symbols
PS_DELIM=''

# Colorscheme
FG_00="\[$(tput setaf 0)\]"  # black
FG_08="\[$(tput setaf 8)\]"  # gray
FG_01="\[$(tput setaf 1)\]"  # red
FG_09="\[$(tput setaf 9)\]"  # light red
FG_02="\[$(tput setaf 2)\]"  # green
FG_10="\[$(tput setaf 10)\]" # light green
FG_03="\[$(tput setaf 3)\]"  # orange
FG_11="\[$(tput setaf 11)\]" # yellow
FG_04="\[$(tput setaf 4)\]"  # blue
FG_12="\[$(tput setaf 12)\]" # light blue
FG_05="\[$(tput setaf 5)\]"  # purple
FG_13="\[$(tput setaf 13)\]" # light purple
FG_06="\[$(tput setaf 6)\]"  # aqua
FG_14="\[$(tput setaf 14)\]" # cyan
FG_07="\[$(tput setaf 7)\]"  # selection
FG_15="\[$(tput setaf 15)\]" # current line

BG_00="\[$(tput setab 0)\]"  # black
BG_08="\[$(tput setab 8)\]"  # gray
BG_01="\[$(tput setab 1)\]"  # red
BG_09="\[$(tput setab 9)\]"  # light red
BG_02="\[$(tput setab 2)\]"  # green
BG_10="\[$(tput setab 10)\]" # light green
BG_03="\[$(tput setab 3)\]"  # orange
BG_11="\[$(tput setab 11)\]" # yellow
BG_04="\[$(tput setab 4)\]"  # blue
BG_12="\[$(tput setab 12)\]" # light blue
BG_05="\[$(tput setab 5)\]"  # purple
BG_13="\[$(tput setab 13)\]" # light purple
BG_06="\[$(tput setab 6)\]"  # aqua
BG_14="\[$(tput setab 14)\]" # cyan
BG_07="\[$(tput setab 7)\]"  # selection
BG_15="\[$(tput setab 15)\]" # current line

DIM="\[$(tput dim)\]"
REVERSE="\[$(tput rev)\]"
RESET="\[$(tput sgr0)\]"
BOLD="\[$(tput bold)\]"

PS1=""

if [[ ${EUID} == 0 ]]
then
  PS1+="${BG_09}${FG_15}${BOLD}\h${RESET}${FG_09}${BG_15}${PS_DELIM}${RESET}"
else
  PS1+="${BG_10}${FG_15}${BOLD}\h${RESET}${FG_10}${BG_15}${PS_DELIM}${RESET}"
fi

PS1+="${BG_15}${FG_12} \w ${RESET}"

PS1+="\$(if \$(/usr/local/bin/git-check); then echo \"${FG_15}${BG_12}${PS_DELIM}${FG_15}${BG_12} \$(/usr/local/bin/git-info) ${RESET}${FG_12}${PS_DELIM}${RESET}\"; else echo \"${RESET}${FG_15}${PS_DELIM}${RESET}\"; fi)"

PS1+=" \$(if [[ \$? == 0 ]]; then echo \"${FG_12}\"; else echo \"${FG_09}\"; fi)\$${RESET} "

unset GIT_CHECK GIT_INFO PS_DELIM 
unset FG_01 FG_02 FG_03 FG_04 FG_05 FG_06 FG_07 FG_08 FG_09 FG_10 FG_11 FG_12 FG_13 FG_14 FG_15
unset BG_01 BG_02 BG_03 BG_04 BG_05 BG_06 BG_07 BG_08 BG_09 BG_10 BG_11 BG_12 BG_13 BG_14 BG_15
unset DIM REVERSE RESET BOLD EXIT GIT_INFO
