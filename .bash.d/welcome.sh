#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2012-06-25 15:20:39 +0100
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

# ============================================================================ #
#                                 W e l c o m e
# ============================================================================ #

# Original version was in Perl many years ago, but defaulting to Python version now

# Bash version further down is for interest of if you don't have the other repos

# welcome.py should be found in $PATH from DevOps-Python-Tools repo
alias welcome=welcome.py
#welcome(){ welcome.py; }

# set this instead to use bash only version if you don't have the other repos
#alias welcome=bash_welcome

bash_welcome(){
    local msg
    msg="Welcome Hari - your last access was $(last|head -n2|tail -n1|sed 's/[^ ]\+ \+[^ ]\+ \+[^ ]\+ \+//;s/ *$//')"
    #local msg="Welcome Hari"
    # generated by for x in {A..z}; do printf "%s" $x; done
    #charmap="ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_\`abcdefghijklmnopqrstuvwxyz"
    # generated by: for x in {1..128}; do printf \\$(printf '%03o' $x); done
    charmap="!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_\`abcdefghijklmnopqrstuvwxyz{|}~ \t\n"
    for ((i=0; i<"${#msg}"; i++)); do
        local x="${msg:i:1}"
        #echo "x == $x"
        printf " "
        local j=0
        while true; do
        #for ((j=0; j<"${#charmap}"; j++)); do
        #while true; do 
            #set -x
            if [ $j -gt 2 ]; then
                local y=$x
            else
                local y=${charmap:$((RANDOM%${#charmap})):1}
            fi
            #local y="${charmap:j:1}"
            printf "\b%s" "$y"
            # This does not have enough precision, re-implement in Perl
            # This is because it's an external being called, otherwise pure bash
            # is so fast that you don't see any effect...
            sleep 0.000000000001
            #perl -e 'sleep 0.0000000000000000000000000001'
            [ "$y" = "$x" ] && break
            ((j+=1))
            #set +x
        done
    done
    #printf "\n"
    printf "\n"
}

