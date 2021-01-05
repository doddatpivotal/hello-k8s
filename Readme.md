# Hello k8s

Example repo for build/deploy spring boot app to k8s with concourse.

## Demo Lab (Optional)

To use this as the basis of a kubernetes 101 demo, do the [prereqs](demo/demo-prereqs.md) and then follow this [guide](demo/demo-script.md).

## CI Lab (Optional)

If you would like to explore Concourse and a sample CI pipeline for this project, follow these instructions...

### Customization

Need to update the yamls in /k8s directory

- deployment.yaml to match image location
- ingress.yaml to match ingress url

### Create Params File

Create .secrets.yaml in the root.  See example

```yaml
# for docker hub
# registry-email: dpfeffer@pivotal.io
# registry-password: REDACTED_PASSWORD
# registry-url: registry.hub.docker.com/dpfefferatpivotal
# registry-username: dpfefferatpivotal
git-repo: https://github.com/doddatpivotal/hello-k8s.git
k8s-server: https://cluster1.tkg-vsphere-haas-261.winterfell.live:8443
registry-project: cody
registry-email: cody@winterfell.live
registry-password: REDACTED_PASSWORD
registry-url: harbor.stormsend.tkg-vsphere-haas-261.winterfell.live
registry-username: cody
# Get this token by ./scripts/get-token.sh
token: REDACTED_TOKEN
```

### Get token

Choose the target namespace to deploy your app and a service account name.

```bash
./scripts/get-token.sh <service_account_name> <namespace>
```

Replace update your .secrets file with token

### Deploy Pipeline

```bash
fly -t lab set-pipeline -p hello-k8s -c ci/pipeline.yaml -l .secrets.yaml -n
fly -t lab unpause-pipeline -p hello-k8s
```

### Test Service

```bash
curl hello-k8s-workspace6.ingress.stormsend.tkg-vsphere-haas-261.winterfell.live
```
