#!/bin/sh

# This script copies the reports into the argouml-stats project
# adding new files if necessary.
#
# You need a commiting role into that project for this to work.
#
# The first argument is the target directory (below argouml-stats/www).
#
# The rest of the arguments to this script is on the form
# reports/jdepend and the data to commit is taken from tmp/RESULT/$arg
# that is assumed to be a directory.
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

target=$1
shift

for arg in $*
do
    whereto=argouml-stats/www/$target/`basename $arg`
    echo Copying $arg
    cp -r tmp/RESULT/$arg `dirname $whereto`

    echo Adding new files for $arg
    ( cd $whereto &&
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
