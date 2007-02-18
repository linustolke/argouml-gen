#!/bin/sh -x
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



# Do things for java5.

JAVA_HOME=/usr/local/lib/java/jdk1.5.0_06
export JAVA_HOME
JAVA_NAME=java5
PRESENTED=argouml-stats/www/reports-$JAVA_NAME


# Starting the reports.

./build.sh clean || exit 1

statusfile=$PRESENTED/jdepend/status.txt
LABEL="$JAVA_NAME report:jdepend"
rm $statusfile
if ./build.sh report:jdepend -l $PRESENTED/jdepend/output.txt
then
  ./copy-add.sh reports-java5 reports/jdepend
  echo Succeeded at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: $LABEL updated >> $LOG
else
  echo Failed at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: $LABEL FAILED >> $LOG
fi
(
  cd argouml-stats/www/reports-java5 &&
  svn commit -m"Committing result from $LABEL for $REVISIONS"
)


statusfile=$PRESENTED/javadocs/status.txt
LABEL="$JAVA_NAME report:javadocs"
rm $statusfile
if ./build.sh report:javadocs -l $PRESENTED/javadocs/output.txt
then
  ./copy-add.sh reports-java5 reports/javadocs reports/javadocs-api
  echo Succeeded at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: $LABEL built >> $LOG
else
  echo Failed at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: $LABEL FAILED >> $LOG
fi
(
  cd argouml-stats/www/reports &&
  svn commit -m"Committing result from $LABEL for $REVISIONS"
)

LABEL="$JAVA_NAME report:findbugs"
if ./build.sh report:findbugs
then
  ./copy-add.sh reports-java5 reports/findbugs
  echo `date +"%b %d %H:%M"`: $LABEL updated >> $LOG
else
  echo `date +"%b %d %H:%M"`: $LABEL FAILED >> $LOG
fi

LABEL="$JAVA_NAME report:i18ncomparison"
if ./build.sh report:i18ncomparison
then
  ./copy-add.sh reports-java5 reports/i18ncomparison
  echo `date +"%b %d %H:%M"`: $LABEL updated >> $LOG
else
  echo `date +"%b %d %H:%M"`: $LABEL FAILED >> $LOG
fi

./build.sh clean || exit 1

LABEL="$JAVA_NAME report:checkstyle"
if ./build.sh report:checkstyle
then
  ./copy-add.sh reports-java5 reports/checkstyle
  echo `date +"%b %d %H:%M"`: $LABEL updated >> $LOG
else
  echo `date +"%b %d %H:%M"`: $LABEL FAILED >> $LOG
fi
(
  cd argouml-stats/www/reports-java5 &&
  svn commit -m"Committing result from report:checkstyle, report:findbugs, and report:i18ncomparison, java5, for $REVISIONS"
)

LABEL="$JAVA_NAME report:documentation"
if ./build.sh report:documentation -l argouml-stats/www/documentation/output.txt
then
  ./copy-add.sh documentation documentation/defaulthtml documentation/printablehtml documentation/pdf
  echo `date +"%b %d %H:%M"`: $LABEL built >> $LOG
else
  echo `date +"%b %d %H:%M"`: $LABEL FAILED >> $LOG
fi
(
  cd argouml-stats/www/documentation &&
  svn commit -m"Committing result from $LABEL for $REVISIONS"
)

LABEL="$JAVA_NAME report:documentation-es"
if ./build.sh report:documentation-es -l argouml-stats/www/documentation-es/output.txt
then
  ./copy-add.sh documentation-es documentation-es/defaulthtml documentation-es/printablehtml documentation-es/pdf
  echo `date +"%b %d %H:%M"`: $LABEL built >> $LOG
else
  echo `date +"%b %d %H:%M"`: $LABEL FAILED >> $LOG
fi
(
  cd argouml-stats/www/documentation-es &&
  svn commit -m"Committing result from $LABEL for $REVISIONS"
)



statusfile=$PRESENTED/junit/status.txt
LABEL="$JAVA_NAME report:junit"
rm $statusfile
if ./build.sh report:junit -l $PRESENTED/junit/output.txt
then
  ./copy-add.sh reports-java5 reports/junit
  echo Succeeded at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: $LABEL succeeded >> $LOG
else
  echo Failed at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: $LABEL FAILED >> $LOG
fi
(
  cd argouml-stats/www/reports-java5 &&
  svn commit -m"Committing result from $LABEL for $REVISIONS"
)

statusfile=$PRESENTED/cpp-junit/status.txt
LABEL="$JAVA_NAME report:cpp-junit"
rm $statusfile
if ./build.sh report:cpp-junit -l $PRESENTED/cpp-junit/output.txt
then
  ./copy-add.sh reports-java5 reports/cpp-junit
  echo Succeeded at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: $LABEL succeeded  >> $LOG
else
  echo Failed at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: $LABEL FAILED >> $LOG
fi
(
  cd argouml-stats/www/reports-java5 &&
  svn commit -m"Committing result from $LABEL for $REVISIONS"
)



./create-index.sh > argouml-stats/www/index.html
(
  cd argouml-stats/www &&
  svn commit -m"Committing all the rest for $REVISIONS"
)
