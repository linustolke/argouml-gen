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

LOG=argouml-stats/www/closettop.log

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
./build.sh clean

./create-index.sh > argouml-stats/www/index.html
