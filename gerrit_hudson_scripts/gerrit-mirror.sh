#!/bin/sh

# Script to mirror between gerrit and the argouml subversion repositories.
#
# Assumptions:
# Runs from within Jenkins
# Submits to subversion are done with the given user id (SVN_USERNAME)
# 
SVN_USER=closettop_nightlybuild

# The list of projects to include
# TODO: This is sofar only some of the "small" projects.
PROJECTS=" \
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
         "

set -- `getopt ipc: "$@"`
INITIALIZE=false
STORE_PASSWORDS=false
CLONE_FROM_DIR=false
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
  -c)
    shift
    CLONE_FROM_DIR=true
    CLONE_DIR="$1"
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

if $CLONE_FROM_DIR
then
  for d in $CLONE_DIR/*
  do
    git clone --bare $d `basename $d`
  done
  exit 0
fi

GITGERRITREPOS=$HOME/GITGERRITREPOS

if $INITIALIZE
then
  if test ! -d $GITGERRITREPOS
  then
    mkdir $GITGERRITREPOS
  fi
  cd $GITGERRITREPOS
  for proj in $PROJECTS
  do
    if test ! -d $proj
    then
      git svn init -s \
	  http://$proj.tigris.org/svn/$proj $proj \
	  --username=$SVN_USER
      (
        cd $proj
        touch .git/git-daemon-export-ok
        # Add gerrit as a remote
        git remote add gerrit ssh://localhost:29418/$proj
        git checkout -b trunk gerrit/trunk
      )
    fi
  done
fi

# Update and upload
cd $GITGERRITREPOS
for proj in $PROJECTS
do
  (
    cd $proj
    git checkout gerrit/master
    git fetch gerrit
    git svn fetch --username=$SVN_USER
    git rebase remotes/trunk
    git svn dcommit --username=$SVN_USER
  )
done

