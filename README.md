# Java and Kubernetes

Show how you can move your spring boot application to docker and kubernetes.
This project is a demo for the series of posts on dev.to
https://dev.to/sandrogiacom/kubernetes-for-java-developers-setup-41nk

## Part one - base app:

### Requirements:

**Docker and Make (Optional)**

**Java 16**

Help to install tools:

* https://minikube.sigs.k8s.io/docs/start/
* https://kubernetes.io/docs/tasks/tools/

### Build and run application:

Spring boot and mysql database running on docker

**Clone from repository**
```bash
git clone https://github.com/leoluzh/java-kubernetes.git
```

**Build application**
```bash
cd java-kubernetes
mvn clean install
```

**Start the database**
```bash
make run-db
```

**Run application**
```bash
java -jar target/movieflix-kubernetes.jar
```

**Check**

http://localhost:8080/movieflix/api/v1/movies

http://localhost:8080/movieflix/api/v1/hello

**Check App Status**

http://localhost:8080/movieflix/actuator

http://localhost:8080/movieflix/actuator/health/liveness

http://localhost:8080/movieflix/actuator/health/readiness

http://localhost:8080/movieflix/actuator/info

http://localhost:8080/movieflix/actuator/prometheus

http://localhost:8080/movieflix/actuator/metrics

## Part two - app on Docker:

Create a Dockerfile:

```yaml
FROM openjdk:16-alpine
RUN mkdir /usr/movieflixapp
COPY target/movieflix-kubernetes.jar /usr/movieflixapp/app.jar
WORKDIR /usr/movieflixapp
EXPOSE 8080
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar app.jar" ]
```

**Build application and docker image**

```bash
make build
```

Create and run the database
```bash
make run-db
```

Create and run the application
```bash
make run-app
```

**Check**

http://localhost:8080/movieflix/api/v1/hello

Stop all:

`
docker stop postgres movieflixapp
`

## Part three - app on Kubernetes:

We have an application and image running in docker
Now, we deploy application in a kubernetes cluster running in our machine

Prepare

### Start minikube
`
make k-setup
`
 start minikube, enable ingress and create namespace lambdasys-movieflix

### Check IP

`
minikube -p lambdasys.movieflix ip
`

### Minikube dashboard

`
minikube -p lambdasys.movieflix dashboard
`

### Deploy database

create postgres deployment and service

`
make k-deploy-db
`

`
kubectl get pods -n lambdasys-movieflix
`

OR

`
watch k get pods -n lambdasys-movieflix
`


`
kubectl logs -n lambdasys-movieflix -f <pod_name>
`

`
kubectl port-forward -n lambdasys-movieflix <pod_name> 5432:5432
`

### Access kubernetes/cluster via ssh
`
minikube -p lambdasys-movieflix ssh
docker ps
docker images
`

## Build application and deploy

build app

`
make k-build-app
` 

create docker image inside minikube machine:

`
make k-build-image
`

OR

`
make k-cache-image
`  

create app deployment and service:

`
make k-deploy-app
` 

**Check**

`
kubectl get services -n lambdasys-movieflix
`

To access app:

`
minikube -p lambdasys.movieflix service -n lambdasys-movieflix movieflixapp --url
`

Ex:

* http://172.17.0.3:32594/movieflix/api/v1/movies
* http://172.17.0.3:32594/movieflix/api/v1/hello

## Check pods

`
kubectl get pods -n lambdasys-movieflix
`

`
kubectl -n lambdasys-movieflix logs movieflixapp-6ccb69fcbc-rqkpx
`

## Map to dev.local

get minikube IP
`
minikube -p lambdasys.movieflix ip
` 

Edit `hosts` 

`
sudo vim /etc/hosts
`

Replicas
`
kubectl get rs -n lambdasys-movieflix
`

Get and Delete pod
`
kubectl get pods -n lambdasys-movieflix
`

`
kubectl delete pod -n lambdasys-movieflix movieflixapp-f6774f497-82w4r
`

Scale
`
kubectl -n lambdasys-movieflix scale deployment/movieflixapp --replicas=2
`

Test replicas
`
while true
do curl "http://movieflix.local/movieflix/hello"
echo
sleep 2
done
`
Test replicas with wait

`
while true
do curl "http://movieflix.local/movieflix/wait"
echo
done
`

## Check app url
`minikube -p lambdasys.movieflix service -n lambdasys-movieflix movieflixapp --url`

Change your IP and PORT as you need it

`
curl -X GET http://movieflix.local/movieflix/api/v1/movies
`

## Part four - debug app:

add   JAVA_OPTS: "-agentlib:jdwp=transport=dt_socket,address=*:5005,server=y,suspend=n"
 
change CMD to ENTRYPOINT on Dockerfile

`
kubectl get pods -n=lambdasys-movieflix
`

`
kubectl port-forward -n=lambdasys-movieflix <pod_name> 5005:5005
`

## KubeNs and Stern

`
kubens lambdasys-movieflix
`

`
stern movieflixapp
` 

## Start all

`make k:all`


## References

https://kubernetes.io/docs/home/

https://minikube.sigs.k8s.io/docs/

## Useful commands

```
##List profiles
minikube profile list

kubectl top node

kubectl top pod <nome_do_pod>
```
