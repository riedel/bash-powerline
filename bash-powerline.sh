#!/bin/bash

GIT_CHECK="/usr/local/bin/git-check"
GIT_INFO="/usr/local/bin/git-info"
PWDS="/usr/local/bin/pwds"

PWD_LENGTH=25

PS_DELIM=''

FG_LRED='\[\e[91m\]'
FG_GRN='\[\e[32m\]'
FG_LBLU='\[\e[94m\]'
FG_WHT='\[\e[97m\]'

BG_LRED='\[\e[101m\]'
BG_GRN='\[\e[42m\]'
BG_LBLU='\[\e[104m\]'
BG_WHT='\[\e[107m\]'

RESET='\[\e[0m\]'
INVERT='\[\e[7m\]'
BOLD='\[\e[1m\]'

PS1=""

if [[ ${EUID} == 0 ]]
then
  PS1+="${BG_LRED}${FG_WHT}\h${BG_WHT}${FG_LRED}${PS_DELIM}"
else
  PS1+="${BG_GRN}${FG_WHT}\h${BG_WHT}${FG_GRN}${PS_DELIM}"
fi

PS1+="\$(RET=\$?; echo -n \"${BG_WHT}${FG_LBLU} \$(${PWDS} \"\${PWD}\" ${PWD_LENGTH}) ${RESET}\" ; if \$(/usr/local/bin/git-check); then echo -n \"${FG_WHT}${BG_LBLU}${PS_DELIM}${FG_WHT}${BG_LBLU} \$(/usr/local/bin/git-info) ${RESET}${FG_LBLU}${PS_DELIM}${RESET} \"; else echo -n \"${RESET}${FG_WHT}${PS_DELIM}${RESET} \"; fi; if [[ \${RET} == 0 ]]; then echo -n \"${FG_LBLU}\";else echo -n \"${FG_LRED}\"; fi)"

if [[ ${EUID} == 0 ]]
then
  PS1+="#"
else
  PS1+="$"
fi

PS1+="${RESET} "

unset GIT_CHECK GIT_INFO PS_DELIM 
unset FG_LRED FG_GRN FG_LBLU FG_WHT FG_BWHT
unset BG_LRED BG_GRN BG_LBLU BG_WHT
unset RESET 
