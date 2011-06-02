#!/bin/sh
URLS="file://$HOME/REPOS/argoeclipse.tigris.org/svn/argoeclipse \
      file://$HOME/REPOS/argouml-stats.tigris.org/svn/argouml-stats"
for url in $URLS
do
  svnsync --non-interactive --no-auth-cache synchronize $url \
      --username guest --password ""
done

exit 0;
