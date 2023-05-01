# Create docker images that have the necessary tools

The available maven images are very sparse in their contents.  There
is also some differences between them.

For some reason, git is needed in the docker image together with
maven.  This is available for some of the prepared maven images but
not all.

This directory is a job that creates new docker images that provide
all the tools needed to run the jobs defined by the Jenkinsfiles in
perhost/desktop.

The maven directory is based on images that comes with maven.
