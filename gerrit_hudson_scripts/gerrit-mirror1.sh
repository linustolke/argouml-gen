#!/bin/sh -x

# Script to mirror between gerrit and the argouml subversion repositories.
#
# Assumptions:
# Run by the gerrit user.
# Submits to subversion are done with the given user id (SVN_USERNAME)
#
# * To set up *
# As the gerrit user:
# $ <SCRIPT_LOCATION>/gerrit-mirror1.sh -p
# <enter password for the SVN_USER in each of the projects upon request 
# and allow them to be stored by subversion>
# $ cd <.../site>/git
# $ <SCRIPT_LOCATION>/gerrit-mirror1.sh -i
#
# * Run regularly *
# As the gerrit user:
# $ cd <.../site>/git
# $ <SCRIPT_LOCATION>/gerrit-mirror1.sh
SVN_USER=closettop_nightlybuild

# The list of projects to include
# TODO: This is sofar only some of the "small" projects.
PROJECTS="\
              argouml \
              \
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
              argoprint \
              argopdf \
              argouml-documentation \
	      "

set -- `getopt ip "$@"`
INITIALIZE=false
STORE_PASSWORDS=false
while true
do
  case "$1" in
  -i)
    INITIALIZE=true
    shift
    ;;
  -p)
    STORE_PASSWORDS=true
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

if $STORE_PASSWORDS
then
  for proj in $PROJECTS
  do
    svn log http://$proj.tigris.org/svn/$proj --limit=1 \
      --username=$SVN_USER
  done
  exit 0
fi

if $INITIALIZE
then
  for proj in $PROJECTS
  do
    if test ! -d $proj
    then
      git svn init \
	  --trunk=trunk \
          --tags=tags \
          --branches=branches --branches=releases \
	  http://$proj.tigris.org/svn/$proj $proj \
	  --username=$SVN_USER
      (
        cd $proj
        # Do all the fetching
        git svn fetch --username=$SVN_USER
        git branch -m master trunk
        touch .git/git-daemon-export-ok
      )
    fi
  done
  echo Initialization done.
  exit 0;
fi

for proj in $PROJECTS
do
  if test -d $proj
  then
    (
      cd $proj
      git checkout -f trunk
      git svn rebase --username=$SVN_USER
      git svn dcommit --username=$SVN_USER
      git branch -D master 2>/dev/null || true
    )
  else
    echo No directory for $proj
  fi
done
