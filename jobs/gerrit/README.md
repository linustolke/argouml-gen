# Configure Jenkins to run the gerrit jobs

The purpose of this configuration is to build each change posted to
gerrit, run the tests, and post the result back to gerrit.

The gerrit instance used is gerrithub.io.

## How the Jenkins server is set up

The following modules are needed in Jenkins:
- Docker Pipeline `docker-workflow`
- Docker Commons Plugin `docker-commons`
- Gerrit Code Review `gerrit-code-review`
- Pipeline Maven Integration `pipeline-maven`
- Remote Jenkinsfile Plugin `remote-file`

## Credentials in Jenkins

In the Store scoped to Jenkins, in the Global credentials do Add
Credentials with the following:
- Gerrithub User for Verification:
  This is used by the gerritReview command to Verify a change.
  - Kind: Username with password
  - Scope: Global
  - Username: the user name of the github user that is member of the ArgoUML-verifiers group on gerrithub. 
  - Password: The HTTP Credentials of the user on gerrithub.
  - ID: gerrithub-user
  - Description as above.
