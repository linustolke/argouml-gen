#!/bin/sh

# This is a list of all project for which we do nightly things:
PROJECTS="argouml \
              argoeclipse \
              argouml-andromda \
              argouml-classfile \
              argouml-cpp \
              argouml-csharp \
              argouml-db \
              argouml-graphviz \
              argouml-idl \
              argouml-java \
              argouml-php \
              argouml-python \
              argouml-sql \
              \
              argouml-documentation \
              \
              argouml-de argouml-en-gb argouml-es \
              argouml-fr \
              argouml-i18n-zh argouml-it argouml-nb \
              argouml-pt argouml-pt-br \
              argouml-ro argouml-ru \
	      argouml-sv
              \
              argoprint \
              argopdf"


(
  if [ ! -d tmp ]
  then
    mkdir tmp
  fi
  cd tmp
  for proj in $PROJECTS
  do
    echo checking out $proj
    svn co http://$proj.tigris.org/svn/$proj/trunk $proj --username=guest --password=''
  done
)
