# Resource Requests and Limits
Tuning the resources assigned to a pod will have a direct effect on the performance of the application.

Many templates include reasonable CPU and Memory resource configurations. However, new apps are deployed with the platform default resource configuration.

The platform default resource configuration is maintained by the Platform Services team. It is based on a measurement of average CPU and memory utilization, and it serves as a great starting point for your pod's horsepower.

<!-- <kbd>[![Video Walkthrough Thumbnail](././images/05_resource_requests_and_limits_thumb.png)](https://youtu.be/dhLnaUGgnQY)</kbd> -->

[Video walkthrough](https://youtu.be/dhLnaUGgnQY)

## Explore Default Resource Configurations
Since the Rocket.Chat application was imported and not deployed from a template, explore the current resources allocated to the pods:

- Navigate to your rocketchat deployment and select the YAML tab

- Take a look at the resources spec under `.spec.template.spec.containers.resources`. These values should reflect the resource requests (cpu=500m,memory=512Mi) and limits (cpu=1000m,memory=1024Mi) we set earlier. If we had not set any values for requests or limits earlier, we would see `{}` in the resources spec to indicate the deployment was using the default resource allocation for the platform.

<kbd>![rocketchat YAML Showing Resources](./images/05_resource_management_001.png)</kbd>

- To view the limit ranges that are in place, run the command:
`oc get LimitRange`

- You should see there is a limit range in place called 'default-limits'. This set of request and limit values are applied when resource specifications are not defined. To view the details of this limit range, run:
`oc -n [-dev] describe LimitRange default-limits`

- Review the current metrics of your `rocketchat-[username]` pod. Navigate to your Deployment and then select the Pods tab to see a list of pods in your Deployment. Navigate to your pod by clicking its name and then select the Metrics tab to see your current pod metrics.

<kbd>![rocketchat Deployment showing Pods tab with a single pod running](./images/05_resource_management_01.png)</kbd>
<kbd>![rocketchat Pod Details showing Metrics tab with Memory and CPU usage graphs](./images/05_resource_management_02.png)</kbd>

- Reduce the CPU request to `100 millicores` and the CPU limit to  `200 millicores` 
  ```oc:cli
  oc -n [-dev] set resources deployment/rocketchat-[username] --requests='cpu=100m,memory=512Mi' --limits='cpu=200m,memory=1024Mi'
  ```
- We'll restart the rollout and wait for that to finish to ensure all our pods are running with the new resources and that any old ones have finished shutting down after the last step. This will give us a consistent starting point to time from. After your pod is running, measure the time it takes to rollout.  

  ```oc:cli

  # Restart the deployment and observe how long it takes to finish (this should take around 2-3 minutes)

  time (oc -n [-dev] rollout restart deployment/rocketchat-[username] && oc -n [-dev] rollout status deployment/rocketchat-[username])
  ```

If you experiment with the resource values, you may notice your pod starts to crash loop. This is most likely because the `liveness` probe you added from an earlier lab is timing out. This is an important consideration when deciding to tune pod resources. It is always a balance.

- Remove the limits previously imposed, and set your pod to `1 core` (or `1000 millicores`) for the request and limit

  ```oc:cli
  oc -n [-dev] set resources deployment/rocketchat-[username] --requests=cpu="1000m",memory="512Mi" --limits=cpu="1000m",memory="1024Mi"
  ```

- Monitor the startup events of your pod and measure the time it takes to rollout. Again, we'll restart the rollout and wait for that to finish to ensure all our pods are running with the new resources and that any old ones have finished shutting down after the last step. This will give us a consistent starting point to compare to our previous timing. 

  ```oc:cli
  # Restart the deployment and observe how long it takes to finish 

  time (oc -n [-dev] rollout restart deployment/rocketchat-[username] && oc -n [-dev] rollout status deployment/rocketchat-[username])
  ```

## Sharing Resources

If there are many team members (and therefore workloads) working together in the same namespace there is a chance that requesting 1 core of cpu and 1 core of memory will not work. Why could that be?

- Reset resources utilization to something more appropriate

```oc:cli
oc -n [-dev] set resources deployment/rocketchat-[username] --requests='cpu=250m,memory=512Mi' --limits='cpu=500m,memory=1024Mi'
```

- Restart the rollout and wait for that to finish to ensure all our pods are running with the new resources:

```
oc -n [-dev] rollout restart deployment/rocketchat-[username]
```

## Troubleshooting OOM

The dreaded `OOM` or Out of Memory is when your pods are utilizing less memory than is required for the containers inside of the pod to work. Often there are __no logs__ visible during these issues. Often the symptoms of OOM are `CrashLoopBackOff` failure events as well as `rollout` failures. These can be investigated in the `Events` panel. To resolve this you can first increase memory utilization. After that you should investigate if the memory utilization fix is a band-aid or not. In other words, is the application consuming more memory than it should.

Next page - [Application Availability](./06_application_availability.md)
