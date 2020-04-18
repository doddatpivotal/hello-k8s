# Hello K8s Demo

## Build and publish our demo container

1. Introduce the code
2. Build and publish

```bash
mvn package
docker build -t dpfefferatpivotal/hello-k8s:v1 .
docker run -p -d 8080:8080 dpfefferatpivotal/hello-k8s:v1
docker ps
docker logs <container_id>
curl localhost:8080
docker stop <container_id>
docker push dpfefferatpivotal/hello-k8s:v1
```

## Explore the cluster

1. Introduce kubectl
2. Cluster info

```bash
kubectl version
kubectl cluster-info
kubectl get node -o wide
```

## Deploy an app

1. Deploy the app

```bash
kubectl run hello-k8s --image=dpfefferatpivotal/hello-k8s:v1 --port=8080 --record
kubectl get deployments
```

2. View the app

```bash
export POD_NAME=$(kubectl get pods -o json | jq .items[0].metadata.name -r)
export NAMESPACE=???
kubectl proxy
curl http://localhost:8001
curl http://localhost:8001/api/v1/namespaces/$NAMESPACE/pods/$POD_NAME/proxy/    
```

## Explore the app

1. Logs

```bash
kubectl logs $POD_NAME
```

2. Executing a command

```bash
kubectl exec $POD_NAME env
kubectl exec -ti $POD_NAME -- /bin/sh
ls
exit
```

## Expose the app publicly

1. Create a new service

```bash
kubectl get pods
kubectl get services
kubectl expose deployment/hello-k8s --type=NodePort --port=8080
kubectl get services
kubectl describe service/hello-k8s
export NODE_PORT=$(kubectl get services/hello-k8s -o 'jsonpath={.spec.ports[0].nodePort}')
export NODE_HOST=$(kubectl get node -o 'jsonpath={.items[0].status.addresses[0].address}')
curl $NODE_HOST:$NODE_PORT
```

## Scale the app

1. Scaling a deployment

```bash
kubectl get deployments
kubectl scale deployment/hello-k8s --replicas 4
kubectl get deployments
kubectl get pods -o wide
kubectl describe deployment/hello-k8s
```

2. Load balancing

```bash
curl $NODE_HOST:$NODE_PORT
```

3. Scale down

```bash
kubectl scale deployment/hello-k8s --replicas 2
kubectl get deployments
kubectl get pods -o wide
```

## Update the app

1. Update the version of the app

```bash
# see the image
kubectl describe pod
kubectl set image deployment/hello-k8s hello-k8s=dpfefferatpivotal/hello-k8s:v2 --record
kubectl get pods
```

2. Verify an Update

```bash
curl $NODE_HOST:$NODE_PORT
```

3. See deployment rollout

```bash
kubectl rollout status deployment hello-k8s
kubectl rollout history deployment hello-k8s
```

4. Failed update

```bash
kubectl set image deployment/hello-k8s hello-k8s=dpfefferatpivotal/hello-k8s:v3 --record
kubectl rollout status deployment hello-k8s
kubectl rollout history deployment hello-k8s
kubectl get pods
kubectl rollout undo deployment/hello-k8s
kubectl get pods
```

## Self Healing

1. Simulate failure and see result

```bash
#in a new window
watch kubectl get pods
kubectl delete pod $POD_NAME
```