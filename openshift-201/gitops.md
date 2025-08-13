# Introduction to Argo CD for GitOps

## Table of Contents
- [Objectives](#objectives)
- [Prerequisites](#prerequisites)
- [Introduction](#introduction)
- [Integration with the Private Cloud](#integration-with-the-private-cloud)
- [Tasks](#tasks)
  - [Log in to GitHub](#log-in-to-github)
  - [Getting started](#getting-started)
  - [Review your Argo CD project](#review-your-argo-cd-project)
  - [Initial setup of the Git repository](#initial-setup-of-the-git-repository)
  - [Create an Argo CD Application](#create-an-argo-cd-application)
  - [Explore the functionality of Argo CD Applications](#explore-the-functionality-of-argo-cd-applications)
  - [Auto-Sync](#auto-sync)
  - [Use a Helm chart](#use-a-helm-chart)
  - [Use Kustomize](#use-kustomize)
  - [Troubleshooting](#troubleshooting)
  - [Delete an Argo CD Application](#delete-an-argo-cd-application)
  - [App of apps](#app-of-apps)
  - [Optional task: JWT tokens and Argo CD CLI](#optional-task-jwt-tokens-and-argo-cd-cli)
- [History and Rollbacks](#history-and-rollbacks)
- [References](#references)

## Video walkthrough
A draft video walkthrough of this lab is [available here](https://youtu.be/lu8ODionthM), please share any feedback or inconsistencies with the instructions. 



## Objectives
After completing this section, you should have an understanding of GitOps and how to use Argo CD to manage your applications and other resources.

## Prerequisites
* The OpenShift `oc` CLI
* A GitHub account
* If you're doing this lesson outside of the OpenShift 201 training, you will need an OpenShift project set that is not already configured for GitOps.

## Introduction
**What is GitOps?**

To put it simply, GitOps means using a Git repository to manage your applications.

_GitOps is a declarative approach to infrastructure and application management where Git repositories contain the desired state of the system, and automated processes continuously reconcile the actual state to match the desired state._

Core principles include:
* **Declarative configuration:** System state is defined using declarative files (e.g., Kubernetes YAML, Helm charts).
* **Versioned and immutable storage:** Git holds the source of truth for your infrastructure and workloads.
* **Automatic reconciliation:** A GitOps agent (e.g., Argo CD, Flux) watches the Git repo and ensures the deployed environment matches what’s in Git.
* **Software agents:** No manual `kubectl apply`; the GitOps tool continuously enforces the desired state.

Benefits include:
* **Auditability:** Git history shows who changed what and when.
* **Rollbacks:** Revert to a known-good state by checking out an earlier commit.
* **Security:** Fewer people need direct access to production resources.
* **Automation:** Reduces human error by codifying deployments.

**What is Argo CD?**

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.  It processes plain YAML/JSON manifests, Kustomize applications, Helm charts, and more.

Argo CD automates the deployment of the desired application states in the specified target environments. Application deployments can track updates to branches, tags, or be pinned to a specific version of manifests at a Git commit.

Argo CD ensures that deployed resources match the declared state, including the creation, modification, and optionally deletion of resources.  Synchronization of resources can be automatic or manual.

## Integration with the Private Cloud
The Platform Services team maintains a dedicated instance of Argo CD for our users.

The Private Cloud clusters use a custom operator to create and manage resources related to project teams' usage of Argo CD.  When a user creates a `GitOpsTeam` resource, the operator automatically detects it and does all necessary setup, including the creation of a Git repository, configuration of repository access, creation of a project in Argo CD, and the creation of Keycloak groups used for controlling access to the project in the Argo CD UI.  In addition to automating the setup, the operator also ensures consistent configuration for all projects and enforces certain security constratints.  Users can modify the access rules for the Git repository and the Argo CD UI by editing their `GitOpsTeam`.

### Separate code and configuration repositories
It is considered a Best Practice to use separate Git repositories for your application code (the CI part of CI/CD) and deployment configuration (the CD part of CI/CD).  There are a number of reasons for this, such as:
* Keep commit histories separate.
* Avoid triggering unwanted automated workflows, like GitHub Actions, which could run new builds when you're just making a small change to a manifest.
* An application may span more than one repository; adding manifests to one of them may not make sense.
* Separate access controls.

Therefore, do not use your GitOps repository for your application code.

## Tasks

### Log in to GitHub
Log in to GitHub in order to access your new Git repository and the associated project in Argo CD.  Argo CD uses SSO and can be accessed by either GitHub IDs or IDIRs.  For the purposes of this exercise, we will use the GitHub ID for both.


### Getting started
The GitOpsTeam is your vehicle for GitOps configuration.  Start by downloading a copy of the [GitOpsTeam template](gitops_files/gitopsteam_template.yaml).

The GitOpsTeam defines the users that will have access to the GitOps repository (`gitOpsMembers`) and the users that will have access to the project in the Argo CD UI (`projectMembers`).  A GitOpsTeam must be created in the **tools namespace**.

* Open the file in your text editor of choice.  
* Set `/metadata/name` to your project license plate, such as abc123
* Set `/metadata/namespace` to your tools namespace, such as abc123-tools
* Add your GitHub ID in `/spec/gitOpsMembers/admins` as `yourID`
* Add your GitHub ID in `/spec/projectMembers/maintainers` as `yourID@github`
* If you have an IDIR account, add it in `/spec/projectMembers/maintainers` as your email address, such as `first.last@gov.bc.ca`
* Remove the sample user IDs (myGitHubID, seniorDev&#064;gov.bc.ca, etc.)
* Save the file and apply it
* **Note: we don't need to specify a namespace in the apply command, because we've already defined which namespace this template should be applied to in the template itself**
```
oc apply -f gitopsteam_template.yaml
```

**Note:** If you are not already a member of the 'bcgov-c' GitHub organization, you will be sent an email invitation to join it.  You will have to join the organization before you can access your repository.

**Pro Tip:** If you set an environment variable for your project's license plate, you will be able to copy and paste some of the commands below.

```
export LICENSEPLATE=abc123
```

Verify that you can access the [Argo CD UI](https://gitops-shared.apps.silver.devops.gov.bc.ca).  Unless you already have access from another project, there will be no apps listed.

### Review your Argo CD projects
There are two Argo CD projects associated with each GitOpsTeam.  The name of the first one is your license plate; this is the default project.  The second is named LICENSEPLATE-nonprod.  This project has access to your dev, test, and tools namespaces, but not prod.  If your organization limits access to production environments and you have developers that should only have access to non-prod resources, add them to the 'nonprod' list under 'projectMembers'.

Let's review some of the features of your default project.  In the Argo CD UI, click 'Settings' --> 'Projects' --> LICENSEPLATE

The **Source Repositories** section defines the URLs that can be used as a source for your apps.  Two of them are for your automatically-generated GitHub repository.  The "git@github" URL is an SSH-style URL.  We recommend that you use the HTTPS URL in your applications, as support for SSH key access may be deprecated at some point in the future.  The third URL in the list is for an Artifactory caching repository that allows you to access Helm chart repositories from Docker.  It allows you to access any Helm OCI charts that are available at `registry-1.docker.io`.

The **Source Namespaces** section defines the namespaces in which you can create Argo CD Applications.  When you create an application in the Argo CD UI, the Application resource is created in the Argo CD namespace, but the "apps in any namespace" feature allows you to create and manage Applications in your own namespace.  You can even create an Argo CD Application to manage your Applications!  We'll look at that in the section below titled "App of apps".

The **Destinations** section defines the namespaces in which you may have Argo CD manage resources.  This will be any of the four namespaces in your OpenShift project.

The resource allow and deny lists are there for general security.  For example, you cannot create new namespaces in OpenShift or modify your ResourceQuota.

Click 'Projects' again and click on your nonprod project.  Note that the Source Namespaces and Destinations lists include only the non-prod namespaces.  Additionally, the Namespace Resource Deny List includes `*/warden.devops.gov.bc.ca`; this prevents applications in the nonprod project from modifying the GitOpsTeam.

Click the 'Applications' link to return to the main view.


### Initial setup of the Git repository
Verify that you can access your new GitHub repository, which is called "tenant-gitops-LICENSEPLATE".
```
https://github.com/bcgov-c/tenant-gitops-${LICENSEPLATE}
```

The repository is empty, so you will now clone it and add some content.
```
git clone https://github.com/bcgov-c/tenant-gitops-${LICENSEPLATE}
cd tenant-gitops-${LICENSEPLATE}
```
Create a directory for your first app:
```
mkdir app1
```
Create a YAML manifest for a ConfigMap:
```
cat <<END > app1/configmap.app1.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app1
  namespace: ${LICENSEPLATE}-dev
data:
  foo: bar
END
```
Add the new directory and push it to your repository.
```
git add .
git commit -a -m "Initial repo setup"
git push origin
```

### Create an Argo CD Application
Use the [Argo CD UI](https://gitops-shared.apps.silver.devops.gov.bc.ca/) to create a new application that is configured for the directory that you created in your GitOps repository.
- Click the 'New App' button and enter the following information...
- General
    - Application Name: LICENSEPLATE-app1
    - Project Name: (select your project from dropdown)
- Source
    - Repository URL: `https://github.com/bcgov-c/tenant-gitops-LICENSEPLATE`
    - Path: app1
- Destination:
    - Cluster URL: `https://kubernetes.default.svc`
    - Namespace: LICENSEPLATE-dev
- Click 'Create'

Note that **Argo CD application names must be unique**, which is why we're putting the license plate in front of the name.

### Explore the functionality of Argo CD Applications
Click on your new app.  Just above the main pane, note the status boxes: App Health and Sync Status

Click on the 'Diff' button.  The right side of the window shows the desired state and the left side shows the actual state, which will be blank until you sync the app.

Click the 'X' button in the upper right corner to close the app details view.

Click the 'Sync' button.  You will be prompted for confirmation in the right sidebar.  Click 'Synchronize'.  You should see the App Health show as "Healthy", Sync Status as "Synced", and another field, Last Sync, showing as "Sync OK".  If not, click the 'Sync Status' button to see what the issue is. **Note: sync status can take a few minutes to fully update.*

In the OpenShift console, go to the ConfigMaps listing for your dev namespace.  You should see the 'app1' ConfigMap listed there.  Click on the ConfigMap to view it.

#### Update your app
Update the YAML manifest `configmap.app1.yaml` for the ConfigMap, adding another key/value pair.
```
  foo: bar
  boo: far
```
Save the file. Commit `git commit -a -m "keyvaluepair"`, and push to your GitHub repo `git push`. 

In the Argo CD UI, in the application view, the app should refresh automatically and the Sync Status should now show as "OutOfSync".

Click on the 'Diff' button.  The right side of the diff view shows the desired state and the left side shows the actual state.  For a cleaner view, check the "Compact diff" checkbox.

Close the diff view by clicking the 'X' in the upper right corner.

Sync the app, then look at the ConfigMap again in the OpenShift console.  You should now see both key/value pairs in the ConfigMap.

Delete the ConfigMap from the namespace and then return to the app view in the Argo CD UI.  It should again show as out of sync, but this time the 'app1' ConfigMap has a small yellow ghost icon on it to indicate that the resource is missing from the namespace.  Click 'Sync' again to recreate the ConfigMap.

### Auto-Sync
After initial setup, Argo CD applications are generally set to sync automatically, and this is what makes it a powerful tool.  Argo CD caches the manifests from the Git repository and rechecks every few minutes to see if the cache is still valid.  With auto-sync enabled, any change to the manifests in the Git repository will be automatically synced to your OpenShift namespace as soon as the change is detected.

Enable auto-sync in your app by clicking the 'Details' button.  In the Sync Policy section, click the 'Enable Auto-Sync' button.

After enabling auto-sync, you have the option to also enable pruning and self-healing.
* Pruning means that if a resource is managed by Argo CD, but is then removed from the GitOps repository, Argo CD will delete the resource from the namespace.  This is usually a good option, but you may want to leave it disabled in certain cases.
* Self-Heal means that if the resource is updated directly in OpenShift, Argo CD will change it back to match the desired state from the GitOps repository. This is also usually a good option.
* When making sensitive changes, such as major upgrades, you may want to disable auto-sync until the process is complete so that you can carefully control the sequence of changes or to temporarily change the configuration.

#### GitHub webhook
By default, Argo CD checks its cache against the gitops repository every three minutes, though it can take longer.  In order to eliminate the waiting period for the refresh, a webhook has been configured in the gitops repository so that Argo CD will immediately refresh any apps that have that repo as a source.

For reference, if you find yourself using a repository that does not already have a webhook configured, it can be added by a repo admin as follows:

In the GitHub UI for your repository, click 'Settings' --> 'Webhooks' --> 'Add webhook'

Enter the following information:
* Payload URL: `https://gitops-shared.apps.silver.devops.gov.bc.ca/api/webhook`
    * (Note: If you were adding a webhook for a project in a cluster other than Silver, change the URL, replacing "silver" with the other cluster's name.)
* Content type: `application/json`
* Secret: `bcgovprivatecloud`
* Click 'Add webhook'

By default, the webhook is called on any 'push' event, which is basically any commit.  If you would like to narrow down the events that trigger the webhook, click the option for "let me select individual events", then select the types of events you need.

### Use a Helm chart
#### What is Helm?
From the [Helm website](https://helm.sh/):

_Helm helps you manage Kubernetes applications — Helm Charts help you define, install, and upgrade even the most complex Kubernetes application.  Charts are easy to create, version, share, and publish — so start using Helm and stop the copy-and-paste.  Helm is a graduated project in the CNCF and is maintained by the Helm community._

Helm is a sort of package manager for Kubernetes applications.  You can create your own Helm charts or use those created by others.  There are many publicly available Helm chart repositories.  Any of the Helm repositories that are managed in Docker Hub are accessible from Argo CD; all other sources aside from your GitOps repository are not accessible from Argo CD.

Because this exercise is about Argo CD and its usage in the Private Cloud platform, we won't get into the details of Helm charts themselves, but will configure an Argo CD application that uses a third-party chart.

First, we will create an application that uses default values, then we will create one that uses a values file that we will maintain in our GitOps repository.

#### Helm application with default values
In Argo CD, click 'Applications' then 'New App' and enter the following values:
- General
    - Application Name: LICENSEPLATE-helm-default
    - Project Name: (select your project from dropdown)
- Source
    - Repository URL: artifacts.developer.gov.bc.ca/docker-helm-oci-remote
        - Note: To the right of the Repository URL field is a dropdown that defaults to 'GIT'.  It should automatically update to 'HELM' after selecting the 'artifacts' URL; if not, you can set it manually.
    - Chart: bitnamicharts/mariadb
    - Version (unlabeled field next to Chart): 20.2.0
- Destination:
    - Cluster URL: `https://kubernetes.default.svc`
    - Namespace: LICENSEPLATE-dev
- Click 'Create'

Click on the newly created application.  We didn't select auto-sync, so all of the resources produced by the Helm chart will at first show as missing and out of sync.  This particular chart produces a ConfigMap, Secret, Services, ServiceAccount, StatefulSet, NetworkPolicy, and PodDisruptionBudget.  That was easy, but we almost certainly want to override some of the default settings, so we'll take a copy of the default values file, make some changes to it, and add it to our GitOps repository.  Then we'll create a new application that uses our values file for manifest generation.

Delete the 'LICENSEPLATE-helm-default' application.

#### Helm application with local values
In order to create an Argo CD application that directly processes a remote Helm repository while using a values file from our gitops repository, we will create a multi-source application.  However, the UI does not currently support the creation of multi-source applications, so we will create a YAML manifest and apply it to our dev namespace (you can create applications in any of your namespaces).

First, create a directory in your GitOps repository for the new Helm application.
```
mkdir mariadb-helm
```
Download the 'values.yaml' file from the Git repository that is home to the Helm chart that we are using:

https://github.com/bitnami/charts/tree/mariadb/20.2.0/bitnami/mariadb/values.yaml

Save it to the new mariadb-helm directory.  Add the file, commit, and push to GitHub:
```
git add .
git commit -a -m "Add Helm values file"
git push origin
```

Download the [multi-source application template](gitops_files/app.helm-multi-source.yaml).  Edit the file, replacing the LICENSEPLATE placeholder with your license plate.  Create the application in your dev namespace.
```
oc -n ${LICENSEPLATE}-dev apply -f app.helm-multi-source.yaml
```

In the Argo CD UI, click on the new application and view the resources that would be created.  Note the names of the resources ("mariadb").

Now update the values.yaml file and enter a value for `fullnameOverride` at line 47.  For example:
```
fullnameOverride: "testing"
```

Save the file, commit it, and push to the GitOps repository.  View the resources in the Argo CD UI again and note the change to the resource names.  If you don't have a webhook in place or you don't see a change yet, click the 'Refresh' button.

This is just a simple demonstration of setting your values file in a repo that is separate from the Helm chart.  You can also set Helm values directly in the Argo CD application.  For more details, see the [Argo CD Helm documentation](https://argo-cd.readthedocs.io/en/stable/user-guide/helm/#values).

#### Create your own Helm package
You can, of course, create your own Helm package and host that in your GitOps repo for Argo CD to process.

[Helm development how-to](https://helm.sh/docs/howto/charts_tips_and_tricks/)

['helm create' manual](https://helm.sh/docs/helm/helm_create/)


### Use Kustomize
Like Helm, Kustomize is a tool designed specifically for Kubernetes, and by extension, OpenShift.

Kustomize is a tool for customizing Kubernetes YAML configurations without modifying the original files and without templates.

Kustomize uses a base set of files for the main configuration and uses "overlays" to define environment-specific differences.  This makes it easy to define your default configuration and then a small subset of differences for your dev, test, and prod environments.  Changes to the base configuration are applied to all environments.

A typical Kustomize app contains a `base` directory for the base configuration files, and an `overlays` directory, which will contain a subdirectory for each environment.  Each directory contains a `kustomization.yaml` file that defines a `Kustomization` custom resource.  It lists any resources to be processed.  Both base and overlay directories may contain resource files.  Overlay directories may also contain patch files.  A simple directory might look like this:
```
my-kustomize-app
├── base
│   ├── deployment.yaml
│   └── kustomization.yaml
└── overlays
    ├── dev
    │   ├── configmap.yaml
    │   ├── kustomization.yaml
    │   └── patch.deployment.yaml
    ├── prod
    │   └── kustomization.yaml
    └── test
        ├── kustomization.yaml
        └── patch.deployment.yaml
```

#### Create a Kustomize app
To simplify the setup of the Kustomize app's directory tree, download this [setup script](gitops_files/set_up_kustomize.sh).

Run the script from the top level of the repository.  You may need to make it executable.  The script will show you the new directory tree.
```
$ chmod +x ~/Downloads/set_up_kustomize.sh
$ ~/Downloads/set_up_kustomize.sh

--> Run this script at the top level of your GitOps repository. Continue? [Yn]
Creating directory tree my-kustomize-app...
my-kustomize-app
├── base
│   ├── deployment.yaml
│   └── kustomization.yaml
└── overlays
    ├── dev
    │   ├── configmap.yaml
    │   ├── kustomization.yaml
    │   └── patch.deployment.yaml
    ├── prod
    │   └── kustomization.yaml
    └── test
        ├── kustomization.yaml
        └── patch.deployment.yaml

5 directories, 8 files

Done
```

#### Examine the Kustomize files
Have a look at the files in the `base` directory.  The deployment file is a basic YAML manifest for a Deployment.  The kustomization file lists the resources to be included, which in this case is just the one deployment manifest.  Kustomize only processes files that are listed in kustomization.yaml, so if you add another manifest to the base directory, it needs to be added to the resources list in kustomization.yaml.

Look at the files in `overlays/dev`.  The kustomization file includes two sections:
```
resources:
  - ../../base
  - configmap.yaml
patchesStrategicMerge:
  - patch.deployment.yaml
```
`resources` includes anything from the base directory as well as one additional resource, a ConfigMap.

`patchesStrategicMerge` is a list of patches to apply to base/default resources.  The patch file must include enough information to uniquely identify the resource to patch, namely:
* `/apiVersion`
* `/kind`
* `/metadata/name`

The rest of the patch file defines any changes to the default configuration.  In this case, the value of `/spec/replicas` has been changed from the default of 3 to 1.

#### Optional: Install the 'kustomize' CLI
Although not required, the 'kustomize' CLI can help you troubleshoot any errors you may have in your setup.  The CLI processes the app in the same way as Argo CD and will show you the same errors.  It may be helpful to run it to either ensure that your files are all good before committing them to your GitOps repo or to debug errors that you get in the Argo CD UI.

`brew install kustomize`

Alternatively, the executable can be downloaded outside of a package management system:

`curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && sudo mv kustomize /usr/local/bin/`

Run 'kustomize build' followed by the path to the overlay directory to build for.  To verify the setup and view the resulting YAML manifests, run it against the dev directory.

```
kustomize build my-kustomize-app/overlays/dev
```

Note the number of replicas in the Deployment.  The default configuration has 3 replicas; the dev deployment patch changes it to 1.

If you get an error when running 'kustomize build', carefully read the message and fix the issue.

#### Create an Argo CD app for your Kustomize app in dev
Add and commit the new directory and push it to your GitOps repo.
```
git add my-kustomize-app
git commit -a -m "Add my-kustomize-app"
git push origin
```

Create a new app in Argo CD, setting the Path to the overlay directory for dev:
- General
    - Application Name: LICENSEPLATE-my-kustomize-app-dev
    - Project Name: (select your project from dropdown)
- Source
    - Repository URL: `https://github.com/bcgov-c/tenant-gitops-LICENSEPLATE`
    - Path: `my-kustomize-app/overlays/dev`
- Destination:
    - Cluster URL: `https://kubernetes.default.svc`
    - Namespace: LICENSEPLATE-dev
    - **Note:**
        - Match the overlay directory to the correct namespace
        - Argo CD should recognize that this is a Kustomize app and the last section of the form will change to 'Kustomize'.  You shouldn't have to change anything in this section.
- Click 'Create'

#### Create an Argo CD app for your Kustomize app in test
Now create another app just the same as the previous one, but change `dev` to `test` in the Application Name, Source Path and Destination Namespace.

Click on the new app.  Note that in Test the ConfigMap is absent, because that resource was only included in dev.  The replica count in Test is set to 2 by the patch.

If you like, create another app for Prod.  It does not use a patch to modify the Deployment, so its replica count is set to 3.

When you have time, you may learn more about Kustomize at the [Kustomize project website](https://kustomize.io/).


### Troubleshooting
Argo CD does a good job of presenting application status and informative error messages.  The first and most obvious indication of application state is **Sync Status**.  You have seen 'OutOfSync' apps already.  Note that on the Applications page, you can filter the apps in the view by checking one of the Sync Status checkboxes in the left nav.

An app will show as **Degraded** if it is not able to achieve its desired state.  This could happen for a number of reasons, such as a crashlooping pod, an image pull error, or an invalid Service.  If you see an app marked as degraded, click on the app to see the detailed view.  Locate the individual resource that is marked as degraded and click on it to get a meaningful error message.

You may also see **Warnings**.  This most commonly happens when there are two Argo CD apps that are managing the same resource.  Argo CD keeps track of all resources that it manages by adding a label to them.  The label is unique, so two apps managing the same resource, having auto-sync enabled, will result in them each constantly changing the label, which creates unnecessary load on the system.  The app-tracking label is 'devops.gov.bc.ca/gitops-app-shared'.  For example:
```
metadata:
  labels:
    devops.gov.bc.ca/gitops-app-shared: my-kustomize-app
```

### Delete an Argo CD Application
When deleting an app, you can choose to do a cascading deletion in which all dependent objects are deleted, or a non-cascading deletion in which only the Argo CD app itself is deleted and the resources remain.

Additionally, when doing a cascading deletion, you can choose between a foreground or background deletion.  In a foreground deletion, the app remains until all dependent objects are deleted and then the app itself is deleted.  This is the default.  A background deletion will immediately delete the Argo CD app and then proceed to delete all dependent objects.

Delete the app 'LICENSEPLATE-my-kustomize-app'.

You can find more information on this process in the [Kubernetes garbage collection documentation](https://kubernetes.io/docs/concepts/architecture/garbage-collection/#foreground-deletion)


### App of apps
When you get to setting up production resources in Argo CD, it's a good idea to manage your Argo CD applications by way of another application - an app of apps.  This is done just like setting up an app that points to a directory of plain YAML manifests.

Create a new top-level directory in your repository called 'argocd_apps':
```
mkdir argocd_apps
```

Now create a manifest for your "app1" app at `argocd_apps/app.app1.yaml`.  Start with the standard fields:
```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: LICENSEPLATE-app1
spec:
```

Copy the 'spec' for the existing application by clicking on the app, then the Details button, then the Manifest tab.  This only shows the spec.  You can copy and paste this below the snippet above, making sure to properly indent the fields.

Save the file to `argocd_apps/app.app1.yaml`.  Add, commit, and push the new directory.
```
git add .
git commit -a -m "Add argocd_apps"
git push origin
```

Now use the Argo CD UI to create a new app called 'LICENSEPLATE-app-of-apps'.  Set the Path to `argocd_apps`.  Upon creation, the app of apps will show the other app as a dependent resource.

But you will notice that you now have two "app1" apps!
* `openshift-bcgov-gitops-shared/LICENSEPLATE-app1`
* `LICENSEPLATE-dev/LICENSEPLATE-app1`

This is because when the "apps in any namespace" feature is in use, the full name of the app is "NAMESPACE/APP_NAME".  Because they are in different namespaces, they are treated as different apps.

Click on the new "app1" app.  In the top right, under App Conditions, you should see a warning.  Click on the Warnings link.  It will indicate that the ConfigMap managed by this app is now being managed by two applications.  Using the non-cascading delete option, delete the original app with the name openshift-bcgov-gitops-shared/LICENSEPLATE-app1.

Add as many application manifests as you like to the apps directory.  In this way, if any of your apps were ever deleted or modified in error, they are easily restored.


### Optional task: JWT tokens and Argo CD CLI

#### JWT tokens
Interacting with Argo CD using the `argocd` CLI is possible by using JWT tokens.  The tokens are associated with a role in your project.

To create a token, go to: Settings --> Projects --> project-name --> Roles --> role-name

At the bottom of the role configuration form is the "JWT Tokens" section.  To create a token for this role, enter a unique name in the Token ID field.  The "expires in" field can be entered in seconds (s), minutes (m), hours (h), or days (d).  To create a non-expiring token (not recommended), leave the "expires in" field blank.

When the token is created, it is displayed in the browser.  Copy and safely store the token - **tokens are not stored in Argo CD and cannot be retrieved later**.

After creation, tokens are listed in the same form and may be deleted by clicking the "X" in the token list.

#### 'argocd' CLI
See the [CLI installation documentation](https://argo-cd.readthedocs.io/en/stable/cli_installation/).

Because of the SSO configuration, we won't use 'argocd login', but will instead use the server URL and token with each call.

Create an environment variable for the JWT token, as in `export ARGOCD_TOKEN=your-token`.

Assuming the token is valid, you can interact with Argo CD using commands like the following.
```
argocd app list --server gitops-shared.apps.silver.devops.gov.bc.ca --auth-token $ARGOCD_TOKEN
```

To explore the functionality of the CLI, run `argocd --help`.

## History and Rollbacks
The application details page has a "History and Rollback" button.  Use this to view the history of Git updates for the app.

However, **the rollback feature may not work the way you would think**.  When you roll back to a previous commit, Argo CD does not do a full state reset to the previous commit; it applies a diff between the current state and the selected revision.  Intermediate or manual changes may not be undone.  Simple changes with no intermediate updates may result in the desired effect.

Remember that **the Git repository is the source of truth**.  If you need to do a rollback, it is probably best to revert the commit in the Git repository.  Argo CD will see and apply this change as it does for any commit, resulting in a full state reset.

To avoid problems, consider keeping your commits relatively small in scope, use the diff feature to check updates before they are applied, and disable auto-sync during testing.

Next Topic - [Resource Management](https://github.com/BCDevOps/devops-platform-workshops/blob/master/openshift-201/resource-mgmt.md)

## References

[Private Cloud ArgoCD documentation](https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/automation-and-resiliency/argo-cd-usage/)

[Argo CD](https://argo-cd.readthedocs.io/en/stable/)

[Helm](https://helm.sh/)

[Kustomize](https://kustomize.io/)





