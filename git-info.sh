#!/bin/bash

readonly GIT_BRANCH_SYMBOL=' '
readonly GIT_BRANCH_CHANGED_SYMBOL='±'
readonly GIT_NEED_PUSH_SYMBOL='⇡'
readonly GIT_NEED_PULL_SYMBOL='⇣'

source /usr/local/bin/git-check

MARKS=""

# branch is modified?
[ -n "$(git status --porcelain)" ] && MARKS+=" ${GIT_BRANCH_CHANGED_SYMBOL}"

# how many commits local branch is ahead/behind of remote?
STAT="$(git status --porcelain --branch | grep '^##' | grep -o '\[.\+\]$')"
AHEADN="$(echo $stat | grep -o 'ahead \d\+' | grep -o '\d\+')"
BEHINDN="$(echo $stat | grep -o 'behind \d\+' | grep -o '\d\+')"
[ -n "${AHEADN}" ] && MARKS+=" ${GIT_NEED_PUSH_SYMBOL}${AHEADN}"
[ -n "${BEHINDN}" ] && MARKS+=" ${GIT_NEED_PULL_SYMBOL}${BEHINDN}"

# print the git branch segment without a trailing newline
printf "${GIT_BRANCH_SYMBOL}${BRANCH}${MARKS}"
