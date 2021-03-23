# Exercise 4

### Helm

You can now deploy applications to Kubernetes using declarative YAML but there is a lot of repetition such as name, selectors and ports. With HELM (and other package managers) we can specify a value once and then reference it wherever it should appear in the manifest files.

Helm should be installed at this point but if it isn't:

- Helm https://helm.sh/docs/intro/install/

From the following directory `kore-example-apps/dotnet-hello-world/charts/dotnet-hello-world`

```
helm install dotnet-hello-world charts/dotnet-hello-world -n ${NAMESPACE}
```

You can check what releases you have running any time, run `helm list`

```
helm list -n ${NAMESPACE}
```

To clean up your release you can run `helm uninstall`

```
helm uninstall dotnet-hello-world -n ${NAMESPACE}
```

### Helm Flux Operator

If you want to take things a little further we can use the `HelmRelease` custom resource

First, we need to create a secret with the username and password that give access to your Git repository:
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
    git: https://github.com/<YOUR_ORG>/kore-example-apps.git
    ref: main
    path: dotnet-hello-world/charts/dotnet-hello-world/
    secretRef:
      name: git-https-credentials
EOF
```

You should now be able to list your Helm releases like before.
