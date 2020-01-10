fly -t lab set-pipeline -p hello-k8s -c ci/pipeline.yaml -l .secrets.yaml -n
fly -t lab unpause-pipeline -p hello-k8s