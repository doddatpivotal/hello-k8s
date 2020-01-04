Build and publish our demo container
    Step 1: Introduce the code
    Step 2: Build and publish
        mvn deploy
Explore the cluster
    Step 1: Introduce Kubectl
        introduction to kubectl
    Step 2: Cluster info
        `kubectl version`
        `kubectl cluster-info`
        `kubectl get node -o wide`
Deploy an app
    Step 1: Deploy the app
        kubectl run hello-k8s --image=dpfefferatpivotal/hello-k8s:v1 --port=8080 --record
        kubectl get deployments
    Step 2: View the app
        export POD_NAME=$(kubectl get pods -o json | jq .items[0].metadata.name -r)
        kubectl proxy
        curl http://localhost:8001
        curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/    
Explore the app
    Step 1: Logs
        kubectl logs $POD_NAME
    Step 2: Executing a command
        kubectl exec $POD_NAME env
        kubectl exec -ti $POD_NAME bash
        ls /usr/shared/myservice
        exit
Expose the app publicly
    Step 1: Create a new service
        kubectl get pods
        kubectl get services
        kubectl expose deployment/hello-k8s --type=NodePort --port=8080
        kubectl get services
        kubectl describe service/hello-k8s
        export NODE_PORT=$(kubectl get services/hello-k8s -o 'jsonpath={.spec.ports[0].nodePort}')
        export NODE_HOST=$(kubectl get node -o 'jsonpath={.items[0].status.addresses[0].address}')
        curl $NODE_HOST:$NODE_PORT
Scale the app
    Step 1: Scaling a deployment
        kubectl get deployments
        kubectl scale deployment/hello-k8s --replicas 4
        kubectl get deployments
        kubectl get pods -o wide
        kubectl describe deployment/hello-k8s
    Step 2: Load balancing
        curl $NODE_HOST:$NODE_PORT
    Step 3: Scale down
        kubectl scale deployment/hello-k8s --replicas 2
        kubectl get deployments
        kubectl get pods -o wide
Update the app
    Step 1: Update the version of the app
        kubectl describe pod // see the image
        kubectl set image deployment/hello-k8s hello-k8s=dpfefferatpivotal/hello-k8s:v2 --record
        kubectl get pods
    Step 2: Verify an Update
        curl $NODE_HOST:$NODE_PORT
    Step 3: See deployment rollout
        kubectl rollout status deployment hello-k8s
        kubectl rollout history deployment hello-k8s
    Step 3: failed update
        kubectl set image deployment/hello-k8s hello-k8s=dpfefferatpivotal/hello-k8s:v3 --record
        kubectl rollout status deployment hello-k8s
        kubectl rollout history deployment hello-k8s
        kubectl rollout undo deployment/hello-k8s
Self Healing
    Step 1: Simiulate failure and see result
        //in a new window
        watch kubectl get pods
        kubeclt delete pod $POD_NAME
Observability
    Step 1: Checkout the dashboard
        kubectl proxy
        http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#
A little more realistic
    Step 2: Create a new namespace
        kubectl create namespace redis-chat
        kubectl config set-context ks-cluster-non-prod --namespace=redis-chat
    Step 1: Manifest Configurationk
        // View the diagram
        // View the yaml
        kubectl apply -f redis-chat.yaml
        kubectl get pods
        kubectl get services
        export NODE_PORT=$(kubectl get services/redis-chat-web-service -o 'jsonpath={.spec.ports[0].nodePort}')
        export NODE_HOST=$(kubectl get node -o 'jsonpath={.items[0].status.addresses[0].address}')

