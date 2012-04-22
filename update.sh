#!/bin/sh

set -- `getopt migsw: "$@"`
MIRRORED=false
INITIALIZE=false
SYNCHRONIZE=false
GITREPOS=false
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
  -g)
    GITREPOS=true
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
              argoeclipse \
              argouml-documentation \
	      argouml-gen"


ROOT=http:/
export ROOT
RET_VAL=0

if $MIRRORED
then
  ROOT=file://$HOME/REPOS
  export ROOT

  GITDIR=$HOME/GITREPOS
  if $GITREPOS && test ! -d $GITDIR
  then
    mkdir $GITDIR
  fi

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
      if svnsync --non-interactive --no-auth-cache \
          initialize $ROOT/$PROJMIDDLE http://$PROJMIDDLE \
          --username guest --password ""
      then
        echo $(date): creating mirror for $proj...done
      else
        RET_VAL=3
        echo $(date): creating mirror for $proj...failed
      fi
    fi

    if $INITIALIZE && $GITREPOS && test ! -d $GITDIR/$proj.git
    then
      (
	cd $GITDIR
        git svn init -s $ROOT/$PROJMIDDLE $proj.git </dev/null
	touch $proj.git/.git/git-daemon-export-ok
      )
      echo $(date): creating git repos for $proj...done
    fi

    if $SYNCHRONIZE
    then
      echo $(date): synchronize $proj...
      if svnsync --non-interactive --no-auth-cache \
          synchronize $ROOT/$PROJMIDDLE \
          --username guest --password ""
      then
        if $GITREPOS
        then
          echo $(date): synchronize git repo for $proj...
	  (
	    cd $GITDIR/$proj.git
            git svn fetch </dev/null
	  )
        fi
        echo $(date): synchronize $proj...done
      else
        RET_VAL=2
        echo $(date): synchronize $proj...failed
      fi
    fi
  done

  if $INITIALIZE || $SYNCHRONIZE
  then
    exit $RET_VAL;
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
    if svn co $ROOT/$proj.tigris.org/svn/$proj/trunk $proj \
        --username=guest --password=''
    then
      echo $(date): checking out $proj...done
    else
      RET_VAL=1    
      echo $(date): checking out $proj...done
    fi
  done
  exit $RET_VAL
)
