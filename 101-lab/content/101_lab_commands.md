# List of OpenShift 101 Lab Commands 
## Builds
```
oc project d8f105-tools
oc -n d8f105-tools new-build https://github.com/BCDevOps/devops-platform-workshops-labs/ --context-dir=apps/rocketchat --name=rocketchat-mattspencer
oc -n d8f105-tools logs -f bc/rocketchat-mattspencer
```
## Deployment
```
oc -n d8f105-tools tag rocketchat-mattspencer:latest rocketchat-mattspencer:dev
oc -n d8f105-dev new-app d8f105-tools/rocketchat-mattspencer:dev --name=rocketchat-mattspencer -l ocp101=participant
oc -n d8f105-dev set resources deployment/rocketchat-mattspencer --requests='cpu=500m,memory=512Mi' --limits='cpu=1000m,memory=1024Mi'
oc -n d8f105-tools policy add-role-to-user system:image-puller system:serviceaccount: d8f105-dev:default
oc scale deployment/rocketchat-mattspencer --replicas=0
oc scale deployment/rocketchat-mattspencer --replicas=1
oc -n d8f105-dev tag d8f105-tools/rocketchat-mattspencer:dev rocketchat-mattspencer:dev
oc -n d8f105-dev set image deployment/rocketchat-mattspencer rocketchat-mattspencer=rocketchat-mattspencer:dev
oc -n d8f105-dev process -f https://raw.githubusercontent.com/BCDevOps/devops-platform-workshops/master/101-lab/mongo-ephemeral-template.yaml --parameters=true
oc -n d8f105-dev process -f https://raw.githubusercontent.com/BCDevOps/devops-platform-workshops/master/101-lab/mongo-ephemeral-template.yaml -p MONGODB_USER=dbuser MONGODB_PASSWORD=dbpass MONGODB_ADMIN_PASSWORD=admindbpass MONGODB_DATABASE=rocketchat MONGODB_NAME=mongodb-mattspencer -l ocp101=participant | oc -n d8f105-dev create -f - --dry-run=client
oc -n d8f105-dev process -f https://raw.githubusercontent.com/BCDevOps/devops-platform-workshops/master/101-lab/mongo-ephemeral-template.yaml -p MONGODB_USER=dbuser MONGODB_PASSWORD=dbpass MONGODB_ADMIN_PASSWORD=admindbpass MONGODB_DATABASE=rocketchat MONGODB_NAME=mongodb-mattspencer -l ocp101=participant | oc -n d8f105-dev create -f -

oc -n d8f105-dev set env deployment/rocketchat-mattspencer "MONGO_URL=mongodb://dbuser:dbpass@mongodb-mattspencer:27017/rocketchat"
```
_STRETCH_ 

```
oc -n d8f105-dev rollout pause deployment/rocketchat-mattspencer 
oc -n d8f105-dev patch deployment/rocketchat-mattspencer -p '{"spec":{"template":{"spec":{"containers":[{"name":"rocketchat-mattspencer", "env":[{"name":"MONGO_USER", "valueFrom":{"secretKeyRef":{"key":"database-user", "name":"mongodb-mattspencer"}}}]}]}}}}'
oc -n d8f105-dev patch deployment/rocketchat-mattspencer -p '{"spec":{"template":{"spec":{"containers":[{"name":"rocketchat-mattspencer", "env":[{"name":"MONGO_PASS", "valueFrom":{"secretKeyRef":{"key":"database-password", "name":"mongodb-mattspencer"}}}]}]}}}}'
oc -n d8f105-dev set env deployment/rocketchat-mattspencer 'MONGO_URL=mongodb://$(MONGO_USER):$(MONGO_PASS)@mongodb-mattspencer:27017/rocketchat'
oc -n d8f105-dev rollout resume deployment/rocketchat-mattspencer 
oc -n d8f105-dev get deployment/rocketchat-mattspencer -o json | jq '.spec.template.spec.containers[].env'
```
## Create a Route for your Rocket.Chat App
```
oc -n d8f105-dev expose svc/rocketchat-mattspencer
OR
oc -n d8f105-dev create route edge rocketchat-mattspencer --service=rocketchat-mattspencer --insecure-policy=Redirect

oc -n d8f105-dev set probe deployment/rocketchat-mattspencer --readiness --get-url=http://:3000/ --initial-delay-seconds=15
oc -n d8f105-dev set env deployment/rocketchat-mattspencer TEST=BAR
```
## Resource Requests and Limits 
```
oc -n d8f105-dev set resources deployment/rocketchat-mattspencer --requests=cpu=65m,memory=100Mi --limits=cpu=65m,memory=100Mi
oc -n d8f105-dev rollout restart deployment/rocketchat-mattspencer
time oc -n d8f105-dev rollout restart deployment/rocketchat-mattspencer
oc -n d8f105-dev set resources deployment/rocketchat-mattspencer --requests=cpu=1000m,memory=512Mi --limits=cpu=1000m,memory=1024Mi
oc -n d8f105-dev rollout restart deployment/rocketchat-mattspencer
time oc -n d8f105-dev rollout restart deployment/rocketchat-mattspencer
oc -n d8f105-dev set resources deployment/rocketchat-mattspencer --requests=cpu=150m,memory=256Mi --limits=cpu=200m,memory=400Mi
```
## Application Availability 
```
oc -n d8f105-dev scale deployment/rocketchat-mattspencer --replicas=2
oc -n d8f105-dev get pods --field-selector=status.phase=Running -l deployment=rocketchat-mattspencer -o wide
oc -n d8f105-dev get pods -o wide | grep rocketchat-mattspencer
oc -n d8f105-dev get pods --field-selector=status.phase=Running -l deployment=rocketchat-mattspencer -o name | head -1 | xargs -I {} oc -n d8f105-dev delete {}
brew install watch
watch -dg -n 1 curl -fsSL https://rocketchat-mattspencer-d8f105-dev.apps.silver.devops.gov.bc.ca/api/info
oc -n d8f105-dev get pods --field-selector=status.phase=Running -l deployment=rocketchat-mattspencer -o name | head -1 | xargs -I {} oc -n d8f105-dev delete {}
watch -dg -n 1 curl -fsSL https://rocketchat-mattspencer-d8f105-dev.apps.silver.devops.gov.bc.ca/api/info
watch -dg -n 1 curl -fsSL https://rocketchat-mattspencer-dev.d8f105-dev.apps.silver.devops.gov.bc.ca/api/info
```

## Autoscaling
```
oc -n d8f105-dev autoscale deployment/rocketchat-mattspencer --min 1 --max 10 --cpu-percent=10
oc -n d8f105-dev delete hpa/rocketchat-mattspencer
```
## Persistent Storage 
```
oc -n d8f105-dev scale deployment/rocketchat-mattspencer deployment/mongodb-mattspencer --replicas=0
oc -n d8f105-dev scale deployment/mongodb-mattspencer --replicas=1
oc -n d8f105-dev scale deployment/rocketchat-mattspencer --replicas=1
oc -n d8f105-dev scale deployment/mongodb-mattspencer --replicas=0 
oc -n d8f105-dev rollout pause deployment/mongodb-mattspencer 
oc -n d8f105-dev get deployment/mongodb-mattspencer -o jsonpath='{.spec.template.spec.volumes[].name}{"\n"}' | xargs -I {} oc -n d8f105-dev set volumes deployment/mongodb-mattspencer --remove '--name={}'
oc -n d8f105-dev set volume deployment/mongodb-mattspencer --add --name=mongodb-mattspencer-data -m /var/lib/mongodb/data -t pvc --claim-name=mongodb-mattspencer-file
oc -n d8f105-dev scale deployment/mongodb-mattspencer --replicas=1 
oc -n d8f105-dev rollout resume deployment/mongodb-mattspencer
oc -n d8f105-dev scale deployment/rocketchat-mattspencer --replicas=0
oc -n d8f105-dev scale deployment/mongodb-mattspencer --replicas=0 
oc -n d8f105-dev rollout pause deployment/mongodb-mattspencer
oc -n d8f105-dev get deployment/mongodb-mattspencer -o jsonpath='{.spec.template.spec.volumes[].name}{"\n"}' | xargs -I {} oc -n d8f105-dev set volumes deployment/mongodb-mattspencer --remove '--name={}'
oc -n d8f105-dev set volume deployment/mongodb-mattspencer --add --name=mongodb-mattspencer-data -m /var/lib/mongodb/data -t pvc --claim-name=mongodb-mattspencer-file
oc -n d8f105-dev patch deployment/mongodb-mattspencer -p '{"spec":{"strategy":{"activeDeadlineSeconds":21600,"recreateParams":{"timeoutSeconds":600},"resources":{},"type":"Recreate"}}}'
oc -n d8f105-dev rollout resume deployment/mongodb-mattspencer
oc -n d8f105-dev rollout latest deployment/mongodb-mattspencer
oc -n d8f105-dev scale deployment/mongodb-mattspencer --replicas=1 
oc -n d8f105-dev scale deployment/rocketchat-mattspencer --replicas=1
oc -n d8f105-dev delete pvc/mongodb-mattspencer-file-rwx
```
## Persistent Configurations
```
- name: rocketchat-mattspencer-volume
          configMap:
            name: rocketchat-mattspencer-configmap

oc -n d8f105-dev describe secret rocketchat-mattspencer-secret
oc -n d8f105-dev get secret rocketchat-mattspencer-secret -o yaml
```
## Event Streams

## Debugging Containers
```
oc -n [-dev] logs -f <pod name>
oc -n d8f105-dev scale deployment/mongodb-mattspencer --replicas=0 
oc -n d8f105-dev rollout restart deployment/rocketchat-mattspencer
oc -n d8f105-dev get pods
oc -n d8f105-dev debug <podname>
oc -n d8f105-dev get pods  | grep rocketchat-mattspencer
oc -n d8f105-dev port-forward rocketchat-mattspencer-597bd65475-nlrmw 8000:3000
```
