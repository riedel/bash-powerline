#!/bin/bash

[ -x "$(which git)" ] || exit
[ -d "${PWD}/.git" ] || exit

# get current branch name or short SHA1 hash for detached head
BRANCH="$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)"
[ -n "${BRANCH}" ] || exit 
