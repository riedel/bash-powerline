#!/usr/bin/env bash

__powerline() {

    ## standard fonts
    # ▷ ◣ ▶︎ ➤ 〉  $ % ⑂ + ⇡ ⇣
    ## for powerline patched fonts
    # █       

    # Max length of full path

    ## USER CONFIG ##
    readonly max_path_depth=3
    readonly MAX_PATH_LENGTH=30
    readonly PS_DELIM=''

    # Unicode symbols
    readonly PS_SYMBOL_DARWIN=''
    readonly PS_SYMBOL_LINUX='$'
    readonly PS_SYMBOL_OTHER='%'

    readonly GIT_BRANCH_CHANGED_SYMBOL='+'
    # readonly GIT_BRANCH_CHANGED_SYMBOL='±'
    readonly GIT_NEED_PUSH_SYMBOL='⇡'
    readonly GIT_NEED_PULL_SYMBOL='⇣'

    # This is working for me, but I need to figure out
    # a good way to indicate whether we should use
    # powerline-fonts or not.
    if [[ $TERM = "xterm-16color" ]]; then
        # use standard fonts
        readonly PROMPT_DIVIDER=' '
        readonly PWD_DIVIDER='/'
        readonly GIT_BRANCH_SYMBOL=' ⑂ '

    else # use powerline-fonts
        readonly PROMPT_DIVIDER=''
        readonly PWD_DIVIDER='/'
        readonly GIT_BRANCH_SYMBOL='  '
    fi




    # Solarized colorscheme
    readonly FG_BASE03="\[$(tput setaf 8)\]"
    readonly FG_BASE02="\[$(tput setaf 0)\]"
    readonly FG_BASE01="\[$(tput setaf 7)\]"
    readonly FG_BASE00="\[$(tput setaf 10)\]"
    readonly FG_BASE0="\[$(tput setaf 12)\]"
    readonly FG_BASE1="\[$(tput setaf 14)\]"
    readonly FG_BASE2="\[$(tput setaf 7)\]"
    readonly FG_BASE3="\[$(tput setaf 15)\]"

    readonly BG_BASE03="\[$(tput setab 8)\]"
    readonly BG_BASE02="\[$(tput setab 0)\]"
    readonly BG_BASE01="\[$(tput setab 7)\]"
    readonly BG_BASE00="\[$(tput setab 10)\]"
    readonly BG_BASE0="\[$(tput setab 12)\]"
    readonly BG_BASE1="\[$(tput setab 14)\]"
    readonly BG_BASE2="\[$(tput setab 7)\]"
    readonly BG_BASE3="\[$(tput setab 15)\]"

    readonly FG_YELLOW="\[$(tput setaf 3)\]"
    readonly FG_ORANGE="\[$(tput setaf 9)\]"
    readonly FG_RED="\[$(tput setaf 1)\]"
    readonly FG_MAGENTA="\[$(tput setaf 5)\]"
    readonly FG_VIOLET="\[$(tput setaf 13)\]"
    readonly FG_BLUE="\[$(tput setaf 4)\]"
    readonly FG_CYAN="\[$(tput setaf 6)\]"
    readonly FG_GREEN="\[$(tput setaf 2)\]"

    readonly BG_YELLOW="\[$(tput setab 3)\]"
    readonly BG_ORANGE="\[$(tput setab 9)\]"
    readonly BG_RED="\[$(tput setab 1)\]"
    readonly BG_MAGENTA="\[$(tput setab 5)\]"
    readonly BG_VIOLET="\[$(tput setab 13)\]"
    readonly BG_BLUE="\[$(tput setab 4)\]"
    readonly BG_CYAN="\[$(tput setab 6)\]"
    readonly BG_GREEN="\[$(tput setab 2)\]"

    readonly DIM="\[$(tput dim)\]"
    readonly REVERSE="\[$(tput rev)\]"
    readonly RESET="\[$(tput sgr0)\]"
    readonly BOLD="\[$(tput bold)\]"

    # what OS?
    case "$(uname)" in
        Darwin)
            readonly PS_SYMBOL=$PS_SYMBOL_DARWIN
            ;;
        Linux)
            readonly PS_SYMBOL=$PS_SYMBOL_LINUX
            ;;
        *)
            readonly PS_SYMBOL=$PS_SYMBOL_OTHER
    esac


    if (hash git &> /dev/null); then
    __git_info() {
	    git 2>/dev/null status --porcelain --branch |  sed -n -e '
	    s/##\(.*\)\.\.\.[^\[]*/'"$PROMPT_DIVIDER$GIT_BRANCH_SYMBOL"'\1 /;
	    s/ *behind \([0-9]*\)/⇣\1/;
	    s/ *ahead \([0-9]*\)/⇡\1/;1{h};
	    s/^ *[UDCMA].*$/+/;
	    /^+/{H;x;s/[\n ]//g;p;q};
	    /^\?/{x;s/[\n ]//;p;q}'
    }
    else 
    __git_info() {
      printf ""
    }
    fi


    __virtualenv() {
        # Copied from Python virtualenv's activate.sh script.
        # https://github.com/pypa/virtualenv/blob/a9b4e673559a5beb24bac1a8fb81446dd84ec6ed/virtualenv_embedded/activate.sh#L62
        # License: MIT
        if [ "x$VIRTUAL_ENV" != "x" ]; then
            if [ "`basename \"$VIRTUAL_ENV\"`" == "__" ]; then
                # special case for Aspen magic directories
                # see http://www.zetadev.com/software/aspen/
                printf "[`basename \`dirname \"$VIRTUAL_ENV\"\``]"
            else
                printf "(`basename \"$VIRTUAL_ENV\"`)"
            fi
        fi
    }


    __getpwd() {
        local my_pwd=${1/#"$HOME"/\~}
        echo -n "${my_pwd//\// }"
      }


    ps1() {
    if [ $? -ne 0 ]; then
      BG_EXIT="${BG_RED#\\[}"
      FG_EXIT="${FG_RED#\\[}"
    else
      BG_EXIT="${BG_GREEN#\\[}"
      FG_EXIT="${FG_GREEN#\\[}"
    fi
    BG_EXIT="${BG_EXIT%\\]}"
    FG_EXIT="${FG_EXIT%\\]}"
  }

  PS1=""

  # username
  if [[ $EUID == 0 ]]; then
	  PS1+="$BG_RED$FG_BASE3 \u $RESET"
	  PS1+="$BG_BASE0$FG_RED$PROMPT_DIVIDER$RESET"
  else
	  if [[ $OSTYPE == "cygwin" ]] && net session &> /dev/null; then
		  PS1+="$BG_RED$FG_BASE3 \u $RESET"
		  PS1+="$BG_BASE0$FG_RED$PROMPT_DIVIDER$RESET"
	  else
		  PS1+="$BG_BLUE$FG_BASE3 \u $RESET"
		  PS1+="$BG_BASE00$FG_BLUE$PROMPT_DIVIDER$RESET"
	  fi
  fi

  PS1+="$BG_BASE0$FG_BASE3$(__virtualenv)$RESET"

  # path
  # PS1+="$BG_BASE00$FG_BASE3 $(__getpwd) $RESET"
  PS1+="$BG_BASE0$FG_BASE3 "'$(__getpwd \w)'" $RESET"

  # git status
  PS1+="$BG_BASE01$FG_BASE00"'$(__git_info)'"$FG_BASE01"'$BG_EXIT'"$PROMPT_DIVIDER$RESET"
  # segment transition
  PS1+='$FG_EXIT'"$PROMPT_DIVIDER$RESET "

  PROMPT_COMMAND=ps1
  PROMPT_DIRTRIM=2
}

__powerline
unset __powerline
