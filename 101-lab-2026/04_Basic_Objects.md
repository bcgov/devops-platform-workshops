# Basic Objects

In this section, we'll create a very simple web page and run in on OpenShift by creating an `python` server. 

We'll use an existing container image of `python` and run it inside a pod on OpenShift. 

We'll use the `deployment` object in OpenShift to create our pod and give it instructions. 

We'll also create the other objects needed to allow the pod to be accessed from outside OpenShift, a: 
- `service`
- `route` 
- `network policy` 

## Create a deployment

In the web console, switch to your `$LICENSEPLATE-dev` namespace. 

Click the `+` icon to create a new object from YAML. 

Paste in the following YAML and create the object:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: python-html-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: python-html-demo
  template:
    metadata:
      labels:
        app: python-html-demo
    spec:
      containers:
      - name: python
        image: python:3.11
        command:
          - /bin/sh
          - -c
          - |
            mkdir -p /tmp/www && cp /tmp/html/* /tmp/www/ && python -m http.server 8080 --directory /tmp/www
        ports:
          - containerPort: 8080
        volumeMounts:
          - name: html-volume
            mountPath: /tmp/html
      volumes:
      - name: html-volume
        configMap:
          name: html-page
EOF
```

This will create a deployment and generate our pod, but it won't work just yet. Click on your deployment's name in the topology menu, then again on the name in the right pane. Click the 'pods' tab. Notice that pod is not running. If you click the 'logs' menu, you can see some information about why that could be. 

## Create a configmap

Note at the bottom of the YAML we just created, it references a `configmap` named `html-page`. This `configmap` doesn't exist yet. That's what caused our error. So, let's create it. The purpose of this `configmap` will be to hold our basic html file for our web server to run. 

Click the `+` icon to create a new object from YAML. Paste in the following YAML and create the object:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: html-page
data:
  index.html: |
    <html>
    <h1>Hello OpenShift</h1>
    <p>Static HTML running via Python!</p>
    </html>
```

After a few moments, our `deployment` will restart, this time with the configmap available. 

## More objects

We still need some more objects to make our pod accessible

### Service
Next, we'll need to create a service. A service gives us a stable IP address where our pods from our `deployment` can be reached, even if the individual pods are deleted or recreated.  

We'll use the command line to create the service for our demo website. 

`oc expose deployment/python-html-demo --port=8080`
### Route
Next, we'll create a secure `https://` route to our `deployment`: 

```
oc expose svc/python-html-demo --name=python-html-demo-secure --port=8080 --tls-termination=edge
```

Check the route you created with: 

`oc get route python-html-demo-secure`


### NetworkPolicy

Finally, let's make a network policy to allow traffic to our pod so we can see our website! 

This time, we'll create the YAML file for the Network Policy using the `oc apply` command. 



```
cat <<EOF | oc apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-8080
spec:
  podSelector:
    matchLabels:
      app: python-html-demo
  policyTypes:
  - Ingress
  ingress:
  - ports:
    - protocol: TCP
      port: 8080
    from:
    - podSelector: {}
EOF
```
