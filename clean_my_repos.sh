#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2016-01-17 12:14:06 +0000 (Sun, 17 Jan 2016)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help improve or steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(dirname "$0")"

while read -r repo; do
    if [ -d "$repo" ]; then
        pushd "$repo"
        # make update does git pull but if that mechanism is broken then this first git pull will allow the repo to self-fix itself
        if grep -q '^clean:' Makefile; then
            make clean
        fi
        popd
    fi
done < <(sed 's/#.*//' < "$srcdir/lib/repolist.txt")
