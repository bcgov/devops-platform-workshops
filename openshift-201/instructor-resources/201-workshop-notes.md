<!-- These notes are to support the mural slides for the 201 workshop -->

# 201 Workshop Instructor Notes

## Resource Management

### Setting Pod Limits & Requests
Sysdig Blog link-  shows how to create monitoring graphs that line up with the numbered/highlighted points in the graphic 

Example has multiple containers in the pod, with their own limits and requests

Requests allow the schedule to place the pod onto a node. Request values should be set low, setting these to the bare minimum to run the application (even if running slowly). The application will almost always be able to use a higher amount of resources based on the limit value. Setting request values too high will make it harder for your pod to be scheduled onto a node. 

Limits set the maximum resources that your container can use, and kubernetes will take action (throttling CPU, terminating pods OOM). 

### Kubernetes Resource Requests and Limits
Nodes can be overcommitted as it is unlikely that all pods will be operating at 100% at the same time. Requests reserve a guaranteed amount of resources. In normal circumstances your pods will be able to run close to their limit values. 

### Right Sizing Requests and Limits

There is no magic button to determine ideal resource usage in OpenShift, it will take some experimentation and adjustment. 

We look at how to use the vertical autoscaler to get a suggestion for requests and limits in the lab exercises. 

### Try setting to ideal values

Look at sysdig for actual usage. 

Openshift Console Resource Quotas isn’t showing actual usage, 

### Default Limit Range
When limits and requests aren’t specified, these  default limits and requests are applied to all containers on the BCGov OpenShift platform. 

### Get your actual usage

Demonstrate monitoring on openshift console
Load testing in labs demonstrates changes in these loads and how to monitor them
Custom queries demonstrated in labs 

### Quota ≠ Actual Metrics 

### Pod Resource Limitation and Quality of Services

In this scenario, we imagine what would happen when a node is overcommitted and running out of resources. 

- Best Effort Class
(Wouldn’t happen unless limit/request is set to zero) 
 
- Burstable Class
Most things should have their resources allocated this way. 

- Guaranteed Class
The request value and limit value are equal. Only used in special cases. 

### Pod OOM & CPU Throttling 

### Pod CPU Throttling

### Pod OOM Kill 

## Building Scalable and Resilient Apps

### Pod Auto Scaling Options

- HPA: automatically increases the pod count (up to 5 pods) 
- VPA: can adjust the resource request/limit of your pod (but requires restarting the pod), can be disruptive. Can be used in ‘auto off’ mode to avoid restarting pods, and just gather resource recommendations. 

### How HPA works? 

### HPA Definition

### HPA API Versions

### HPA Command Line v1

### How VPA works 

Can be used just for the recommender, or have the VPA automatically apply these recommendations 

### VPA vs HPA?

### VPA Modes

- The Auto and Recreate modes: automatically apply the VPA CPU and memory recommendations throughout the pod lifetime. The VPA deletes any pods in the project that are out of alignment with its recommendations. When redeployed by the workload object, the VPA updates the new pods with its recommendations.

- The Initial mode: automatically applies VPA recommendations only at pod creation.

- The Off mode: only provides recommended resource limits and requests, allowing you to manually apply the recommendations. The off mode does not update pods.

### VPA Recommendations Example

### VPA Auto

### Pod Disruption Budgets

- For when nodes are getting updated for maintenance. Your pods should have multiple replicas (at least 3), running on multiple nodes of the cluster. This specifies the minimum numbers of replicas to keep available.

- Don’t set PDB to same as deployment replica count

- PDB’s only influence scheduled interruptions like upgrades/maintenance, they can’t influence unplanned events like power outages.  The Kamloops data centre has a lot of built in redundancy for power and physical interruptions. 

## OpenShift Pipelines

### What is a CI/CD pipeline

### Cloud Native CI/CD
- Created like any other OpenShift resource (with YAML/JSON files)

- No orchestrator engine (unlike Jenkins)

### Resources 

- Tasks are the lowest level resource (the task is a pod, with the steps inside the task run in different containers)

- Pipeline run - an instance in time of a pipeline, given specific parameters. 

### Task

### Pipeline
### Pipeline Run 
- Not all pipelines will have a 'finally' task

### Workspaces

- A shared volume that can be used to pass data back and forth between tasks. 

### Triggers
- Triggers are the glue that holds everything together, and make the pipeline automated 

eg. example of an input could be the branch you want to build from

### Sample Pipeline

### Migrating from Jenkins to Tekton

Tekton: Pipeline is kind of like a template, the pipeline run takes the parameters needed and executes them

## Best Practices for Image Management

### Component Parts
### Version/Tag
### Building Images
### Testing

- Unit tests: are the lowest level, testing individual units/functions/modules of an application in isolation. 

- Integration: might interact with an external dependency such as a database. 

- UI (aka Functional Tests): testing a slice fo functionality on the whole system. 

### Security 

### Configuration

- It is really good practice to decouple configuration artifacts from the image content
- IF you find yourself trying to modify the contents of an image after creating it, stop! The way to make changes is through configuration. 

### ConfigMap

### Secrets
### Image Streams
### Artifactory

## Post Outage Checkup
### Before an Outage
### My Application is Down
### Outage Recovery
### Pods 
### Common Problems - Crash Loop Backoff
### Inspecting Logs
### Common Problems - Image Pull Backoff 

- Could also be a secret. If there is a pull secret involved, this can be wroth checkign to ensure it is still valid. 

### Recovery Checklist

## Application Logging with Loki

### Loki Logging
### Usage

## Network Policy and ACS
### Networking Policy
### YAML Structure
### Selector Behaviour
### Deny by Default
### Network Policy & OpenShift SDN 
### ACS Network Graph - View Network Policies
### ACS Network Graph - View Network Flows
