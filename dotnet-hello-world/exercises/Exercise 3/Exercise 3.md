# Exercise 3

Now that we have explored building, running and pushing container images, let's get a little more adventurous and run it in Kubernetes.

There are many ways to get a Kubernetes cluster but we are going to use Kore to simplify the process and give us a "real world" development cluster we can deploy to.

First off, we need to login to the Kore platform from the CLI using `kore login` this will take you to the Kore login portal, use the credentials provided to you. Once this is done we need to set our Kubernetes context, luckily the platform makes this very easy for us! `kore kubeconfig -t <TEAM_NAME>`

Let's start off by running the image you built earlier. If you didn't manage to push and image to a repository you can use our example instead

```
➜  ~ kubectl run dotnet-hello-world --image=quay.io/appvia/dotnet-hello-world --port=8080 --labels app=hello-world
pod/dotnet-hello-world created
```

You can now view your running pods with 

```
➜  ~ kubectl get pods --selector app=hello-world
NAME                 READY   STATUS    RESTARTS   AGE
dotnet-hello-world   1/1     Running   0          80s
```

Now remove the pod using 

```
➜  ~ kubectl delete pod dotnet-hello-world
pod "dotnet-hello-world" deleted
```

Using the `kubectl run` command is useful but limited. If you wanted to change the spec: image name or version. You would need to delete your Deployment and create a new one.

Kubernetes is declaritive, reconciling actual and desired state, all we need to do is change the desired state and Kubernetes will do the rest for us.

We will now deploy our application using YAML manifest files. We have provided two options for this section, pick which one feels best for you.

First off we need to create a namespace. We can either do this via the CLI 

```
➜  ~ kore create namespace <YOUR_INITIALS> -t <TEAM_NAME>
```

Alternatively you can login to the Kore UI https://portal.example.com select your cluster and create namespace

Now export this namespace to a variable `NAMESPACE="<YOUR_NAMESPACE>"`

```
cat <<EOF | kubectl -n ${NAMESPACE} apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dotnet-core-hello-world-deployment
spec:
  selector:
    matchLabels:
      app: dotnet-core-hello-world
  replicas: 2
  template:
    metadata:
      labels:
        app: dotnet-core-hello-world
    spec:
      containers:
      - name: dotnet-core-hello-world
        image: quay.io/appvia/dotnet-hello-world
        ports:
        - name: http
          containerPort: 80
          protocol: TCP
EOF
```
```
cat <<EOF | kubectl -n ${NAMESPACE} apply -f -
apiVersion: v1
kind: Service
metadata:
  name: dotnet-core-hello-world
  labels:
    run: dotnet-core-hello-world
spec:
  ports:
  - port: 8080
    targetPort: http
    protocol: TCP
    name: http
  selector:
    app: dotnet-core-hello-world
EOF
```

```
cat <<EOF | kubectl -n ${NAMESPACE} apply -f -
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: dotnet-core-hello-world-ingress
  annotations:
    kubernetes.io/ingress.class: "external"
    cert-manager.io/cluster-issuer: "prod-le-dns01"
spec:
  rules:
  - host: tmf.demo-eks.demo.teams.demo.kore.appvia.io
    http:
      paths:
      - backend:
          serviceName: dotnet-core-hello-world
          servicePort: 8080
  tls:
  - hosts:
    - tmf.demo-eks.demo.teams.demo.kore.appvia.io
    secretName: dotnet-core-hello-world-ingress-tls
EOF
```
