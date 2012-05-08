#/bin/sh
for dirName in "IdeaIC" "IntelliJIdea"
do
  for version in "11" "10"
  do
    dir="`echo ~/Library/Preferences/$dirName$version/colors`"
    if [ -e "$dir" ]
    then
      cp BlueForest.xml $dir
      installDir=$dir
      break 2
    fi
    done
done

if [ -n "$installDir" ]
then
  echo "Installed color scheme in directory: $installDir"
else 
  echo "Couldn't install the color scheme. IntelliJ Preference directory was not found"
fi
