# Exercise 4

### Helm

You can now deploy applciations to Kubernetes using declaritive YAML but there is a lot of repitition such a name, selectors and ports. With HELM (and other package managers) we can specify a value once and then reference it wherever it should appear in the manifest files.

Helm should be installed at this point but if it isn't:

- Helm https://helm.sh/docs/intro/install/


```
helm install dotnet-hello-world charts/dotnet-hello-world -n ${NAMESPACE}
```

You can check what releases you have running any time, run `helm list`

```
helm list -n ${NAMESPACE}
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