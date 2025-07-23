#!/bin/bash
#
# set_up_kustomize.sh
# 
# Create a Kustomize app
# ----------------------

APP_NAME=my-kustomize-app

echo ""
echo -n "--> Run this script at the top level of your GitOps repository. Continue? [Yn] "
read INPUT
case $INPUT in
  Y | y | "")
    ;;
  *)
    echo "Canceling"
    exit 1
esac

echo "Creating directory tree ${APP_NAME}..."
mkdir -p ${APP_NAME}/base ${APP_NAME}/overlays/dev ${APP_NAME}/overlays/test ${APP_NAME}/overlays/prod

cat <<EOF > ${APP_NAME}/base/kustomization.yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
EOF

cat <<EOF > ${APP_NAME}/base/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd
spec:
  selector:
    matchLabels:
      app: httpd
  replicas: 3
  template:
    metadata:
      labels:
        app: httpd
    spec:
      containers:
        - name: httpd
          image: >-
            image-registry.openshift-image-registry.svc:5000/openshift/httpd:latest
          ports:
            - containerPort: 8080
              protocol: TCP
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
EOF

cat <<EOF > ${APP_NAME}/overlays/dev/kustomization.yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../../base
  - configmap.yaml
patches:
  - path: patch.deployment.yaml
EOF

cat <<EOF > ${APP_NAME}/overlays/dev/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: ${APP_NAME}
data:
  foo: bar
EOF

cat <<EOF > ${APP_NAME}/overlays/dev/patch.deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd
spec:
  replicas: 1
EOF

cat <<EOF > ${APP_NAME}/overlays/test/kustomization.yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../../base
patches:
  - path: patch.deployment.yaml
EOF

cat <<EOF > ${APP_NAME}/overlays/test/patch.deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd
spec:
  replicas: 2
EOF

cat <<EOF > ${APP_NAME}/overlays/prod/kustomization.yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../../base
EOF

echo ""
echo "Here is the layout of your new Kustomize app:
my-kustomize-app
├── base
│   ├── deployment.yaml
│   └── kustomization.yaml
└── overlays
    ├── dev
    │   ├── configmap.yaml
    │   ├── kustomization.yaml
    │   └── patch.deployment.yaml
    ├── prod
    │   └── kustomization.yaml
    └── test
        ├── kustomization.yaml
        └── patch.deployment.yaml

5 directories, 8 files
"
echo "Done"

