#!/bin/sh
# $Id$

# This is the script that is run by crontab on Linus' Linux host closettop

if test ! -f build-reports.xml
then
    echo You need to start from the right directory.
fi

JAVA_HOME=/usr/local/lib/java/j2sdk1.4.2_10
export JAVA_HOME

./build.sh update || exit 1

( cd argouml-stats && svn update ) || exit 1

./build.sh report:jcoverage &&
  ./commit-as.sh reports/jcoverage reports/junit-result-jcoverage

./build.sh report:jdepend &&
  ./commit-as.sh reports/jdepend

./build.sh report:checkstyle &&
  ./commit-as.sh reports/checkstyle

./build.sh report:javadocs &&
  ./commit-as.sh reports/javadocs reports/javadocs-api

./build.sh report:findbugs &&
  ./commit-as.sh reports/findbugs

./build.sh report:i18ncomparison &&
  ./commit-as.sh reports/i18ncomparison


./build.sh update-documentation || exit 1

./build.sh report:documentation &&
  ./commit-as.sh documentation/defaulthtml
