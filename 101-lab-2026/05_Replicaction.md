# Replication 

So far in this lab, we've made a deployment that created only a single pod. In production use, we need to ensure all of our critical OpenShift pods are replicated. OpenShift may occasionally need to restart your pods and move them between nodes. This process takes some time while the new pod starts. If you rely on any single pod, then your application will experience downtime in these scenarios. By instead having multiple replicas of your pods running, OpenShift can ensure that at least one of them is available at any given time to keep your application running. 

## Deployment with replicas

## Database replication with StatefulSets
