# Quiz Questions

## Resource management:

1\. Our example node has a total of 4000m (4 cores) of CPU and 8000Mi (8GB) of memory. If there is one pod running on the node that requests 700m of cpu and 400Mi of memory, how much cpu and memory remains free to be allocated by the node?  
  
- Less than 3300m of CPU & 7600Mi of memory.  
- 3300m of CPU & 7600Mi of memory.
- More than 3300m of CPU & 7600Mi of memory.
- 4000m of CPU & 8000 Mi of memory. 
 
  
2\. If the pod CPU and Memory requests and limits are set to the same non-zero value, what quality of service is being achieved?  
  
- BestEffort class  
- Burstable class  
- Guaranteed class  
- OpenShift class  
  
3\. What happens when a pod needs more CPU than the specified limit?  
  
- The pod is evicted  
- The pod's cpu usage is throttled  
- More pods are created to deal with the load  
- The pod will use unallocated resources from the node  
  
4\. What happens when a pod uses more memory than the specified limit?  
  
- The pod is evicted  
- The pod's memory usage is throttled  
-  More pods are created to deal with the load  
- The pod will use unallocated resources from the node

## Building Scalable and Resilient Apps:  
  
1\. A horizontal autoscaler works by:  
  
- Adjusting the number of pods based on load  
- Adjusting a pod's CPU and memory usage based on load  
- Adjusting the resource limit for a pod  
- All of the above  
  
2\. Which vertical pod autoscaling mode should be used to get resource recommendations only (without applying them)?
 
- Auto
- Recreate
- Initial
- Off

## OpenShift Pipelines

1\. What does CI/CD stand for in the context of this workshop? 

- Continuous Integration / Continuous Delivery
- Configuration Item / Configuration Document
- Change Interface / Change Directory
- Cheese Intolerance / Cheese Disaster

2\. Which of the following statements is INCORRECT: 

- A tekton pipeline step consists of tasks
- A tekton pipleline task consists of steps
- A tekton pipeline runs with no CI/CD engine to manage and maintain
- Tekton pipeline tasks run on different pods

## Best Practices for Image Management

1\. The latest tag is assigned to the: 

- Newest version of the image
- Most recently built image
- Image that was produced furthest after a deadline
- The most stable version of the image

2\. Which of the following is NOT a best practice for image management? 

- Keep the size of the image as small as possible
- The latest tag should always be used to ensure your application stays up to date
- Package a single app per container
- Images should be run as a non-root user

## Post Outage Checkup

1\. If your application is down and you think it is a problem with the platform, you should... 

- Check the platform services status page
- Check the #Devops-alerts rocketchat channel
- Check with other teams to see if they are experiencing problems
- All of the above

2\. How can I make troubleshooting an outage easier?

- Set up monitoring and alerts in sysdig
- Prepare and outage recovery checklist
- Check the logs
- All of the above


## Loki Logging

1\. How long are logs stored in Loki?

- Logs are stored indefinitely
- Log stores build up annually but then are burned in the winter
- Logs are stored for 3 days
- Logs are stored for 14 days

## Network Policy & ACS

1\. Network policies control: 
- Traffic between pods
- Outbound connections
- Incoming connections
- Highway 1 traffic 


