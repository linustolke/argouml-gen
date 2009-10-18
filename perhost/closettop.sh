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

./update.sh -m

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

LOG=argouml-stats/www/closettop.log

function COMMIT() {
  message=$1
  svn commit -m"Committing $message
Corresponding to $REVISIONS." 2>&1 |
  sed "s;^;SVN commit $message: ;"
}

function DO_ONE_TARGET() {
    target=$1
    echo "$(date) $target started..."
    shift
    if ./build.sh report:$target -l $PRESENTED/$target/output.txt
    then
      ./copy-add.sh $PRESENTED $*
      echo `date +"%b %d %H:%M"`: $JAVA_NAME $target updated >> $LOG
    else
      echo `date +"%b %d %H:%M"`: $JAVA_NAME $target FAILED >> $LOG
    fi

    for arg in $*
    do
      (
        cd $PRESENTED/`basename $arg` &&
        COMMIT "result for $JAVA_NAME $target from $arg"
      ) &
    done
    echo "$(date) $target...........done."
}

# Starting the reports.


# Do things for java5.

JAVA_HOME=/usr/local/lib/java/jdk1.5.0_06
export JAVA_HOME
JAVA_NAME=java5
PRESENTED=argouml-stats/www/reports-$JAVA_NAME

./build.sh clean ## TODO: Avoid to do this since it doesn't work || exit 1
DO_ONE_TARGET release   reports/release
DO_ONE_TARGET jdepend	reports/jdepend
DO_ONE_TARGET javadocs 	reports/javadocs reports/javadocs-api

DO_ONE_TARGET findbugs	 	reports/findbugs reports/findbugs-xml
DO_ONE_TARGET i18ncomparison 	reports/i18ncomparison
./build.sh clean
DO_ONE_TARGET checkstyle	reports/checkstyle
DO_ONE_TARGET junit		reports/junit
DO_ONE_TARGET cpp-junit		reports/cpp-junit
DO_ONE_TARGET coverage          reports/coverage
echo "$(date) waiting..........."
wait 
wait 
wait 
wait 
wait 
wait 
wait 
wait 
wait 
wait 
wait 
echo "$(date) waiting...........done"

(
  cd $PRESENTED/coverage/coverage &&
  COMMIT "extra split coverage"
) &
(
  cd $PRESENTED/coverage/junit &&
  COMMIT "extra split coverage"
)
echo "$(date) waiting coverage..........."
wait
echo "$(date) waiting coverage...........done"

(
  cd $PRESENTED/coverage &&
  COMMIT "extra coverage"
) &

./build.sh clean


# Do things for java6

JAVA_HOME=/usr/local/lib/java/jdk1.6.0
export JAVA_HOME
JAVA_NAME=java6
PRESENTED=argouml-stats/www/reports-$JAVA_NAME

./build.sh clean
DO_ONE_TARGET javadocs 	reports/javadocs reports/javadocs-api

./build.sh clean
DO_ONE_TARGET release           reports/release
DO_ONE_TARGET checkstyle	reports/checkstyle
DO_ONE_TARGET junit		reports/junit
DO_ONE_TARGET cpp-junit		reports/cpp-junit
DO_ONE_TARGET coverage          reports/coverage
echo "$(date) waiting..........."
wait 
wait 
wait 
wait 
wait 
wait 
wait 
echo "$(date) waiting...........done"

(
  cd $PRESENTED/coverage/coverage &&
  COMMIT "extra split coverage"
) &
(
  cd $PRESENTED/coverage/junit &&
  COMMIT "extra split coverage"
)
echo "$(date) waiting coverage..........."
wait
echo "$(date) waiting coverage...........done"

(
  cd $PRESENTED/coverage &&
  COMMIT "extra coverage"
) &

./build.sh clean

./create-index.sh > argouml-stats/www/index.html

wait
