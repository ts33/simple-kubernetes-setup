
# Overview 

This repository is an example setup of a simple API server with a database hosted on Kubernetes.
- The API server (NodeJS) serves a simple endpoint that returns a string retrieved from the database.
- The database runs on postgres with a persistent volume and has only one instance.
- The db-seed container uses shell scripts and sql files to initialize the database schema and data.

<image diagram>

Directory Struture
- **./app**: contains nodejs source code for the api server.
- **./db-seed**: contains sql and shell scripts used to initialize the database schema and data.
- **./kube**: contains kubernetes and kustomize yaml files based on a base/overlay format.
- **./dockerfile.***: dockerfiles for the containers that are used in the kubernetes cluster.
- **./*.sh**: scripts for starting and shutting down the kubernetes cluster.


# Development
## Requirements
- [Minikube](https://minikube.sigs.k8s.io/docs/start/) (works with version 1.24.0)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)  (works with version 1.21)
- [Kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/)
- [Docker](https://docs.docker.com/get-docker/)


## Startup
- set the environment variable POSTGRES_SECRET `export POSTGRES_SECRET=<value>`
- build and deploy all resources with the command `./startup.sh`
- visit the url http://localhost:7000 on a browser or run `curl http://localhost:7000`

> The startup and shutdown scripts deploy the dev environment. To deploy the prod environment, change both scripts to point to `./kube/overlays/prod` instead of `./kube/overlays/dev`
## Shutdown
run `./shutdown.sh` to tear down all resources.


# Troubleshooting

## Simple API Container
You can tail the Simple API logs with the following steps:
- run the command `kubectl get pods` to get the relevant pod name
- run `kubectl logs -f {pod_name}` to tail the logs.

You can also run the node app docker image outside of kubernetes with the following steps:
- build the image with `docker build --no-cache -t node-app -f dockerfile.app .`
- run the image with `docker run -p 8000:8000 --rm node-app`

## Init Container
If the init container runs into errors, you can dive in the logs with the following steps:
- run the command `kubectl get pods` to get the relevant pod name.
- run `kubectl logs pods {pod_name} -c init-db` to investigate the logs.

You can also run the db-seed docker image outside of kubernetes with the following steps:
- build the image with `docker build --no-cache -t db-seed -f dockerfile.db-seed .`
- run the image with `docker run --rm db-seed`

## Database Connection
You can also connect directly to the database to look at the records for troubleshooting purposes.
- forward the port using the command `kubectl port-forward service/postgres 25432:5432`.
- open a local psql client `psql "postgresql://postgres:${POSTGRES_SECRET}@localhost:25432/postgres"`.

