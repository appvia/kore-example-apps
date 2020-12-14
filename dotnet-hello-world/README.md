# dotnet-hello-world

An ASP .NET Core 3.1 web application running on an Alpine Linux Operating System in a Docker container.

## Create ASP.NET Core Web App

```
dotnet new webapp -o dotnet-hello-world -n NetCore.Docker
```

All templates available [here](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-new).

## Build and package the application

```
docker build -t dotnet-core-hello-world .
```

More information available [here](https://docs.docker.com/engine/examples/dotnetcore/).

## Deploy the application

### Docker

```
docker run --name dotnet-core-hello-world -d -p 8080:80 dotnet-core-hello-world
```

### Helm

```
helm install dotnet-hello-world charts/dotnet-hello-world -n ${NAMESPACE}
kubectl port-forward service/dotnet-hello-world 8080 8080 -n ${NAMESPACE}
```

### Helm Flux Operator

Create a secret with the username and password that give access to the Git repository:
```
kubectl create secret generic git-https-credentials \
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

## View the web page

Go to http://localhost:8080 in a web browser.
