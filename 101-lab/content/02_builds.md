# Builds
In this lab, you will import the Rocket.Chat Docker image for use in your OpenShift environment.

<!-- <kbd>[![Video Walkthrough Thumbnail](././images/02_builds_thumb.png)](https://youtu.be/j7a74_I6MYw)<kbd>

[Video walkthrough](https://youtu.be/j7a74_I6MYw) -->

## The Tools Project
The tools project is what will hold various support tools for the application. In this case, we'll import the Rocket.Chat image into this project.

## Importing the Rocket.Chat Image
The Rocket.Chat Docker image is built from the official Rocket.Chat Github [public repository](https://github.com/RocketChat/Rocket.Chat). 
Leveraging the commandline, you can use the `oc import-image` command to import the Rocket.Chat Docker image. 

Ensure that all team members have edit rights into the project. Once complete, 
each member can create their own Rocket.Chat docker build. 

**Note:** In this lab, we'll use square brackets to indicate when you need to replace part of a command and omit the square brackets. If you see `[-tools]` in a command, replace that part of the command with the name of your tools namespace. When `[-dev]` is indicated, replace this part of the command with your dev namespace's name. In the example below, `oc project [-tools]` would become `oc project d8f105-tools` or the name of the tools namespace you are using for this training. We also use [username] as a unique identifier throughout the lab, and this can be any unique username so long as you use it consistently throughout the lab. Note that this username cannot contain following characters: `. ~ @ | ></{}[];:'"`

- To start, switch to the __Tools Project__

```
oc project [-tools]
```

- With the `oc` cli, import the Rocket.Chat image:

```oc:cli
oc -n [-tools] import-image rocketchat-[username]:latest \
    --from=docker.io/rocketchat/rocket.chat:latest \
    --confirm \
    --reference-policy=local
```
- It may take a few minutes to import the Rocket.Chat image.

- The output of the previous command should be similar to the following: 

```
imagestream.image.openshift.io/rocketchat-[username] imported

Name:			    rocketchat-[username]
Namespace:		    [-tools]
Created:		    Less than a second ago
Labels:			    <none>
Annotations:		openshift.io/image.dockerRepositoryCheck=2026-01-22T20:35:25Z
Image Repository:	image-registry.apps.silver.devops.gov.bc.ca/[-tools]/rocketchat-[username]
Image Lookup:		local=false
Unique Images:		1
Tags:			    1

latest
  tagged from docker.io/rocketchat/rocket.chat:latest
    prefer registry pullthrough when referencing this tag

...
...
...

Volumes:	        /app/uploads
```

- You can verify the image was successfully imported:

```oc:cli
# Check the imagestream exists
oc -n [-tools] get imagestream rocketchat-[username]

# Get detailed information
oc -n [-tools] describe imagestream rocketchat-[username]

# Verify the latest tag exists
oc -n [-tools] get imagestreamtag rocketchat-[username]:latest
```

Next page - [Deployment](./03_deployment.md)
