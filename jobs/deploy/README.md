# Configure Jenkins to run the deploy job

The purpose of the deploy job is twofold:
- Keep an updated snapshot of master published at a public maven repository
- Keep the gh-pages updated at github to reflect the current information
  of each project.

## How the Jenkins server is set up

Scripted user for Github: This is used to access github the github-organization jobs.
- Kind: Username with password
- Scope: Global
- Username: the user name of the github user that is member of the acting-from-scripts group (secret) on github.
- Password: Fine-grained token with Repository permissions:
  - Read access to metadata
  - Read and write access to code.
  - No Repository access.
  - No User permissions.
- ID: github
- Description as above.

Add a Maven settings file with ID: github. Add the Server Credentials
for Scripted user for Github with ServerId github.

Credentials for sonatype. This is used to upload the snapshots to oss.sonatype.org.
- Kind: Username with password
- Scope: Global
- Username: the name generated from the oss.sonatype.org Maven central repository.
- Password: the password generated from the oss.sonatype.org Maven central repository.
- ID: sonatype-nexus-snapshots

Add a Maven settings file with ID: sonatype. Add the Server Credentials for the Credentials for sonatype with the ServerId sonatype-nexus-snapshots.
