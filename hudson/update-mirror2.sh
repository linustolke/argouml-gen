#!/bin/sh
URLS="file://$HOME/REPOS/argoeclipse.tigris.org/svn/argoeclipse \
      file://$HOME/REPOS/argouml-stats.tigris.org/svn/argouml-stats"

RET_VAL=0
for url in $URLS
do
  echo $(date): synchronize $url...
  if svnsync --non-interactive --no-auth-cache synchronize $url \
      --username guest --password ""
  then
    echo $(date): synchronize $url...done
  else
    RET_VAL=2
    echo $(date): synchronize $url...failed
  fi
done

exit $RET_VAL;
