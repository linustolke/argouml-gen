#!/bin/sh

# ./h-upload.sh http://blablabla/where/the... file/path/to/files/to/upload

SVNURL=$1
FILES=$2

REVISIONS=`
(
  for proj in *
  do
    (
      cd $proj &&
        svn info | awk '/^Revision:/ { printf "%s:%s ", proj, $2; }' proj=$proj
    ) 2>/dev/null
  done
)`


CHECKEDOUTDIR=`basename $FILES`

svn co --non-interactive --ignore-externals $SVNURL upload/$CHECKEDOUTDIR

echo Copying files from $FILES
cp -r $FILES upload

echo Adding new files
(
    cd upload/$CHECKEDOUTDIR &&
    svn status | while read type path
    do
        case "$type" in
        '?') svn add $path
             case "$path" in
             *.html | *.css | *.log | *.txt )
                 svn propset svn:keywords "Author Date Id Revision" $path
                 svn propset svn:eol-style native $path
		 ;;
             esac
             ;;
        '!') svn rm $path
             ;;
        esac
    done
)

echo Commiting
svn commit --non-interactive -m"Uploaded from continous build.
$REVISIONS" upload/$CHECKEDOUTDIR

# If the commit failed, try again a few times
(
  cd upload/$CHECKEDOUTDIR
  svn status |
  awk '/^[AM]/ { print $2; }' |
  xargs -L 100 svn commit -m"Try upload again (in chunks of 100 files).
$REVISIONS"

  svn update
  svn status |
  awk '/^[AM]/ { print $2; }' |
  xargs -L 10 svn commit -m"Try upload again (in chunks of ten files).
$REVISIONS"

  svn update
  svn status |
  awk '/^[AM]/ { print $2; }' |
  xargs -L 1 svn commit -m"Try upload again (files one by one).
$REVISIONS"
)

echo Any files left:
(
  cd upload/$CHECKEDOUTDIR &&
  svn status
)
