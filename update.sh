#!/bin/sh

set -- `getopt misw: "$@"`
MIRRORED=false
INITIALIZE=false
SYNCHRONIZE=false
WHERE=tmp
while true
do
  case "$1" in
  -m)
    MIRRORED=true
    shift
    ;;
  -i)
    INITIALIZE=true
    shift
    ;;
  -s)
    SYNCHRONIZE=true
    shift
    ;;
  -w)
    shift
    WHERE="$1"
    shift
    ;;
  --)
    shift
    break
    ;;
  *)
    echo $0: Invalid argument $o 1>&2
    exit 1
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
      echo $(date): creating mirror for $proj...
      mkdir -p $DIR
      (
        cd $DIR
        svnadmin create $proj
        PRERPC=$proj/hooks/pre-revprop-change
        echo "#!/bin/sh" > $PRERPC
        echo exit 0 >> $PRERPC
        chmod +x $PRERPC
      )
      svnsync --non-interactive --no-auth-cache initialize $ROOT/$PROJMIDDLE http://$PROJMIDDLE --username guest --password ""
      echo $(date): creating mirror for $proj...done
    fi

    if $SYNCHRONIZE
    then
      echo $(date): synchronize $proj...
      svnsync --non-interactive --no-auth-cache synchronize $ROOT/$PROJMIDDLE --username guest --password ""
      echo $(date): synchronize $proj...done
    fi
  done

  if $INITIALIZE || $SYNCHRONIZE
  then
    exit 0;
  fi
fi

(
  if [ ! -d $WHERE ]
  then
    mkdir $WHERE
  fi
  cd $WHERE
  for proj in $PROJECTS
  do
    echo $(date): checking out $proj...
    svn co $ROOT/$proj.tigris.org/svn/$proj/trunk $proj --username=guest --password=''
    echo $(date): checking out $proj...done
  done
)
