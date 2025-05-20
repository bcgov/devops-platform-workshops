# OpenShift 201 Training Labs
Welcome to the OpenShift 201 Training Labs. 
The lab materials in this folder are designed to accompany the OpenShift 201 Workshop.
You may want to reference the [OpenShift 201 Workshop Slides](https://docs.google.com/presentation/d/1h1123AfJx5k9shYZc6JpHdpKbJSt_qcdDf9V_We9qNc) as you work through the lab. Recordings of live sessions are available in the title slide of each section. 


### Prerequisites:
- Previous completion of the OCP101 workshop and lab exercises. You can find the lab material hosted on [this GitHub Page](https://github.com/BCDevOps/devops-platform-workshops/tree/master/101-lab/content). The OpenShift 201 exercises are independent of the 101 exercises. 
- oc CLI installed and up to date, find out [how to here](https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/openshift-projects-and-access/install-the-oc-command-line-tool/)
- You must be a member of the BC Gov github orgs. You would have set this up during the OpenShift 101 lab. 
- An OpenShift project set created for you from Registry app, which you are an Admin of. For live courses, you will either receive an email about this in advance of the course, or set this up during the OCP201 kick off. If you're completing this course in a self-paced manner, you can create a temporary project set to use for the OpenShift 201 lab in the registry. See the [instructions](#self-paced-lab-setup) below. 
- These lab instructions assume the use of a bash-based shell such as zsh (included on OS X) or [WSL](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/) for Windows. Please set this up prior to starting the course. 

### Self-paced lab setup 
If you're OpenShift 201 in a self-paced mode without registering for a live course, you can instead request a temporary project set in the [Product Registry](https://registry.developer.gov.bc.ca/private-cloud/products/all). 

Make sure you're in the 'Private Cloud OpenShift' tab, then click 'Request a new product'. 

Check the box to choose a 'temporary product set'. Please note, your project will be deleted after 30 days, so don't create this until right before you plan to start working on the lab. 

Please join the [OpenShift 201 Self-Paced](https://chat.developer.gov.bc.ca/channel/openshift-201-selfpaced) rocketchat channel by clicking the link then the 'join this channel' button. You can ask questions or help other participants in this channel. 


### Lab topics:

The Openshift 201 Lab is divided into the following topics:
* Openshift Pipelines (you can choose to do either one)
    * [React Application](./react-pipeline.md)
    * [Java Application (Maven)](./pipelines.md)
* [Resource Management](./resource-mgmt.md) 
* [Network Policy & ACS](./network-policy.md)
* [Application Logging with Loki](./logging.md)
* [Best Practices for Image Management](./image-management.md)
* [Pod Auto Scaling](./rh201-pod-auto-scale.md)
* [Post Outage Checkup](./post-outage-checkup.md)
