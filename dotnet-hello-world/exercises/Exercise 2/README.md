# Exercise 2

### Fork and Clone the example repository

using ssh:

```
git clone git@github.com:appvia/kore-example-apps.git
```

using https:

```
git clone https://github.com/appvia/kore-example-apps.git
```

The Git repositroy contains the demo application we will be using throughout this workshop under **kore-example-apps/dotnet-hello-world/src/**

### Dockerfile

Examine the Dockerfile in **/dotnet-hello-world**

### Build A Container

```
➜  ~ cd dotnet-hello-world

➜  ~ build -t hello-world:v0.1 .
```

You just built your container! Docker performs each action in the Dockerfile in sequence on the newly created container, this results in an image we are able to use.

If you build an image, by default it will just get a hexadecimal ID. Using the `-t` switch with `docker build` we can give the image a human-readable name.

Let's see if it works:

### Run Your Container

```
➜  ~ docker run -p 8080:80 hello-world:v0.1
```

You are now running your own copy of the demo application, you can check it by navigating to http://localhost:8080

## Exercise 2 - Stretch

### Get Creative

Make some changes to the source code, be as creative as you like! Rebuild the image and run it.

### Repositories

Docker can be used perfectly well by building and running local images but it more useful if you push these images to a `container registry` This allows you to store images and retrieve them using a unique name.

For now, let's use Docker Hub as it is simple for us to get setup. If you do not have an account, follow the instructions at https://hub.docker.com

Once you have an account setup you will need to connect your local Docker daemon with  Docker Hub. If this is your first time you will need to enter `YOUR_DOCKER_ID` and `YOUR_DOCKER_PASSWORD`

```
➜  ~ docker login
Authenticating with existing credentials...
Login Succeeded
```

To push your local image to the registry, it needs to be named using the following format: `YOUR_DOCKER_ID/dotnet-hello-world`

In order to do this you don't need to rebuild the image, we can just tag it:

```
➜  ~ docker tag <MY-IMAGE-NAME> YOUR_DOCKER_ID/dotnet-hello-world
```

Now you can push the image to Docker Hub

```
➜  ~ docker push YOUR_DOCKER_ID/dotnet-hello-world
```

You will notice that we are using Docker Hub here and used quay.io on an earlier example. We will be using a different registry in our pipeline later on but the principle is the same, it is somewhere to store our images (both public and private)