#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2018-10-03 12:50:57 +0100 (Wed, 03 Oct 2018)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help improve or steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

set -eu
[ -n "${DEBUG:-}" ] && set -x
srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck disable=SC1090
. "$srcdir/lib/utils.sh"

if [ -z "$(find "${1:-.}" -maxdepth 2 -type f -iname '*.py' -o -iname '*.jy')" ]; then
    return 0 &>/dev/null || :
    exit 0
fi

section "Python - find and alert on any usage of assert outside of /test/"

start_time="$(start_timer)"

found=0
for x in $(find "${1:-.}" -maxdepth 2 -type f -iname '*.py' -o -iname '*.jy' | sort); do
    type isExcluded &>/dev/null && isExcluded "$x" && echo -n '-' && continue
    # exclude pytests
    [[ "$x" = ./test/* ]] && continue
    echo -n '.'
    if grep -E '^[[:space:]]+\bassert\b' "$x"; then
        echo
        echo "WARNING: $x contains 'assert'!! This could be disabled at runtime by PYTHONOPTIMIZE=1 / -O / -OO and should not be used!! "
        found=1
        #if ! is_CI; then
        #    exit 1
        #fi
    fi
done
if [ $found != 0 ]; then
    exit 1
fi

time_taken "$start_time"
section2 "Python OK - assertions found in normal code"
echo
