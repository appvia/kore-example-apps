# Exercise 4

Helm Placeholder

### Helm

```
helm install dotnet-hello-world charts/dotnet-hello-world -n ${NAMESPACE}
kubectl port-forward service/dotnet-hello-world 8080 8080 -n ${NAMESPACE}
```

### Helm Flux Operator

Create a secret with the username and password that give access to the Git repository:
```
kubectl -n ${NAMESPACE} create secret generic git-https-credentials \
    --from-literal=username=<username> \
    --from-literal=password=<password>
```

To install the Helm chart using the Helm Operator, create a HelmRelease resource on the cluster:
```
cat <<EOF | kubectl -n ${NAMESPACE} apply -f -
apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: dotnet-hello-world
  namespace: ${NAMESPACE}
spec:
  releaseName: dotnet-hello-world
  chart:
    git: https://github.com/appvia/kore-operate-installer.git
    ref: main
    path: examples/dotnet-hello-world/charts/dotnet-hello-world
    secretRef:
      name: git-https-credentials
EOF
```