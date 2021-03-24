# Exercise 3

### Kubernetes 101 With Kore

Now that we have explored building, running and pushing container images, let's get a little more adventurous and run it in Kubernetes.

There are many ways to get a Kubernetes cluster but we are going to use Kore to simplify the process and give us a "real world" development cluster we can deploy to.

You'll need a couple of things to complete this section:

- kubectl https://kubernetes.io/docs/tasks/tools/
- Kore CLI https://docs.appvia.io/kore/cli
- Helm https://helm.sh/docs/intro/install/

### Configure Context

First off, we need to login to the Kore platform from the CLI using `kore login` this will take you to the Kore login portal, use the credentials provided to you. Once this is done we need to set our Kubernetes context, luckily the platform makes this very easy for us! `kore kubeconfig -t <TEAM_NAME>`

### Hello K8s

First off, set the namespace variable to your initials `export YOUR_INITIAL=""`

Now create the namespace

```
kubectl create namespace $YOUR_INITIAL
```

Let's start off by running the image you built earlier. If you didn't manage to push and image to a repository you can use our example instead

```
➜  ~ kubectl run dotnet-hello-world --image=quay.io/appvia/dotnet-hello-world --port=8080 --labels app=hello-world -n $YOUR_INITIAL
pod/dotnet-hello-world created
```
### View Pods

You can now view your running pods with 

```
➜  ~ kubectl get pods --selector app=hello-world -n $YOUR_INITIAL
NAME                 READY   STATUS    RESTARTS   AGE
dotnet-hello-world   1/1     Running   0          80s
```

Now remove the pod using 

```
➜  ~ kubectl delete pod dotnet-hello-world - $YOUR_INITIAL
pod "dotnet-hello-world" deleted
```

### Manifests

Using the `kubectl run` command is useful but limited. If you wanted to change the spec: image name or version. You would need to delete your Deployment and create a new one.

Kubernetes is declaritive, reconciling actual and desired state, all we need to do is change the desired state and Kubernetes will do the rest for us.

We will now deploy our application using YAML manifest files. We have provided two options for this section, pick which one feels best for you.



First off we need to create a namespace. We can either do this via the CLI 

```
➜  ~ kore create namespace $YOUR_INITIAL -t <TEAM_NAME>
```

Alternatively you can login to the Kore UI https://portal.example.com select your cluster and create namespace

Now export this namespace to a variable `NAMESPACE="<YOUR_NAMESPACE>"`

The first thing we need to do is create a deployment, you can either do this as below or use the example manifests provides

```
kubectl -n ${NAMESPACE} apply -f deployment.yaml
```

Or...

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
  replicas: 1
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

You can take a look at what has been created by running

```
kubectl get all -n $NAMESPACE
```

we can scale our deployment by running:

```
kubectl scale --current-replicas=1 --replicas=3 deployment/dotnet-core-hello-world-deployment -n $NAMESPACE
```

Now delete a pod using `kubectl delete pod` its `NAME` and make sure you reference your `namespace`

What happens? Is it what you expected?

Next, we want to create a network connection to our pod(s) due to us potentially having multiple pods that will also get new IP addresses on restart we can use a service resource to give us an unchanging IP and routing to matching our pod(s).

```
kubectl -n ${NAMESPACE} apply -f service.yaml
```

Or...

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
Services are useful for routing internal traffic but what about external traffic? How do we also handle secure connections using TLS? How do we use external DNS? This is where the `ingress` resource is used. Things are now getting a bit more complicated but luckily Kore can handle this for you.

We are now going to walkthrough the Kore UI to create Ingress, using Kore managed TLS and external DNS.
