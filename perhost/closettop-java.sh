#!/bin/sh
# $Id: closettop.sh 570 2009-10-19 19:31:47Z linus $

# This is the script that is run from hudson once for each jdk.

if test ! -f build-reports.xml
then
    echo You need to start from the right directory.
fi

case "$JAVA_HOME" in
*jdk1.5.0*)
    JAVA_NAME=java5
    ;;
*jdk1.6.0*)
    JAVA_NAME=java6
    ;;
*)
    echo "Unknown jdk!"
    exit 1
    ;;
esac

PRESENTED=argouml-stats/www/reports-$JAVA_NAME
WORKDIR=tmp-$JAVA_NAME

#
# Retrieve the new version of the sources
#
./update.sh -m -w $WORKDIR

LOG=argouml-stats/www/closettop.log

function DO_ONE_TARGET() {
    target=$1
    echo "$(date) $target started..."
    shift
    if ./build.sh -Dworking.dir=$WORKDIR report:$target -l $PRESENTED/$target/output.txt
    then
      ./copy-add.sh -w $WORKDIR $PRESENTED $*
      echo `date +"%b %d %H:%M"`: $JAVA_NAME $target updated >> $LOG
    else
      echo `date +"%b %d %H:%M"`: $JAVA_NAME $target FAILED >> $LOG
    fi
    echo "$(date) $target...........done."
}

# Starting the reports.

./build.sh -Dworking.dir=$WORKDIR clean
DO_ONE_TARGET javadocs 	reports/javadocs reports/javadocs-api

./build.sh -Dworking.dir=$WORKDIR clean
DO_ONE_TARGET release           reports/release
DO_ONE_TARGET checkstyle	reports/checkstyle
DO_ONE_TARGET junit		reports/junit
DO_ONE_TARGET cpp-junit		reports/cpp-junit
DO_ONE_TARGET coverage          reports/coverage
./build.sh -Dworking.dir=$WORKDIR clean

./create-index.sh > argouml-stats/www/index.html
