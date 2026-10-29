# Adding team members 

## Namespace access (live training)

In the live training, we ask for volunteer admins to help grant access to the training namespaces for all other members of the lab. If you are not one of the 'devops' admins for the openshift 101 dev/tools projects you can check to see if you have access to the projects with the `oc projects` command in your terminal. If you have access to the openshift 101 project you will see something like this:
>```shell
>* d8f105-dev - OpenShift 101 (dev)
> d8f105-tools - OpenShift 101 (tools)
>```

## Namespace access (self-paced training)
If you're doing the self-paced training, you can instead request a temporary project set in the [Product Registry](https://registry.developer.gov.bc.ca/private-cloud/products/all). 

Make sure you're in the 'Private Cloud OpenShift' tab, then click 'Request a new product'. 

Check the box to choose a 'temporary product set'. You'll need to add another person as the 'technical lead' on your project, so consider a member of your team for this role. Please note, your project will be deleted after 30 days, so don't create this until right before you plan to start working on the lab. Once you submit this request, it may take a few minutes for the namespaces to be provisioned and your access granted. The registry will automatically provision your access to the 'temporary product set' to your IDIR email, so please use the IDIR login method when accessing OpenShift via the web console or `oc` command line tool.  

You can skip the remaining steps in this section if you're doing the self-paced lab, but take note of the instructions below for adding team members. You may need to do this in the future as your teams' access needs change. 

## Team Permissions (live training)

When the lab begins, our volunteer admins will navigate to each project and assign everyone else the appropriate permissions. 

- Navigate to the `User Management -> RoleBindings` menu

- Click the `Create RoleBinding` button 

- Fill out the wizard fields as below:

```
Rolebinding 
Name: any unique name, IDIR email can be used here
Namespace *select the desired namespace*
Role
Role name: edit (or admin or view)
Subject: User 
Subject name: IDIR email in lowercase
```
- Click `create` the bottom of the wizard

Alternatively, this can also be done on the CLI with the `oc` utility: 

```
oc -n [namespace] policy add-role-to-user [role] [username]
```
A great advantage of the command line for adding multiple users is that these can be chained together by adding users with a space seperating them:

```
oc -n [namespace] policy add-role-to-user [role] [username1] [username2] [username3] [username29]
```

## Roles

- Admin: This is the most privileged of the default roles. This role allows everything that __Edit__ allow plus the management of __user and service account access__

- Edit: This is the primary role required for developers/devops to do work in a project. It allows the creation/edit/deletion of Openshift Objects including __Secrets__

- View: This is the basic role that provides users with read access to your project. __Secrets are not viewable__ with this privilege.

## Username 

Usernames should be entered in lowercase. The syntax is as follows:

- **Email** `emailaddress@gov.bc.ca`
- **Github** `username@github` note: don't include .com after github here!

Next page - [Builds](./02_builds.md)
