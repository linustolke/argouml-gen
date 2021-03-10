#!/usr/bin/env bash

sudo diff -ru \
     --exclude=branches \
     --exclude=compare-github-gerrithub \
     --exclude=computation \
     --exclude=indexing \
     --exclude=jobs \
     --exclude=compare.sh \
     --exclude=config.xml.~*~ \
     --exclude=jobs.yml \
     --exclude=state.xml \
     /vagrant/provisioning/jenkins-jobs /var/lib/jenkins/jobs
