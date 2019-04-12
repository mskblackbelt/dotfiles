#!/bin/bash

## Wrap Macports command (any executables installed by Macports).

set -euo pipefail
IFS=$'\n\t'

if [ "$#" -le 0 ]; then
  echo "Usage: $0 command [arg1, arg2, ...]" >&2
  exit 1
fi

set +u
if [[ -z $MACPORTS_PREFIX ]]; then
  MACPORTS_PREFIX='/opt/local'
fi

export PATH="$MACPORTS_PREFIX/bin:$MACPORTS_PREFIX/sbin:$PATH"
export CPATH="$MACPORTS_PREFIX/include:$CPATH"
set -u

command=$1

shift

exec $command $*