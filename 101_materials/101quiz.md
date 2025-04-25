# Quiz Questions 

## OpenShift Architecture

How are pods and containers related to each other?
-  One or more pods run inside a container
-  One or more containers run inside a pod
-  Only one pod runs inside a container
-  Only one container runs inside a pod

I want two pods to communicate with each other. Which of these scenarios would allow this?
- Both pods are running on the same node
- Both pods are running in the same namespace
- Both pods are running in the same container
- Record numbers of orcas are in the Georgia Strait

## BCGov-specific

How many production applications should I be running per project set?
-  One
-  Two
-  Three
-  It depends on how much quota the namespace has.

What’s the difference between a resource request and a resource limit?
-  A request is a guaranteed resource minimum assigned to a pod, while a limit is the ideal amount that I want my pod to have
-  A request is the ideal amount of resource I want my pod to have, while a limit is the most my pod is allowed to have
-  A request is a guaranteed minimum resource level assigned to a pod, while the limit is the maximum level of the resource that my pod is allowed to have
-  Asking nicely vs demanding

## OpenShift Basic Tasks

I’ve just built a new image for my wildfire application. How should I best tag this image?
-  Wildfire-app:latest
-  Wildfire-app:v1_new
-  Wildfire-app:v2
-  Wildfire-app:rhwajklfbfbfewa

I want to deploy a database. How should I deploy it?
-  Using a Deployment with the rolling deployment option
-  Using a Deployment with the recreate deployment option
-  Using a StatefulSet
-  "Hey Alexa, deploy my database"

## Platform-Specific Components and Tasks

I want to deploy a database. How should I configure the persistent volumes for the database?
-  Each database pod should have its own volume using the RWX access mode, so the master can write changes directly to the member’s data files.
-  Each database pod should have its own volume using the RWO access mode, because each pod needs to maintain strict control over its own data.
-  One volume should be shared across all the pods using the RWX access mode, so each pod is able to update the datafiles.
-  One volume should belong only to the master pod using the RWO access mode, because the member pods don’t need their own volumes when the data would just be the same anyway.

When should I change the reclaim policy of my persistent volume from “delete” to “retain”?
-  When my data is super important and should never be deleted.
-  When the persistent volume contains my database backups, because I need to hold onto them for a long time.
-  Never, because I should not be touching the persistent volume object at all
-  When I really want to know what happens if I change this setting
