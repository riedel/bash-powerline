#!/bin/bash

GIT_CHECK="/usr/local/bin/git-check"
GIT_INFO="/usr/local/bin/git-info"

# Unicode symbols
PS_DELIM=''

# Colorscheme
FG_LRED="\[$(tput setaf 9)\]"
FG_LGRN="\[$(tput setaf 10)\]"
FG_LBLU="\[$(tput setaf 12)\]"
FG_WHITE="\[$(tput setaf 15)\]"

BG_LRED="\[$(tput setab 9)\]"
BG_LGRN="\[$(tput setab 10)\]"
BG_LBLU="\[$(tput setab 12)\]"
BG_WHITE="\[$(tput setab 15)\]"

RESET="\[$(tput sgr0)\]"
BOLD="\[$(tput bold)\]"

PS1=""

if [[ ${EUID} == 0 ]]
then
  PS1+="${BG_LRED}${FG_WHITE}${BOLD}\h${RESET}${FG_LRED}${BG_WHITE}${PS_DELIM}${RESET}"
else
  PS1+="${BG_LGRN}${FG_WHITE}${BOLD}\h${RESET}${FG_LGRN}${BG_WHITE}${PS_DELIM}${RESET}"
fi

PS1+="${BG_WHITE}${FG_LBLU} \w ${RESET}"

PS1+="\$(RET=\$?; if \$(/usr/local/bin/git-check); then echo -n \"${FG_WHITE}${BG_LBLU}${PS_DELIM}${FG_WHITE}${BG_LBLU} \$(/usr/local/bin/git-info) ${RESET}${FG_LBLU}${PS_DELIM}${RESET} \"; else echo -n \"${RESET}${FG_WHITE}${PS_DELIM}${RESET} \"; fi; if [[ \${RET} == 0 ]]; then echo -n \"${FG_LBLU}\";else echo -n \"${FG_LRED}\"; fi)"

if [[ ${EUID} == 0 ]]
then
  PS1+="#"
else
  PS1+="$"
fi

PS1+="${RESET} "

unset GIT_CHECK GIT_INFO PS_DELIM 
unset FG_LRED FG_LGRN FG_LBLU FG_WHITE
unset BG_LRED BG_LGRN BG_LBLU BG_WHITE
unset RESET BOLD 
