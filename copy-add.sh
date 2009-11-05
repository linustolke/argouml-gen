#!/bin/sh

# This script copies the reports into the argouml-stats project
# adding new files if necessary.
#
# You need a commiting role into that project for this to work.
#
# The first argument is the target directory (including the leading
# argouml-stats/www).
#
# The rest of the arguments to this script is on the form
# reports/jdepend and the data to commit is taken from tmp/RESULT/$arg
# that is assumed to be a directory and copied to a directory below
# the target directory with the basename of the argument.
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

WHERE=tmp
set -- `getopt w: "$@"`
while true
do
  case "$1" in
  -w)
    shift
    WHERE="$1"
    shift
    ;;
  --)
    shift
    break
    ;;
  *)
    echo $0: Invalid argument $o 1>&2
    exit 1
    ;;
  esac
done

target=$1
shift

for arg in $*
do
    whereto=$target/`basename $arg`
    echo Copying $arg
    cp -r $WHERE/RESULT/$arg `dirname $whereto`

    echo Adding new files for $arg
    ( cd $whereto &&
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
done
