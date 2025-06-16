# Lab Setup 

Throughout the lab, we use two namespaces/projects:
- d8f105-tools: This namespace/project will have all of the builds related objects
- d8f105-dev: This namespace/project will have all the deployment related objects

If you're doing the self-paced training, use the `tools` and `dev` namespace that you created. 

---
Assign yourself a unique name to be used during your application deployments.

For example, if the lab says to create an application named `app1-[username]`, I would create an app named `app1-stewartshea`. This follows for any commands written in square grackets throughout the lab. 

## Lab Requirements
These labs will require access to the lab ocp environment:
- [Silver Web Console](https://console.apps.silver.devops.gov.bc.ca/)

Access requires an IDIR account. You can log in to OpenShift's web console via IDIR (preferred). For the self paced lab, your namespace access will be provisioned to your IDIR account, so you must use IDIR login. If your github account is a member of the `bcgov` github organisation and linked to an IDIR, it is also possible login with github, but your access will need to be set up manually. Github and IDIR accounts are treated seperately by OpenShift, so namespace access between these is independent. 

## Installing OC

You may already have `oc` installed on your machine. Your `oc` version should match the version of the cluster. 

__If you have `oc`__ installed run `oc version`. It should look something like this
```shell
Client Version: openshift-clients-4.6.0-202006250705.p0-176-g5797eaeca
```

__If you do not have `oc` installed__ or your version is incorrect follow these [instructions](https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/openshift-projects-and-access/install-the-oc-command-line-tool/).

## Login with OC command line

1. In your command line interface, run the command `oc login -w`. This prompts your web browser to open.

2. Login with your IDIR account (unless you've manually setup access via github)

This [video](https://youtu.be/7tlANUhgGdc) demonstrates the `oc login` process. 

## Other Requirements

In addition, developers require GIT locally installed and must have a 2FA device to support access to GitHub.

## Command Line Interfaces

You will find many examples `commands` and _tricks_ that highly depend on your OS. These commands were developed on __unix__ based systems. Window's __Command Prompt__ will not work with these examples. You will need to either use __WSL__, __Powershell__, __Gitbash__, or similar.

Next page - [Adding User Access](./01_adding_team_members.md)