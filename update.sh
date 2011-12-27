#/bin/sh
for version in "11" "10"
do
  dir="`echo ~/Library/Preferences/IntelliJIdea$version/colors`"
  if [ -e "$dir" ]
  then
    cp $dir/BlueForest.xml .
    break
  fi
done

