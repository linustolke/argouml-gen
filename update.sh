#!/bin/sh

PROJECTS="argouml \
              argouml-cpp \
              argouml-de argouml-en-gb argouml-es \
              argouml-fr \
              argouml-i18n-zh argouml-it argouml-nb \
              argouml-pt \
              argouml-ro argouml-ru \
	      argouml-sv"

(
  cd tmp
  for proj in $PROJECTS
  do
    time svn co http://$proj.tigris.org/svn/$proj/trunk $proj
  done
)

