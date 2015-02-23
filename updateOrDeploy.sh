#!/bin/bash
# updateOrDeploy.sh - updates or deploys the BlueForest.xml.
#
# Copies the BlueForest.xml from/to the current users IntelliJ config 
# colors directory. 
#
# Works for MacOSX, Linux and windows (using cygwin/mingw)
#
# Set "mode" environment variable to "update" to update, otherwise
# deploy is assumed.
# set up possible directory locations

export dirs
# mac locations
if [ -d ~/Library ]
then
    dirs+=" $HOME/Library/Preferences/IntelliJIdea"
    dirs+=" $HOME/Library/Preferences/IdeaIC"
fi

# linux locations
if [ -d ~ ]
then
    dirs+=" $HOME/.IntelliJIdea"
    dirs+=" $HOME/.IdeaIC"
fi

# cygwin locations
if [ ! -z $USERPROFILE ] 
then
    dirs+=" $USERPROFILE/.IntelliJIdea"
    dirs+=" $USERPROFILE/.IdeaIC"
fi

function copy_color_file {
    if [ "$mode" = "update" ]
    then
        echo "Copying BlueForest.{xml, icls} from $1 to $PWD"
        cp -i $1/BlueForest.xml $1/BlueForest.icls .
    else
        echo "Copying BlueForest.{xml, icls} to $1"
        cp -i BlueForest.xml BlueForest.icls $1
    fi
    lastInstallDir=$1
}

# potential directories picked, check for different versions,
# copy to all matches, stale preference structures may exist
for dirName in  $dirs
do
    typeset old_ifs=$IFS
    #IFS=$'\n'
    typeset only_dir=${dirName%/*} 
    typeset only_name=${dirName##*/}
    if [[ -e "${only_dir}" ]] 
    then
        for cfgDir in $(find ${only_dir}  -maxdepth 1 -type d -name "${only_name}[0-9]*")
        do
            configDir="${cfgDir}/config/colors"
            dir="${cfgDir}/colors"
            if [ -e "$configDir" ]
            then
                echo $configDir
                copy_color_file $configDir
            elif [ -e "$dir" ]
            then
                echo $dir
                copy_color_file $dir
            fi
        done
    fi
    IFS=$old_ifs
done

# No IntelliJ found, exit
if [ -z $lastInstallDir ]
then
    echo "IntelliJ directory was not found"
    exit 1
fi

