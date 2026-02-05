# Debugging Containers

<!-- <kbd>[![Video Walkthrough Thumbnail](././images/11_logging_thumb.png)](https://youtu.be/UYbtIXYpMkI)</kbd> -->

<!-- [Video walkthrough](https://youtu.be/UYbtIXYpMkI) -->

### Accessing Local Logs

Logs of a running pod can be accessed from the Web Console or from the `oc` cli: 
- The `Logs` tab of any running pod can be used to view active logs for the current pod

<kbd>![](./images/09_debugging_00.png)</kbd>

- The `oc` command can be used to view or tail the logs: 
```
oc -n [-dev] logs -f <pod name>
```
If there is more than one container in a given pod, the `-c <container-name>` switch is used to specify the desired container logs. 

### Using a Debug Container
__Objective__: Create a problem with our app  to start debugging:
In this lab, we will test the communication between our pods. A debug pod creates a new version of your pod, but without running the usual `init:` command. This can allow for troubleshooting of issues during the pod's startup. The debug pod also allows you to run commands from within your pod, which we can use to troubleshoot. In this section, we'll shut down our rocketchat pods, and then try to ping them from our database debug pod. 

- Find the name of your mongodb pod that's running
  ```
  oc -n [-dev] get pods
  ```

- In a new terminal window, start a debug pod for your mongodb deployment. 

    ```
    oc -n [-dev] debug [mongodb-pod-name] -t -- bash
    ```
- In openshift, local hostnames follow this format
```
[service-name].[namespace].svc.cluster.local
```
You can also find the hostname listed in the web console in the `Administrator->Networking->Services` menu.

- Test connectivity to the RocketChat service from your MongoDB debug pod. We'll use bash's built-in Transmission Control Protocol (TCP) connection feature to send an HTTP request. Our rocketchat service has the name `rocketchat-[username]`

    ```oc:cli
    exec 3<>/dev/tcp/rocketchat-[username].[-dev].svc.cluster.local/3000; echo -e "GET / HTTP/1.1\r\nHost: rocketchat-[username].[-dev].svc.cluster.local\r\nConnection: close\r\n\r\n" >&3; cat <&3
    ```
- If you see ```HTTP/1.1 200 OK``` at the top, the connection was succesful.

- From our original terminal window (not the debug pod), let's scale down the rocketchat deployment:    
    ```
    oc -n [-dev] scale deployment/rocketchat-[username] --replicas=0
    ```
- Now switching terminals again to the MongoDB debug pod, we'll try to connect again to the rocketchat service. This may take a few minutes to run.

    ```oc:cli
    exec 3<>/dev/tcp/rocketchat-[username].[-dev].svc.cluster.local/3000; echo -e "GET / HTTP/1.1\r\nHost: rocketchat-[username].[-dev].svc.cluster.local\r\nConnection: close\r\n\r\n" >&3; cat <&3
    ```
- As expected, since we shut down the rocketchat deployment, we get an error when trying to connect to it. If we were experiencing a problem with our pods in OpenShift, we could use this method to test that they can communicate properly. 

- In your debug pod terminal and run the `exit` command. This will remove the debug pod.
    ```
    sh-4.2$ exit
    exit

    Removing debug pod ...
    ```

- Scale back up your RocketChat pod:
```
oc -n [-dev] scale deployment/rocketchat-[username] --replicas=1
```

### RSH and RSYNC
RSH (**R**emote **SH**ell) is available to all normal pods through the web console under the `Terminal` tab, as well as through the 
`oc rsh` command. This allows you to remotely execute commands from the pod. For more information, you can view the [RedHat documentation](https://docs.openshift.com/container-platform/4.15/nodes/containers/nodes-containers-copying-files.html)
- With your choice of access, rsh into one of the application pods and test access within the namespace. First, get a list of pods in the dev namespace. 
``` 
oc -n [-dev] get pods
```
- Take note of the name of your currently running, ready rocketchat pod. Then, use rsh command to start a remote shell from the pod using your pod's name from the previous step's output. 
```
oc -n [-dev] rsh [podname]
```
- Explore your userid 
```
 whoami
```
- This command identifies the userid of your rsh session. You can then try other commands to explore the pod. 
- Now we'll try some other commands from the pod's shell. Try the 'print working directory' command to see the path of the directory you're currently in.
```
pwd
``` 
- Get a list of files in the directory 
```
ls
```
- Let's test connectivity to see if our pod can connect to external and internal resources. Let's first test if our pod can get data from Google. 
``` 
wget -O- http://www.google.com
```
The output may look jumbled as we're seeing a html file as plain text rather than being displayed graphically as it would in a web browser. 

Now let's try connecting to an internal resource from the pod. We'll get a similar html output here.  
```
wget -O- 127.0.0.1:3000
```
Exit the rsh session. 
```
exit
```
Remote Sync(RSYNC) is also available in many pods, available through the `oc rsync` command and can be used to get files from the pod, or to move them from your local to the pod. To get help with this command, you can use `oc rsync -h`. We're going to use it to download the data file from the mongodb pod. 
- Find the name of your running, ready mongodb pod
```
oc -n [-dev] get pods
``` 
- We want to use rsync to get the mongodb data files, and put them onto our local machine. The mongo pod will store files in the directory `var/lib/mongodb/data`. First, I'll make a new local directory called 'lab'.
```
mkdir lab
```
To confirm the directory exists, I'll switch to it with 
```
cd lab
```
Then, check that this new folder is empty with 
```
ls
```
Then check the path to this directory with 
```
pwd
```
Next, let's synchronise this new empty folder with the data folder on our mongodb pod. For me, this local path is `/users/matt/lab`. Add the podname and path to your lab folder in the command below.
```
oc -n [-dev] rsync [mongodbpodname]:/data/db [localpath]
```
Now let's confirm that these files have been copied locally. Let's get a list of folders in the current directory. 
```
ls
```
Notice the new `data` folder. Let's switch to it. 
```
cd data
```
Let's list the files in this folder. 
```
ls
```
Note that the data files from your mongo pod have been copied locally.
### Port Forwarding
The `oc port-forward` command enables users to forward remote ports running in the cluster
into a local development machine. 
- Find your pod and use the port forward command
```
oc -n [-dev] get pods  | grep rocketchat-[username]
oc -n [-dev] port-forward [pod name from above] 8000:3000
```
- Navigate to http://127.0.0.1:8000
- When you're done, stop the `port-forward` command running with 'ctrl-c'.

Next page - [Logging and Visualizations](./12_logging_and_visualizations.md)
