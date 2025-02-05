#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2015-05-25 01:38:24 +0100 (Mon, 25 May 2015)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help improve or steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

set -u
[ -n "${DEBUG:-}" ] && set -x
srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck disable=SC1090
. "$srcdir/lib/utils.sh"

if [ -z "$(find "${1:-.}" -maxdepth 2 -type f -iname '*.py' -o -iname '*.jy')" ]; then
    return 0 &>/dev/null || :
    exit 0
fi

section "Compiling Python / Jython files"

start_time="$(start_timer)"

if [ -n "${NOCOMPILE:-}" ]; then
    echo "\$NOCOMPILE environment variable set, skipping python compile"
elif [ -n "${QUICK:-}" ]; then
    echo "\$QUICK environment variable set, skipping python compile"
else
    if [ -n "${FAST:-}" ]; then
        python -m compileall "${1:-.}" || :
    else
        for x in $(find "${1:-.}" -maxdepth 2 -type f -iname '*.py' -o -iname '*.jy' | sort); do
            type isExcluded &>/dev/null && isExcluded "$x" && continue
            echo "compiling $x"
            # -O  - optimize
            # -3  - warn on Python 3 incompatibilies that 2to3 cannot easily fix
            # -t  - warn on inconsistent use of tabs
            python -O -3 -t -m py_compile "$x"
        done
    fi
fi

time_taken "$start_time"
section2 "Finished compiling Python / Jython files"
echo
