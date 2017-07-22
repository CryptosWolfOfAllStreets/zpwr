#!/usr/bin/env bash
#{{{                    MARK:Header
#**************************************************************
#####   Author: JACOBMENKE
#####   Date: Mon Jul 17 13:30:47 EDT 2017
#####   Purpose: bash script to monitor log files in color
#####   Notes: 
#}}}***********************************************************

shopt -s globstar

#tailVersion="colortail -k $HOME/.colortailconf"
tailVersion=tail
weHaveCCZE=no

type ccze 1>/dev/null 2>&1 && {
weHaveCCZE=yes
}


if [[ $(uname) == Darwin ]]; then
    if [[ $weHaveCCZE == yes ]]; then
   $tailVersion -f /var/log/**/*.log /var/log/**/*.out \
       /var/log/cups/* "$HOME"/Library/Logs/**/*.log "$HOME"/Library/Logs/**/*.out \
        /Library/Logs/**/*.log | ccze
   else
   $tailVersion -f /var/log/**/*.log /var/log/**/*.out \
       /var/log/cups/* "$HOME"/Library/Logs/**/*.log "$HOME"/Library/Logs/**/*.out \
        /Library/Logs/**/*.log 
    fi
else
    #linux
    distroName=$(lsb_release -a | head -1 | awk '{print $3}')

    if [[ $distroName == Raspbian ]]; then

        if [[ $weHaveCCZE == yes ]]; then
            $tailVersion -f /var/log/**/*.log /var/log/{dmesg,debug,lastlog,messages} /var/log/**/*.err | ccze
        else
            $tailVersion -f /var/log/**/*.log /var/log/{dmesg,debug,lastlog,messages} /var/log/**/*.err
        fi
    else 
        printf "Unsupported distro: $distroName...but trying anyways\n" >&2
        $tailVersion -f /var/log/**/*.log /var/log/{dmesg,debug,lastlog,messages} /var/log/**/*.err
    fi

fi
