#!/bin/sh
# $Id$

# This is the script that is run by crontab on Linus' Linux host closettop

if test ! -f build-reports.xml
then
    echo You need to start from the right directory.
fi

#
# Retrieve the new version of the sources
#

./update.sh

REVISIONS=`
(
  cd tmp
  for proj in a*
  do
    (
      cd $proj &&
        svn info | awk '/^Revision:/ { printf "%s:%s ", proj, $2; }' proj=$proj
    )
  done
)`

( cd argouml-stats && svn update ) || exit 1
LOG=argouml-stats/www/closettop.log

function onetarget() {
    target=$1
    echo "$(date) $target started..."
    shift
    if ./build.sh report:$target -l $PRESENTED/$target/output.txt
    then
      ./copy-add.sh $SHORTPRES $*
      echo `date +"%b %d %H:%M"`: $JAVA_NAME $target updated >> $LOG
    else
      echo `date +"%b %d %H:%M"`: $JAVA_NAME $target FAILED >> $LOG
    fi
    (
      cd $PRESENTED/$target &&
      svn commit -m"Committing result from $JAVA_NAME $target for $REVISIONS"
    )
    echo "$(date) $target...........done."
}

# Starting the reports.

# Do things for java5.

JAVA_HOME=/usr/local/lib/java/jdk1.5.0_06
export JAVA_HOME
JAVA_NAME=java5
SHORTPRES=reports-$JAVA_NAME
PRESENTED=argouml-stats/www/$SHORTPRES

./build.sh clean || exit 1
onetarget jdepend	reports/jdepend
onetarget javadocs 	reports/javadocs reports/javadocs-api
onetarget findbugs 	reports/findbugs
onetarget i18ncomparison 	reports/i18ncomparison
./build.sh clean
onetarget checkstyle	reports/checkstyle
onetarget junit		reports/junit
onetarget cpp-junit	reports/cpp-junit

# Building documentation
PRESENTED=argouml-stats/www

SHORTPRES=documentation
onetarget documentation documentation/defaulthtml documentation/printablehtml documentation/pdf

SHORTPRES=documentation-es
onetarget documentation-es documentation-es/defaulthtml documentation-es/printablehtml documentation-es/pdf

./create-index.sh > argouml-stats/www/index.html
(
  cd argouml-stats/www &&
  svn commit -m"Committing all the rest for $REVISIONS"
)
