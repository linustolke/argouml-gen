#!/bin/sh

set -- `getopt mis "$@"`
MIRRORED=false
INITIALIZE=false
SYNCHRONIZE=false
for o
do
  case $o in
  -m)
    MIRRORED=true
    ;;
  -i)
    INITIALIZE=true
    ;;
  -s)
    SYNCHRONIZE=true
    ;;
  --)
    ;;
  *)
    echo $0: Invalid argument $o 1>&2
    ;;
  esac
done

# This is a list of all project for which we do nightly things:
PROJECTS="argouml \
              argouml-andromda \
              argouml-actionscript3 \
              argouml-ada \
              argouml-atl \
              argouml-cpp \
              argouml-csharp \
              argouml-db \
              argouml-delphi \
              argouml-graphviz \
              argouml-idl \
              argouml-java \
              argouml-javascript \
              argouml-pattern-wizard \
              argouml-php \
              argouml-python \
              argouml-ruby \
              argouml-sql \
              \
              argouml-ca \
              argouml-de argouml-en-gb argouml-es \
              argouml-fr \
              argouml-hi \
              argouml-i18n-zh argouml-it \
              argouml-ja \
              argouml-nb \
              argouml-pt argouml-pt-br \
              argouml-ro argouml-ru \
	      argouml-sv \
	      argouml-tr \
              \
              argoprint \
              argopdf \
              argouml-documentation \
	      argouml-gen"


ROOT=http:/
export ROOT

if $MIRRORED
then
  ROOT=file://$HOME/REPOS
  export ROOT

  for proj in $PROJECTS
  do
    MIDDLE=$proj.tigris.org/svn
    PROJMIDDLE=$MIDDLE/$proj
    DIR=$HOME/REPOS/$MIDDLE

    if $INITIALIZE && test ! -d $DIR
    then
      echo creating mirror for $proj...
      mkdir -p $DIR
      (
        cd $DIR
        svnadmin create $proj
        PRERPC=$proj/hooks/pre-revprop-change
        echo "#!/bin/sh" > $PRERPC
        echo exit 0 >> $PRERPC
        chmod +x $PRERPC
      )
      svnsync initialize $ROOT/$PROJMIDDLE http://$PROJMIDDLE --username guest --password ""
      echo creating mirror for $proj...done
    fi

    if $SYNCHRONIZE
    then
      echo synchronize $proj...
      svnsync synchronize $ROOT/$PROJMIDDLE --username guest --password ""
      echo synchronize $proj...done
    fi
  done

  if $INITIALIZE || $SYNCHRONIZE
  then
    exit 0;
  fi
fi

(
  if [ ! -d tmp ]
  then
    mkdir tmp
  fi
  cd tmp
  for proj in $PROJECTS
  do
    echo checking out $proj
    svn co $ROOT/$proj.tigris.org/svn/$proj/trunk $proj --username=guest --password=''
  done
)
