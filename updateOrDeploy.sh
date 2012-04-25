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
    dirs+=" ~/Library/Preferences/IntelliJIdea"
    dirs+=" ~/Library/Preferences/IdeaIC"
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

# potential directories picked, check for different versions,
# select first match
for version in "11" "10"
do
    for dirName in $dirs
    do
        dir="`echo $dirName$version/config/colors`"
        echo $dir

        if [ -e "$dir" ]
        then
            if [ "$mode" = "update" ]
            then
                echo "Copying BlueForest.xml from $dir to $PWD"
                cp -i $dir/BlueForest.xml .
            else
                echo "Copying BlueForest.xml to $dir"
                cp -i BlueForest.xml $dir
            fi
            installDir=$dir
            break 2
        fi
    done
done

# No IntelliJ found, exit
if [ -z $installDir ]
then
    echo "IntelliJ directory was not found"
    exit 1
fi
