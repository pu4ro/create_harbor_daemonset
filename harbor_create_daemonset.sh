#!/bin/bash

NAMESPACE=daemonset-harbor

# 네임스페이스가 없으면 생성
kubectl get ns $NAMESPACE >/dev/null 2>&1 || kubectl create ns $NAMESPACE

IMAGES=(
"cr.makina.rocks/external-hub/goharbor/harbor-core:v2.8.2"
"cr.makina.rocks/external-hub/goharbor/harbor-db:v2.8.2"
"cr.makina.rocks/external-hub/goharbor/harbor-jobservice:v2.8.2"
"cr.makina.rocks/external-hub/goharbor/harbor-portal:v2.8.2"
"cr.makina.rocks/external-hub/goharbor/harbor-registryctl:v2.8.2"
"cr.makina.rocks/external-hub/goharbor/nginx-photon:v2.8.2"
"cr.makina.rocks/external-hub/goharbor/notary-server-photon:v2.8.2"
"cr.makina.rocks/external-hub/goharbor/notary-signer-photon:v2.8.2"
"cr.makina.rocks/external-hub/goharbor/redis-photon:v2.8.2"
"cr.makina.rocks/external-hub/goharbor/registry-photon:v2.8.2"
)

for IMAGE in "${IMAGES[@]}"; do
  SHORT=$(echo $IMAGE | awk -F/ '{print $NF}' | sed 's/:/-/g' | sed 's/\./-/g')
  DS_NAME="keep-image-${SHORT,,}"

  cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: $DS_NAME
  namespace: $NAMESPACE
spec:
  selector:
    matchLabels:
      app: $DS_NAME
  template:
    metadata:
      labels:
        app: $DS_NAME
    spec:
      containers:
      - name: sleeper
        image: $IMAGE
        command: ["tail", "-f", "/dev/null"]
        resources:
          requests:
            memory: "8Mi"
            cpu: "5m"
          limits:
            memory: "16Mi"
            cpu: "20m"
      tolerations:
      - operator: "Exists"
      terminationGracePeriodSeconds: 0
EOF
done

