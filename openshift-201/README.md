# OpenShift 201 Training Labs
Welcome to the OpenShift 201 Training Labs. 
The lab materials in this folder are designed to accompany the OpenShift 201 Workshop.
You may want to reference the [OpenShift 201 Workshop Slides](../README.md) as you work through the lab. Recordings of live sessions are available in the title slide of each section. 


### Prerequisites:
- Previous completion of the OCP101 workshop and lab exercises. You can find the lab material hosted on [this GitHub Page](https://github.com/BCDevOps/devops-platform-workshops/tree/master/101-lab/content). The OpenShift 201 exercises are independent of the 101 exercises. 
- oc CLI installed and up to date, find out [how to here](https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/openshift-projects-and-access/install-the-oc-command-line-tool/)
- You must be a member of the BC Gov github orgs. You would have set this up during the OpenShift 101 lab. 
- An OpenShift project set created for you from Registry app, which you are an Admin of. For live courses, you will either receive an email about this in advance of the course, or set this up during the OCP201 kick off. If you're completing this course in a self-paced manner, you can create a temporary product set to use for the OpenShift 201 lab in the registry. See the [instructions](#self-paced-lab-setup) below. 
- These lab instructions assume the use of a bash-based shell such as zsh (included on OS X) or [WSL](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/) for Windows. Please set this up prior to starting the course. 

### Self-paced lab setup 
If you're OpenShift 201 in a self-paced mode without registering for a live course, you can instead request a temporary project set in the [Product Registry](https://registry.developer.gov.bc.ca/private-cloud/products/all). 

Make sure you're in the 'Private Cloud OpenShift' tab, then click 'Request a new product'. 

Here are some things to note when creating the product set request on Registry:

- Check the box to choose a 'Temporary product set'. Your project will be deleted after 30 days, so don't create this until right before you plan to start working on the lab.
- Name the product set as "201 selfpaced training <your_name>". That way it's very clear for us to recognize it during support later on.
- Choose `Gold` for the hosting tier. You don't need GoldDR for 201 so leave that part uncheck.
- In the Team Members section, make sure to assign yourself as the `Primary Technical Lead (TL)` which will automatically grant you access to the platform services and tools. You will need a different person to be the `Product Owner`, in this case, either put down one of the training facilitator's name or your actual product owner is fine.
- Now you should be all set to submit the request! An email of confirmantion will be in your email inbox very soon.

Please join the [OpenShift 201 Self-Paced](https://teams.microsoft.com/l/channel/19%3A1c50fd046a6a46b680aee153013e4bdc%40thread.tacv2/OpenShift-training-201-selfpaced?groupId=a80418da-c27b-406e-89ab-7695b61924d8&tenantId=6fdb5200-3d0d-4a8a-b036-d3685e359adc) MSTeams channel, you can ask questions or help other participants in this channel. 


### Lab topics:

The Openshift 201 Lab is divided into the following topics:
* [OpenShift Gitops](./gitops.md)
* [Network Policy & ACS](./network-policy.md)
* [Application Logging with Loki](./logging.md)
* [Best Practices for Image Management](./image-management.md)
* [Resource Management](./resource-mgmt.md) 
* [Pod Auto Scaling](./rh201-pod-auto-scale.md)
* [Post Outage Checkup](./post-outage-checkup.md)

Archived sections: 
* Openshift Pipelines (you can choose to do either one)
    * [React Application](./react-pipeline.md)
    * [Java Application (Maven)](./pipelines.md)
