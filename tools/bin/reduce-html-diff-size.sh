#!/bin/sh

# Go through the html files and modify them to reduce the diff size.
find . -name \*.html -print |
while read htmlfile
do
  mv $htmlfile $htmlfile.orig &&
  sed 's/\(\(name\|href\)="[^"]*"\)/\n    &\n/g' $htmlfile.orig > $htmlfile &&
  rm $htmlfile.orig
done
