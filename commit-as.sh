#!/bin/sh

# This script commits the reports into the argouml-stats project.
# You need a commiting role into that project for this to work.
#
# The arguments to this script is on the form reports/jdepend
# and the data to commit is taken from tmp/argouml/build/$arg that is
# assumed to be a directory.
#
# It is assumed that you have the argouml-stats project checked out.
# Check out with
# svn co http://argouml-stats.tigris.org/svn/argouml-stats/trunk argouml-stats

if test ! -d argouml-stats
then
    echo You need to checkout the argouml-stats directory.
    exit 1
fi

if test "`(cd argouml-stats && svn info) | grep '^URL:'`" != "URL: http://argouml-stats.tigris.org/svn/argouml-stats/trunk"
then
    echo The argouml-stats directory is incorrectly downloaded.
    exit 1
fi

( cd argouml-stats && svn update )

for arg in $*
do
    cp -r tmp/argouml/build/$arg `dirname argouml-stats/www/$arg`
    ( cd argouml-stats/www/$arg &&
      svn status | while read type path
      do
          case "$type" in
          '?') svn add $path
               ;;
          '!') svn rm $path
               ;;
          esac
      done
    )
done

echo Rebuilding the index.html file.
( cd argouml-stats/www && ls */*/index.html ) |
awk 'BEGIN { print "<html><head><title>ArgoUML Automatically Generated Files</title></head><body>";
             print "<ul>"; }
     { sub(/index.html/,"");
       printf "<li><a href=\"nonav/%s\">%s</a>\n", $NF, $NF; }
     END { print "</ul>";
	   print "</body>"; }' > argouml-stats/www/index.html

for arg in $*
do
    echo Commiting $arg
    ( cd argouml-stats/www/$arg &&
      svn commit -m"New version of files in $arg."
    )
done

echo Commiting the rest
( cd argouml-stats && svn commit -m'New version of files.' )
