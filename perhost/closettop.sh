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

PROJECTS="argouml \
              argouml-cpp \
              argouml-de argouml-en-gb argouml-es \
              argouml-fr \
              argouml-i18n-zh argouml-it argouml-nb \
              argouml-pt
              argouml-ru argouml-sv"

(
  cd tmp
  for proj in $PROJECTS
  do
    svn co http://$proj.tigris.org/svn/$proj/trunk $proj
  done
)

REVISIONS=`
(
  cd tmp
  for proj in $PROJECTS
  do
    (
      cd $proj &&
        svn info | awk '/^Revision:/ { printf "%s:%s ", proj, $2; }' proj=$proj
    )
  done
)`


( cd argouml-stats && svn update ) || exit 1

PRESENTED=argouml-stats/www/reports

statusfile=$PRESENTED/jcoverage/status.txt
rm $statusfile
if ./build.sh report:jcoverage -l $PRESENTED/jcoverage/output.txt
then
  ./copy-add.sh reports reports/jcoverage reports/junit-result-jcoverage
  echo Succeeded at `date +"%b %d %H:%M"` > $statusfile
else
  echo Failed at `date +"%b %d %H:%M"` > $statusfile
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
else
  echo Failed at `date +"%b %d %H:%M"` > $statusfile
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
else
  echo Failed at `date +"%b %d %H:%M"` > $statusfile
fi
(
  cd argouml-stats/www/reports &&
  time svn commit -m"Commiting result from report:javadocs for $REVISIONS"
)

./build.sh report:checkstyle &&
  ./copy-add.sh reports reports/checkstyle

./build.sh report:findbugs &&
  ./copy-add.sh reports reports/findbugs

./build.sh report:i18ncomparison &&
  ./copy-add.sh reports reports/i18ncomparison
(
  cd argouml-stats/www/reports &&
  time svn commit -m"Commiting result from 
report:checkstyle,
report:findbugs, and 
report:i18ncomparison
for $REVISIONS"
)

./build.sh update-documentation || exit 1

if ./build.sh report:documentation -l argouml-stats/www/documentation/output.txt
then
  ./copy-add.sh documentation documentation/defaulthtml documentation/printablehtml documentation/pdf
fi
(
  cd argouml-stats/www/documentation &&
  time svn commit -m"Commiting result from report:documentation for $REVISIONS"
)

./create-index.sh > argouml-stats/www/index.html
(
  cd argouml-stats/www &&
  time svn commit -m"Commiting all the rest for $REVISIONS"
)
