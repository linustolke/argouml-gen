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

(
  cd argouml-stats &&
  svn update || sleep 10 && svn update ) || exit 1
LOG=argouml-stats/www/closettop.log

function DO_ONE_TARGET() {
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
      svn commit -m"Committing result from $JAVA_NAME $target for $REVISIONS" ||
      sleep 10 &&
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
DO_ONE_TARGET jdepend	reports/jdepend
DO_ONE_TARGET javadocs 	reports/javadocs reports/javadocs-api
( cd $PRESENTED/javadocs-api &&
  svn commit -m"Committing result from $JAVA_NAME javadocs-api for $REVISIONS"
)

DO_ONE_TARGET findbugs	 	reports/findbugs
DO_ONE_TARGET i18ncomparison 	reports/i18ncomparison
./build.sh clean
DO_ONE_TARGET checkstyle	reports/checkstyle
DO_ONE_TARGET junit		reports/junit
DO_ONE_TARGET cpp-junit		reports/cpp-junit
DO_ONE_TARGET coverage          reports/coverage

# Building documentation
PRESENTED=argouml-stats/www

SHORTPRES=documentation
DO_ONE_TARGET documentation documentation/defaulthtml documentation/printablehtml documentation/pdf

SHORTPRES=documentation-es
DO_ONE_TARGET documentation-es documentation-es/defaulthtml documentation-es/printablehtml documentation-es/pdf

SHORTPRES=documentation-de
DO_ONE_TARGET documentation-de documentation-de/defaulthtml documentation-de/printablehtml documentation-de/pdf

./create-index.sh > argouml-stats/www/index.html
(
  cd argouml-stats/www &&
  svn commit -m"Committing all the rest for $REVISIONS" ||
  sleep 10 && svn commit -m"Committing all the rest for $REVISIONS (second attempt)" ||
  sleep 100 && svn commit -m"Committing all the rest for $REVISIONS (third attempt)" ||
  sleep 200 && svn commit -m"Committing all the rest for $REVISIONS (fourth attempt)"
)
