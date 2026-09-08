# Decommission an Application

Now that you've completed the training material, it's time to decommission the product set. This section is optional as the training product set will be automatically deleted after 30 days, but it is encouraged for you to go through the full life cycle of application.

This training material is based on [this instruction](https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/build-deploy-and-maintain-apps/retire-an-application/).

## Table of Contents

- [Review Data and Application Dependencies](#review-data-and-application-dependencies)
- [Disable CI/CD Automation](#disable-cicd-automation)
- [Clean Up OpenShift Resources](#clean-up-openshift-resources)
- [Clean Up Dependent Services](#clean-up-dependent-services)
- [Delete the Application from the Product Registry](#delete-the-application-from-the-product-registry)


## Review Data and Application Dependencies

When you have completed the lab practices and no longer need this product set anymore, you can proceed to the next part since everything can be deleted now. But for a real product set, check the following before deleting anything:

* Confirm whether application data needs to be retained
* Back up any data that must be retained
* Preserve credentials required to access retained data
* Notify application owners, users, and other stakeholders
* Identify external services that depend on the application

Once an OpenShift project is deleted, data and secrets that only exist in OpenShift will no longer be available.

## Disable CI/CD Automation

Disable any CI/CD pipelines or other automation that can deploy or restart the application. For example, ArgoCD is used as part of the lab practice, without disabling auto sync, it will detect the changes and recreate resources that have been deleted or scaled down.

In ArgoCD, find your application and:
- Disable **Auto-Sync**
- Make sure automated self-healing/pruning is no longer active

## Clean Up OpenShift Resources

Now we can move on to deleting the resources in your namespaces. You will need to do the following for all 4 namespaces in the product set:

```bash
# --------------------------------------------------
# Review resources
# --------------------------------------------------

# Set the namespace
oc project [license-plate]-tools/dev/test/prod

# Application workloads
oc get deployments,statefulsets,jobs,cronjobs

# HA objects
oc get pdb,hpa,vpa

# Persistent storage
oc get pvc

# --------------------------------------------------
# For tools namespace, check on the builds and images
# --------------------------------------------------

oc get buildconfigs,imageStreams

oc delete buildconfigs,imageStreams --all

# --------------------------------------------------
# Delete HA objects
# --------------------------------------------------

# --all flag will delete all resources, in the namespace of the specified resource types
oc delete pdb,vpa,hpa --all

# --------------------------------------------------
# Review persistent storage and Back up data
# --------------------------------------------------

# List PVCs
oc get pvc

# There are different ways to backup data, for example, copy data from a pod to your local
oc rsync [pod-name]:/path/to/data ./backup-data


# --------------------------------------------------
# Scale down workloads
# --------------------------------------------------

# Scale all Deployments to zero
oc scale deployment --all --replicas=0

# Scale all StatefulSets to zero
oc scale statefulset --all --replicas=0

# Check that application pods have stopped
oc get pods

# --------------------------------------------------
# Delete persistent storage
# --------------------------------------------------

# Delete a specific PVC
oc delete pvc <pvc-name>

# Or, after reviewing ALL PVCs in the namespace:
oc delete pvc --all


# --------------------------------------------------
# Remove remaining pods
# --------------------------------------------------

# Check for remaining pods
oc get pods

# Delete a specific pod
oc delete pod <pod-name>

# If all remaining pods have been reviewed:
oc delete pods --all


# --------------------------------------------------
# Final verification
# --------------------------------------------------

oc get all,deployments,statefulsets,cronjobs,pvc,pdb,hpa,vpa

```

If pods are recreated after being deleted, stop and investigate. Something is still managing the workload, such as ArgoCD, a Deployment, StatefulSet, CronJob, or another controller. Repeat the cleanup for all application namespaces.


## Clean Up Dependent Services

Clean up services associated with the application, as applicable. For the context of this lab practice, you can skip this part as no additional resources are created in the shared services.

- Artifactory: Remove application-specific repositories and service accounts that are no longer required
- Sysdig: Remove application-specific notification channels
- Vault: Preserve any secrets that are required for retained data or future access
- ACS: Review application-related ACS access and remove access that is no longer required
- ArgoCD: After auto-sync has been disabled and the application has been removed from OpenShift, remove the ArgoCD Application/Project when appropriate
- GitHub: Update any related GitHub README to reflect the current state of the project, archive the repos and disable Github actions, webhooks, etc.
- Other resources outside of OpenShift: Check for any other resources/services, such as S3 Object storage, TLS certificate service, SSO and CHES/CHEFS integrations, and so on. To make sure the resources there have been cancelled or updated.


## Delete the Application from the Product Registry

Now that all the resources and workloads have been deleted from the Openshift product set, you can proceed to [the Platform Product Registry](https://registry.developer.gov.bc.ca/home) to create a decommission request. Only do this when you are sure you don't need the namespaces anymore!

There will be an email confirming the deletion request, and then you are all set!
