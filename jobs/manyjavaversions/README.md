# Configure Jenkins to run the matrix job

The purpose of this is to compile everything and run the tests with
many different jvms.  The Jenkinsfile contains a matrix of java
versions and compilesource.

## How the Jenkins job is set up

- An Organization Folder job

- Fetching organization from https://api.github.com, owner
  argouml-tigris-org, with settings:
  - Discover branches: Exclude branches that are also filed as PRs.
  - Filter by name master
  - Wipe out repository & force clone, to avoid gnutls_handshape()
    problem.

- Remote Jenkinsfile Provider plugin:
  - Local Marker pom.xml
  - Script Path: jobs/manyjavaversions/Jenkinsfile
  - Git repo argouml-gen and branch

- Property strategy: All branches get the same properties

- Build whenever a SNAPSHOT depdendency is built (not working)

- Periodically if not otherwise run 1 day

- Orphaned Item Strategy: Discard old items


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
