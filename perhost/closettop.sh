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
  svn update || sleep 10 && svn update
) || exit 1

LOG=argouml-stats/www/closettop.log

function COMMIT() {
  message=$1
  svn commit -m"$message
Corresponding to $REVISIONS." ||
  sleep 30 &&
  svn commit -m"$message
Corresponding to $REVISIONS.
Second attempt to commit." ||
  echo ERROR: $(date): Two commit attempts failed in $(pwd) with message $message. Giving up.
}

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
      COMMIT "Committing result from $JAVA_NAME $target"
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

./build.sh clean ## TODO: Avoid to do this since it doesn't work || exit 1
DO_ONE_TARGET release   reports/release
DO_ONE_TARGET jdepend	reports/jdepend
DO_ONE_TARGET javadocs 	reports/javadocs reports/javadocs-api
(
  cd $PRESENTED/javadocs-api &&
  COMMIT "Committing result from $JAVA_NAME javadocs-api"
)

DO_ONE_TARGET findbugs	 	reports/findbugs reports/findbugs-xml
DO_ONE_TARGET i18ncomparison 	reports/i18ncomparison
./build.sh clean
DO_ONE_TARGET checkstyle	reports/checkstyle
DO_ONE_TARGET junit		reports/junit
DO_ONE_TARGET cpp-junit		reports/cpp-junit
DO_ONE_TARGET coverage          reports/coverage
(
  cd $PRESENTED/coverage/coverage &&
  COMMIT "Committing extra split coverage"
)
(
  cd $PRESENTED/coverage/junit &&
  COMMIT "Committing extra split coverage"
)
(
  cd $PRESENTED/coverage &&
  COMMIT "Committing extra coverage"
)

./build.sh clean


# Do things for java6

JAVA_HOME=/usr/local/lib/java/jdk1.6.0
export JAVA_HOME
JAVA_NAME=java6
SHORTPRES=reports-$JAVA_NAME
PRESENTED=argouml-stats/www/$SHORTPRES

./build.sh clean
DO_ONE_TARGET javadocs 	reports/javadocs reports/javadocs-api
(
  cd $PRESENTED/javadocs-api &&
  COMMIT "Committing result from $JAVA_NAME javadocs-api"
)

./build.sh clean
DO_ONE_TARGET release           reports/release
DO_ONE_TARGET checkstyle	reports/checkstyle
DO_ONE_TARGET junit		reports/junit
DO_ONE_TARGET cpp-junit		reports/cpp-junit
DO_ONE_TARGET coverage          reports/coverage
(
  cd $PRESENTED/coverage/coverage &&
  COMMIT "Committing extra split coverage"
)
(
  cd $PRESENTED/coverage/junit &&
  COMMIT "Committing extra split coverage"
)
(
  cd $PRESENTED/coverage &&
  COMMIT "Committing extra coverage"
)

./build.sh clean


# Building documentation
PRESENTED=argouml-stats/www

SHORTPRES=daily-userdoc
DO_ONE_TARGET daily-userdoc daily-userdoc/en daily-userdoc/de daily-userdoc/es

SHORTPRES=documentation
# Cookbook
DO_ONE_TARGET documentation documentation/defaulthtml documentation/printablehtml documentation/pdf

./create-index.sh > argouml-stats/www/index.html
(
  cd argouml-stats/www
  svn status |
  awk '/^[AM]/ { print $2; }' |
  xargs -L 10 svn commit -m"Committing all the rest"
)

echo Any files left:
(
  cd argouml-stats/www &&
  svn status
)
