# Configuration for the parentpom job

The purpose of this configuration is to build parentpom and then
everything that depends on parentpom, run the tests, and post the
result back to gerrit.

## How the Jenkins server is set up
(Same as for the gerrit job)

The following modules are needed in Jenkins:
- Docker Pipeline `docker-workflow`
- Docker Commons Plugin `docker-commons`
- Gerrit Trigger `gerrit-trigger`
- Pipeline Maven Integration `pipeline-maven`
- Remote Jenkinsfile Plugin `remote-file`

## Credentials in Jenkins
(Same as for the gerrit job)

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
