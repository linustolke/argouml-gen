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

(
  cd argouml-stats &&
  if svn update
  then
      : ok
  else
      : try again
      sleep 10
      svn update
  fi
) || exit 1

LOG=argouml-stats/www/closettop.log

function COMMIT() {
  message=$1
  if svn commit -m"$message
Corresponding to $REVISIONS."
  then
    : ok
  else
    : try again
    sleep 30
    svn commit -m"$message
Corresponding to $REVISIONS.
Second attempt to commit." ||
      echo ERROR: $(date): Two commit attempts failed in $(pwd) with message $message. Giving up.
  fi
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
        COMMIT "Committing result for $JAVA_NAME $target from $arg"
      )
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
PRESENTED=argouml-stats/www/reports-$JAVA_NAME

./build.sh clean
DO_ONE_TARGET javadocs 	reports/javadocs reports/javadocs-api

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

./create-index.sh > argouml-stats/www/index.html

(
  echo $(date): Committing all the rest...
  cd argouml-stats/www
  svn commit -m"Committing all the rest"
  echo $(date): Committing all the rest...done
)

(
  echo $(date): Committing all the rest in chunks of 100 files...
  cd argouml-stats/www
  svn update
  svn status |
  awk '/^[AM]/ { print $2; }' |
  xargs -L 100 --no-run-if-empty \
      svn commit -m"Committing all the rest (in chunks of 100 files)"
  echo $(date): Committing all the rest in chunks of 100 files...done
)

(
  echo $(date): Committing all the rest in chunks of 10 files...
  cd argouml-stats/www
  svn update
  svn status |
  awk '/^[AM]/ { print $2; }' |
  xargs -L 10 --no-run-if-empty \
      svn commit -m"Committing all the rest (in chunks of ten files)"
  echo $(date): Committing all the rest in chunks of 10 files...done
)

(
  echo $(date): Committing all the rest files one by one...
  cd argouml-stats/www
  svn update
  svn status |
  awk '/^[AM]/ { print $2; }' |
  xargs -L 1 --no-run-if-empty \
      svn commit -m"Committing all the rest (files one by one)"
  echo $(date): Committing all the rest files one by one...done
)

(
  echo $(date): Any files left...
  cd argouml-stats/www &&
  svn status
  echo $(date): Any files left...done
)
