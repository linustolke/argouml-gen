#!/bin/sh
URLS="file:///home2/argonightly/REPOS/argoeclipse.tigris.org/svn/argoeclipse \
      file:///home2/argonightly/REPOS/argouml-stats.tigris.org/svn/argouml-stats"
for url in $URLS
do
  svnsync --non-interactive --no-auth-cache synchronize $url \
      --username guest --password ""
done

