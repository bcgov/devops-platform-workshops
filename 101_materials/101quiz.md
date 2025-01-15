# Quiz Questions 

## Openshift Architecture

How are pods and containers related to each other?
- a) One or more pods run inside a container
- b) One or more containers run inside a pod
- c) Only one pod runs inside a container
- d) Only one container runs inside a pod

I want two pods to communicate with each other. Which of these scenarios would allow this?
- a) Both pods are running on the same node
- b) Both pods are running in the same namespace
- c) Both pods are running in the same container
- d) Record numbers of orcas are in the Georgia Strait

## BCGov-specific patterns

How many applications should I be running per project set?
- a) One
- b) Two
- c) Three
- d) It depends on how much quota the namespace has.

What’s the difference between a resource request and a resource limit?
- a) A request is a guaranteed minimum assigned to a pod, while a limit is the ideal amount that I want my pod to have
- b) A request is the ideal amount I want my pod to have, while a limit is the most my pod is allowed to have
- c) A request is a guaranteed minimum assigned to a pod, while the limit is the most my pod is allowed to have
- d) Asking nicely vs demanding

## Openshift Basic Tasks

I’ve just built a new image for my wildfire application. How should I tag this image?
- a) Wildfire-app:latest
- b) Wildfire-app:v1_new
- c) Wildfire-app:v2
- d) Wildfire-app:rhwajklfbfbfewa

I want to deploy a database. How should I deploy it?
- a) Using a Deployment or DeploymentConfig with the rolling deployment option
- b) Using a Deployment or DeploymentConfig with the recreate deployment option
- c) Using a StatefulSet
- d) "Hey Alexa, deploy my database"

## Platform-Specific Components and Tasks

I want to deploy a database. How should I configure the persistent volumes for the database?
- a) Each database pod should have its own volume using the RWX access mode, so the master can write changes directly to the member’s data files.
- b) Each database pod should have its own volume using the RWO access mode, because each pod needs to maintain strict control over its own data.
- c) One volume should be shared across all the pods using the RWX access mode, so each pod is able to update the datafiles.
- d) One volume should belong only to the master pod using the RWO access mode, because the member pods don’t need their own volumes when the data would just be the same anyway.

When should I change the reclaim policy of my persistent volume from “delete” to “retain”?
- a) When my data is super important and should never be deleted.
- b) When the persistent volume contains my database backups, because I need to hold onto them for a long time.
- c) Never, because I should not be touching the persistent volume object at all
- d) When i really want to know what happens if I change this setting

## Day 2 Application Operations

My pod is failing to start with an ImagePullBackoff error. What could cause this?
- a) My pod is trying to pull an image that doesn’t exist
- b) My pod is trying to pull an image using the wrong tag
- c) My application is crashing after the pod starts
- d) My pod is trying to mount a secret that doesn’t exist

My pod keeps failing with a CrashLoopBackoff error. Where should I look to start troubleshooting this problem?
- a) It’s probably an application error, so I should look in the application logs
- b) It’s a problem with the pod’s configuration, so I should check the event logs
- c) It’s a problem with the platform, so I should check the platform’s status page
- d) It's probably fine, ignore it
