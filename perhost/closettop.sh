#!/bin/sh
# $Id$

# This is the script that is run by hudson on Linus' Linux host closettop

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

# Do things using java5.
JAVA_HOME=/usr/local/lib/java/jdk1.5.0_06
export JAVA_HOME
JAVA_NAME=java5
PRESENTED=argouml-stats/www/reports-$JAVA_NAME

DO_ONE_TARGET jdepend	reports/jdepend
DO_ONE_TARGET findbugs	 	reports/findbugs reports/findbugs-xml
DO_ONE_TARGET i18ncomparison 	reports/i18ncomparison
./build.sh clean

./create-index.sh > argouml-stats/www/index.html
