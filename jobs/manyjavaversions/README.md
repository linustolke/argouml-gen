# Configure Jenkins to run the matrix job

The purpose of this is to compile everything and run the tests with
many different jvms.  The Jenkinsfile contains a matrix of java
versions and compilesource.

## How the Jenkins server is set up

Scripted user for Github: This is used to access github the github-organization jobs.
- Kind: Username with password
- Scope: Global
- Username: the user name of the github user that is member of the acting-from-scripts group (secret) on github.
- Password: Fine-grained token with Repository permissions:
  - Read access to metadata
  - Read access to code.
  - No Repository access.
  - No User permissions.
- ID: github
- Description as above.

Add a Maven settings file with ID: github. Add the Server Credentials
for Scripted user for Github with ServerId github.
