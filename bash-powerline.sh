#!/usr/bin/env bash

__powerline_colorscheme(){
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

    readonly PROMPT_DIVIDER=''
    readonly PWD_DIVIDER='/'
    readonly GIT_BRANCH_SYMBOL=''


    # colorscheme

    readonly FG_BLACK="$(tput setaf 0)"
    readonly FG_RED="$(tput setaf 1)"
    readonly FG_GREEN="$(tput setaf 2)"
    readonly FG_YELLOW="$(tput setaf 3)"
    readonly FG_BLUE="$(tput setaf 4)"
    readonly FG_MAGENTA="$(tput setaf 5)"
    readonly FG_CYAN="$(tput setaf 6)"
    readonly FG_WHITE="$(tput setaf 7)"
    readonly FG_ORANGE="$(tput setaf 9)"
    readonly FG_VIOLET="$(tput setaf 13)"

    readonly BG_YELLOW="$(tput setab 3)"
    readonly BG_ORANGE="$(tput setab 9)"
    readonly BG_RED="$(tput setab 1)"
    readonly BG_MAGENTA="$(tput setab 5)"
    readonly BG_VIOLET="$(tput setab 13)"
    readonly BG_BLUE="$(tput setab 4)"
    readonly BG_CYAN="$(tput setab 6)"
    readonly BG_WHITE="$(tput setab 7)"
    readonly BG_GREEN="$(tput setab 2)"

    readonly DIM="$(tput dim)"
    readonly REVERSE="$(tput rev)"
    readonly RESET="$(tput sgr0)"
    readonly BOLD="$(tput bold)"


    readonly BG_BASE0=$BG_BLUE
    readonly FG_BASE0=$FG_BLUE

    readonly FG_BASE00=$FG_WHITE

    readonly FG_BASE1=$FG_WHITE
    readonly BG_BASE1=$BG_WHITE

    readonly FG_BASE01=$FG_BLACK

    readonly FG_BASE2=$FG_MAGENTA
    readonly BG_BASE2=$BG_MAGENTA

    readonly FG_BASE02=$FG_WHITE

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
}
__powerline() {
    __powerline_colorscheme

    hash /usr/bin/timeout
    hash sed 


    if hash /usr/bin/git &> /dev/null; then
	    __git_info() {
		    /usr/bin/git 2>/dev/null status --ignore-submodules --porcelain --branch -uno |\
			    sed -n -e '
		    1{s/##\s\+\([^\.]*\)\.*[^\[]*/'" $GIT_BRANCH_SYMBOL"'\1/;
		    s/ *behind \([0-9]*\)/⇣\1/;
		    s/ *ahead \([0-9]*\)/⇡\1/;
		    h;};
		    /^ *[UDCMA]/{H;x;s/\n.*$/'"$GIT_BRANCH_CHANGED_SYMBOL"'/;p;q};
		    ${H;p};
		    '
	    }
    else 
	    __git_info() {
		    printf ""
	    }
    fi



    __getpwd() {
	    local my_pwd=${1/#"$HOME"/\~}
	    echo -n "${my_pwd//\// }"
    }

    __removezero() {
	    echo ${1/#0}
    }

    __save_ret() {
	    __ret=$?
    }

    __getret() {
	    if [ $1 -ne 0 ]; then
		    [ $2 -ne 1 ] && echo "$BG_RED" || echo  "$FG_RED"
	    else
      		    [ $2 -ne 1 ] && echo  "$BG_GREEN" || echo "$FG_GREEN"
    fi
  }

  PS1=''

  # username
  if [[ $EUID == 0 ]]; then
	  PS1+="\[\e]0;[root]\w\a\]"

	  PS1+="\[$BG_RED$FG_BASE00\] \u "
	  PS1+="\[$RESET$BG_BASE0$FG_RED\]$PROMPT_DIVIDER"
  else
	  if [[ $OSTYPE == "cygwin" || $OSTYPE == "msys" ]] && net session &> /dev/null; then
		  PS1+="\[\e]0;[root]\w\a\]"

		  PS1+="\[$BG_RED$FG_BASE00\] \u "
		  PS1+="\[$RESET$FG_RED$BG_BASE1\]$PROMPT_DIVIDER"
	  else
		  PS1+="\[\e]0;\w\a\]"

		  PS1+="\[$BG_BASE0$FG_BASE00\] \u "
		  PS1+="\[$RESET$FG_BASE0$BG_BASE1\]$PROMPT_DIVIDER"
	  fi
  fi

  # path
  PS1+="\[$FG_BASE01\]"
  PS1+='$(__getpwd \w)'

  # git
  PS1+="\[$RESET$FG_BASE1$BG_BASE2\]$PROMPT_DIVIDER\[$FG_BASE02\]"
  PS1+='${CONDA_DEFAULT_ENV:+($CONDA_DEFAULT_ENV) }'
  PS1+='$(__git_info)'

  PS1+="\[$RESET$FG_BASE2"
  PS1+='$(__getret $(($__ret+0)) 2 )'
  PS1+="\]$PROMPT_DIVIDER"
  # segment transition
  PS1+='$(__removezero \j)'
  PS1+="\[$RESET"
  PS1+='$(__getret $(($__ret+0)) 1 )'
  PS1+="\]$PROMPT_DIVIDER\[$RESET\]"

  PROMPT_COMMAND="__save_ret;${PROMPT_COMMAND#__save_ret;}"
}

__powerline
unset __powerline
