#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2016-06-30 14:46:43 +0100 (Thu, 30 Jun 2016)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

set -eu #o pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck disable=SC1090
. "$srcdir/lib/utils.sh"

if [ -z "$(find "${1:-.}" -name pom.xml)" ]; then
    return 0 &>/dev/null || :
    exit 0
fi

section "M a v e n"

start_time="$(start_timer)"

if command -v mvn &>/dev/null; then
    find "${1:-.}" -name pom.xml |
    grep -v '/target/' |
    while read -r pom; do
        echo "Validating $pom"
        mvn validate -f "$pom" || exit $?
        echo
    done
else
    echo "Maven not found in \$PATH, skipping maven pom checks"
fi

time_taken "$start_time"
section2 "Maven pom checks passed"
echo
