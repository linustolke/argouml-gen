#!/bin/sh -x
# $Id$

# This is the script that is run by crontab on Linus' Linux host closettop

if test ! -f build-reports.xml
then
    echo You need to start from the right directory.
fi

JAVA_HOME=/usr/local/lib/java/j2sdk1.4.2_10
export JAVA_HOME

./build.sh clean || exit 1
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


( cd argouml-stats && time svn update ) || exit 1

PRESENTED=argouml-stats/www/reports
LOG=argouml-stats/www/closettop.log


# Starting the reports.

statusfile=$PRESENTED/cpp-junit/status.txt
rm $statusfile
if ./build.sh report:cpp-junit -l $PRESENTED/cpp-junit/output.txt
then
  ./copy-add.sh reports reports/cpp-junit
  echo Succeeded at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: java1.4 cpp-junit succeeded  >> $LOG
else
  echo Failed at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: java1.4 cpp-junit FAILED >> $LOG
fi
(
  cd argouml-stats/www/reports &&
  time svn commit -m"Commiting result from report:cpp-junit for $REVISIONS"
)


statusfile=$PRESENTED/jcoverage/status.txt
rm $statusfile
if ./build.sh report:jcoverage -l $PRESENTED/jcoverage/output.txt
then
  ./copy-add.sh reports reports/jcoverage reports/junit-result-jcoverage
  echo Succeeded at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: java1.4 jcoverage succeeded  >> $LOG
else
  echo Failed at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: java1.4 jcoverage FAILED >> $LOG
fi
(
  cd argouml-stats/www/reports &&
  time svn commit -m"Commiting result from report:jcoverage for $REVISIONS"
)

statusfile=$PRESENTED/jdepend/status.txt
rm $statusfile
if ./build.sh report:jdepend -l $PRESENTED/jdepend/output.txt
then
  ./copy-add.sh reports reports/jdepend
  echo Succeeded at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: java1.4 jdepend updated >> $LOG
else
  echo Failed at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: java1.4 jdepend FAILED >> $LOG
fi
(
  cd argouml-stats/www/reports &&
  time svn commit -m"Commiting result from report:jdepend for $REVISIONS"
)

statusfile=$PRESENTED/javadocs/status.txt
rm $statusfile
if ./build.sh report:javadocs -l $PRESENTED/javadocs/output.txt
then
  ./copy-add.sh reports reports/javadocs reports/javadocs-api
  echo Succeeded at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: java1.4 javadocs built >> $LOG
else
  echo Failed at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: java1.4 javadocs FAILED >> $LOG
fi
(
  cd argouml-stats/www/reports &&
  time svn commit -m"Commiting result from report:javadocs for $REVISIONS"
)

if ./build.sh report:checkstyle
then
  ./copy-add.sh reports reports/checkstyle
  echo `date +"%b %d %H:%M"`: java1.4 checkstyle updated >> $LOG
else
  echo `date +"%b %d %H:%M"`: java1.4 checkstyle FAILED >> $LOG
fi

if ./build.sh report:findbugs
then
  ./copy-add.sh reports reports/findbugs
  echo `date +"%b %d %H:%M"`: java1.4 findbugs updated >> $LOG
else
  echo `date +"%b %d %H:%M"`: java1.4 findbugs FAILED >> $LOG
fi

if ./build.sh report:i18ncomparison
then
  ./copy-add.sh reports reports/i18ncomparison
  echo `date +"%b %d %H:%M"`: java1.4 i18ncomparison updated >> $LOG
else
  echo `date +"%b %d %H:%M"`: java1.4 i18ncomparison FAILED >> $LOG
fi

(
  cd argouml-stats/www/reports &&
  time svn commit -m"Commiting result from report:checkstyle, report:findbugs, and report:i18ncomparison for $REVISIONS"
)

if ./build.sh report:documentation -l argouml-stats/www/documentation/output.txt
then
  ./copy-add.sh documentation documentation/defaulthtml documentation/printablehtml documentation/pdf
  echo `date +"%b %d %H:%M"`: java1.4 documentation built >> $LOG
else
  echo `date +"%b %d %H:%M"`: java1.4 documentation FAILED >> $LOG
fi
(
  cd argouml-stats/www/documentation &&
  time svn commit -m"Commiting result from report:documentation for $REVISIONS"
)



# Do things for java5.

JAVA_HOME=/usr/local/lib/java/jdk1.5.0_06
export JAVA_HOME

./build.sh clean || exit 1

PRESENTED=argouml-stats/www/reports-java5

statusfile=$PRESENTED/junit/status.txt
rm $statusfile
if ./build.sh report:junit -l $PRESENTED/junit/output.txt
then
  ./copy-add.sh reports-java5 reports/junit
  echo Succeeded at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: java5 junit-tests succeeded >> $LOG
else
  echo Failed at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: java5 junit-tests FAILED >> $LOG
fi
(
  cd argouml-stats/www/reports-java5 &&
  time svn commit -m"Commiting java5 result from report:junit for $REVISIONS"
)

statusfile=$PRESENTED/cpp-junit/status.txt
rm $statusfile
if ./build.sh report:cpp-junit -l $PRESENTED/cpp-junit/output.txt
then
  ./copy-add.sh reports-java5 reports/cpp-junit
  echo Succeeded at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: java5 cpp-junit succeeded  >> $LOG
else
  echo Failed at `date +"%b %d %H:%M"` > $statusfile
  echo `date +"%b %d %H:%M"`: java5 cpp-junit FAILED >> $LOG
fi
(
  cd argouml-stats/www/reports-java5 &&
  time svn commit -m"Commiting java5 result from report:cpp-junit for $REVISIONS"
)



./create-index.sh > argouml-stats/www/index.html
(
  cd argouml-stats/www &&
  time svn commit -m"Commiting all the rest for $REVISIONS"
)
