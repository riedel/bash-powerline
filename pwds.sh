#!/bin/bash
#
# source http://stackoverflow.com/a/1618602
#

if [[ ${#} != 2 ]]
then
  echo "Usage: pwds <PATH> <LENGTH>"
  exit 1
fi

PRE=""
NAME="${1}"
LENGTH="${2}"

SYMBOL="…"

if [[ "${NAME}" != "${NAME#${HOME}/}" || -z "${NAME#${HOME}}" ]]
then
  PRE+='~' NAME="${NAME#${HOME}}" LENGTH=$[LENGTH-1]
fi
if ((${#NAME}>${LENGTH}))
then 
  NAME="/${SYMBOL}${NAME:$[${#NAME}-LENGTH+1]}"
fi

echo "${PRE}${NAME}"
