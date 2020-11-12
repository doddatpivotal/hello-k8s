# Hello K8s Demo

## Build and publish our demo container

1. Introduce the code
2. Modify the src/main/resources/application.properties and set name to your name
3. Build and publish

```bash
./mvnw package
docker build -t harbor.dorn.tkg-aws-e2-lab.winterfell.live/hello-k8s/hello-k8s:v1 .
docker run -d -p 8080:8080 harbor.dorn.tkg-aws-e2-lab.winterfell.live/hello-k8s/hello-k8s:v1
docker ps
#docker logs <container_id>
docker logs $(docker ps | grep hello-k8s | awk '{print $(1)}')
curl localhost:8080
#docker stop <container_id>
docker stop $(docker ps | grep hello-k8s | awk '{print $(1)}')
docker push harbor.dorn.tkg-aws-e2-lab.winterfell.live/hello-k8s/hello-k8s:v1
```

4. Modify the src/main/resources/application.properties and set version to `v2`

5. Build and publish

```bash
./mvnw package

# Do the same build as before...
docker build -t harbor.dorn.tkg-aws-e2-lab.winterfell.live/hello-k8s/hello-k8s:v2 .
docker push harbor.dorn.tkg-aws-e2-lab.winterfell.live/hello-k8s/hello-k8s:v2

# ...or you could use the Tanzu Build Service
kp image create hello-k8s \
  --tag harbor.dorn.tkg-aws-e2-lab.winterfell.live/hello-k8s/hello-k8s:v2 \
  --namespace tbs-project-hello-k8s \
  --local-path target/hello-k8s-0.0.1-SNAPSHOT.jar \
  --wait
```

## Explore the cluster

1. Introduce kubectl
2. Cluster info

```bash
kubectl version
kubectl cluster-info
kubectl get node -o wide
```

3. Kubectl config and user context

```bash
kubectl config get-contexts
kubectl config view --flatten --minify
```

## Deploy an app

1. Deploy the app

```bash
kubectl create deployment hello-k8s --image=harbor.dorn.tkg-aws-e2-lab.winterfell.live/hello-k8s/hello-k8s:v1 --port=8080
kubectl get deployments
```

2. View the app

```bash
# Get the name of the running pod
kubectl get pods

# Setup a proxy so that you can access the pod
kubectl proxy

# Open another terminal window have a look the kubenetes api server root endpoint
curl http://localhost:8001

# Get the first pod name from above
export POD_NAME=$(kubectl get pods | grep hello-k8s | head -1 | awk '{print $(1)}')
# Get your current default namespace
export NAMESPACE=$(kubectl config get-contexts | grep '*' | awk '{print $(5)}')

# You can use the kubernetes api server to make a request against the pod
curl http://localhost:8001/api/v1/namespaces/$NAMESPACE/pods/$POD_NAME:8080/proxy/    
TODO: Dodd you have homework
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
export NODE_HOST=$(kubectl get node -o 'jsonpath={.items[0].status.addresses[1].address}')
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
kubectl set image deployment/hello-k8s hello-k8s=harbor.dorn.tkg-aws-e2-lab.winterfell.live/hello-k8s/hello-k8s:v2 --record
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
kubectl set image deployment/hello-k8s hello-k8s=harbor.dorn.tkg-aws-e2-lab.winterfell.live/hello-k8s/hello-k8s:v3 --record
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

## Ingress

1. Instead of Load Balancer service, let's save IPs and use an ingress

```bash
kubectl delete service hello-k8s
kubectl expose deployment/hello-k8s --type=ClusterIP --port=8080
kubectl apply -f k8s/ingress.yaml
kubectl get ingress
export INGRESS_URL=$(kubectl get ingress | grep hello-k8s | awk '{print $(3)}')
curl $INGRESS_URL
```
