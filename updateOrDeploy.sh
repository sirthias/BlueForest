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
    dirs+=" $HOME/.IdeaIC14"
    dirs+=" $HOME/.IdeaIC15"
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
        for baseDir in $(find ${only_dir}  -maxdepth 1 -type d -name "${only_name}[0-9]*")
        do
            configDir="${baseDir}/config"
            colorDir="${configDir}/colors"
            dir="${baseDir}/colors"
            if [ -e "$colorDir" ]
            then
                echo $colorDir
                copy_color_file $colorDir
            elif [ -e "$dir" ]
            then
                echo $dir
                copy_color_file $dir
            elif [ -e "$configDir" ]
            then
                # creating new empty color directory
                mkdir $colorDir
                echo $colorDir
                copy_color_file $colorDir
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
