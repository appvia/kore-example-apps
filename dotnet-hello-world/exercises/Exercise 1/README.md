You'll need Git installed for this part of the workshop. If you're not sure if it is installed then run the following command:

`git version`

If you do not already have Git installed then follow the installation instructions at https://git-scm.com/download

# Exercise 1

We are going to use Docker to run a simple containerized application. If you have Docker installed feel free to carry on. Docker for desktop (Mac/Windows) can be found here https://www.docker.com/products/docker-desktop and Docker engine for Linux can be found here https://www.docker.com/products/container-runtime

We are using a demo application for this workshop to demonstrate with. You can download and run the application using a container image we prepaired earlier. Run the following command to try it:

`docker run --name dotnet-core-hello-world -d -p 8080:80 quay.io/appvia/dotnet-hello-world`

Now point your browser to http://localhost:8080 to see our example app.

Notice the `-d` argument in the command above, this means we are running the container in the background. 

![alt text](https://codefresh.io/wp-content/uploads/2017/06/docker-run-fg-bg.png)

You are able to stop the container by first getting the `CONTAINER ID`

```
➜  ~ docker ps
CONTAINER ID   IMAGE                               
a9f47bf96a4f   quay.io/appvia/dotnet-hello-world`
```

Now use the `CONTAINER ID` to stop the container

```
➜  ~ docker stop a9f47bf96a4f
```

It is recommended to name your container using the `--name={container_name}` flag when running a container in the background so that it can be referred to by name in follow-on commands. Start the container using its name.

```
➜  ~ docker start dotnet-core-hello-world
```

Spend some time controlling the container via its name:

```
Get Logs: docker logs dotnet-core-hello-world
Start Container: docker start dotnet-core-hello-world
Stop Container: docker stop dotnet-core-hello-world
Delete Container: docker rm dotnet-core-hello-world
```

Once you are finished make sure to remove the container to keep everything clean and tidy.

## Exercise 1 - Stretch

Run the container in the **foreground** and ensure that it is removed and cleaned up once you exit the process `Ctrl+C` hint: `--rm` is the flag you will need