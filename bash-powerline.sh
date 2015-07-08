#!/usr/bin/env bash

#set -x
__powerline() {
  # Unicode symbols
  readonly PS_SYMBOL_USER='$'
  readonly PS_SYMBOL_ROOT='#'

  readonly PS_DELIM=''
  readonly PS_DELIM_THIN=''

  readonly GIT_BRANCH_SYMBOL=' '
  readonly GIT_BRANCH_CHANGED_SYMBOL='±'
  readonly GIT_NEED_PUSH_SYMBOL='⇡'
  readonly GIT_NEED_PULL_SYMBOL='⇣'
  
  # Colorscheme
 
  readonly FG_00="\[$(tput setaf 0)\]"  # black
  readonly FG_08="\[$(tput setaf 8)\]"  # gray
  readonly FG_01="\[$(tput setaf 1)\]"  # red
  readonly FG_09="\[$(tput setaf 9)\]"  # light red
  readonly FG_02="\[$(tput setaf 2)\]"  # green
  readonly FG_10="\[$(tput setaf 10)\]" # light green
  readonly FG_03="\[$(tput setaf 3)\]"  # orange
  readonly FG_11="\[$(tput setaf 11)\]" # yellow
  readonly FG_04="\[$(tput setaf 4)\]"  # blue
  readonly FG_12="\[$(tput setaf 12)\]" # light blue
  readonly FG_05="\[$(tput setaf 5)\]"  # purple
  readonly FG_13="\[$(tput setaf 13)\]" # light purple
  readonly FG_06="\[$(tput setaf 6)\]"  # aqua
  readonly FG_14="\[$(tput setaf 14)\]" # cyan
  readonly FG_07="\[$(tput setaf 7)\]"  # selection
  readonly FG_15="\[$(tput setaf 15)\]" # current line

  readonly BG_00="\[$(tput setab 0)\]"  # black
  readonly BG_08="\[$(tput setab 8)\]"  # gray
  readonly BG_01="\[$(tput setab 1)\]"  # red
  readonly BG_09="\[$(tput setab 9)\]"  # light red
  readonly BG_02="\[$(tput setab 2)\]"  # green
  readonly BG_10="\[$(tput setab 10)\]" # light green
  readonly BG_03="\[$(tput setab 3)\]"  # orange
  readonly BG_11="\[$(tput setab 11)\]" # yellow
  readonly BG_04="\[$(tput setab 4)\]"  # blue
  readonly BG_12="\[$(tput setab 12)\]" # light blue
  readonly BG_05="\[$(tput setab 5)\]"  # purple
  readonly BG_13="\[$(tput setab 13)\]" # light purple
  readonly BG_06="\[$(tput setab 6)\]"  # aqua
  readonly BG_14="\[$(tput setab 14)\]" # cyan
  readonly BG_07="\[$(tput setab 7)\]"  # selection
  readonly BG_15="\[$(tput setab 15)\]" # current line

  readonly DIM="\[$(tput dim)\]"
  readonly REVERSE="\[$(tput rev)\]"
  readonly RESET="\[$(tput sgr0)\]"
  readonly BOLD="\[$(tput bold)\]"
  
  if [[ ${EUID} == 0 ]]; then
    readonly PS_SYMBOL=${PS_SYMBOL_ROOT}
  else
    readonly PS_SYMBOL=${PS_SYMBOL_USER}
  fi
  
  __git_info() {
    [ -x "$(which git)" ] || return    # git not found
 
    [ -d "${PWD}/.git" ] || return

    # get current branch name or short SHA1 hash for detached head
    local branch="$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)"
    [ -n "$branch" ] || return  # git branch not found
  
    local marks
  
    # branch is modified?
    [ -n "$(git status --porcelain)" ] && marks+=" $GIT_BRANCH_CHANGED_SYMBOL"
  
    # how many commits local branch is ahead/behind of remote?
    local stat="$(git status --porcelain --branch | grep '^##' | grep -o '\[.\+\]$')"
    local aheadN="$(echo $stat | grep -o 'ahead \d\+' | grep -o '\d\+')"
    local behindN="$(echo $stat | grep -o 'behind \d\+' | grep -o '\d\+')"
    [ -n "$aheadN" ] && marks+=" $GIT_NEED_PUSH_SYMBOL$aheadN"
    [ -n "$behindN" ] && marks+=" $GIT_NEED_PULL_SYMBOL$behindN"
  
    # print the git branch segment without a trailing newline
    printf "$GIT_BRANCH_SYMBOL$branch$marks"
  }
  
  ps1() {
    # Check the exit code of the previous command and display different
    # colors in the prompt accordingly.
    if [ $? -eq 0 ] 
    then
      local EXIT="${FG_12}"
    else
      local EXIT="${BOLD}${FG_01}"
    fi

    PS1=""

    if [[ ${EUID} == 0 ]]
    then
	PS1+="${BG_09}${FG_15}${BOLD}\h${RESET}${FG_09}${BG_15}${PS_DELIM}${RESET}"
    else
	PS1+="${BG_10}${FG_00}${BOLD}\h${RESET}${FG_10}${BG_15}${PS_DELIM}${RESET}"
    fi

    PS1+="${BG_15}${FG_12} \w ${RESET}"

    GIT_INFO=$(__git_info)

    if [[ -n ${GIT_INFO} ]]
    then
      PS1+="${FG_15}${BG_12}${PS_DELIM}${FG_15}${BG_12} ${GIT_INFO} ${RESET}${FG_12}${PS_DELIM}${RESET}"
    else
      PS1+="${RESET}${FG_15}${PS_DELIM}${RESET}"
    fi

    PS1+=" ${EXIT}${PS_SYMBOL}${RESET} "
  }

  PROMPT_COMMAND=ps1
}
__powerline
unset __powerline

