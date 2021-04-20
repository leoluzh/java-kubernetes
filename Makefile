# defaul shell
SHELL = /bin/bash

# Rule "help"
.PHONY: help
.SILENT: help
help:
	echo "Use make [rule]"
	echo "Rules:"
	echo ""
	echo "build 		- build application and generate docker image"
	echo "run-db 		- run mysql database on docker"
	echo "run-app		- run application on docker"
	echo "stop-app	    - stop application"
	echo "stop-db		- stop database"
	echo "rm-app		- stop and delete application"
	echo "rm-db		    - stop and delete database"
	echo ""
	echo "k-setup		- init minikube machine"
	echo "k-deploy-db	- deploy mysql on cluster"
	echo "k-build-app	- build app and create docker image inside minikube"
	echo "k-deploy-app	- deploy app on cluster"
	echo ""
	echo "k-start		- start minikube machine"
	echo "k-all		    - do all the above k- steps"
	echo "k-stop		- stop minikube machine"
	echo "k-delete	    - stop and delete minikube machine"
	echo ""
	echo "check		    - check tools versions"
	echo "help		    - show this message"

build:
	./mvnw clean install; \
	docker build --force-rm -t movieflix-k8s .

run-db: stop-db rm-db
	docker run --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=123456 -e POSTGRES_USER=java -e POSTGRES_DBNAME=movieflixdb -d postgres:13.2

run-app: stop-app rm-app
	docker run --name movieflixapp -p 8080:8080 -d -e DATABASE_SERVER_NAME=postgres --link postgres:postgres movieflix-k8s:latest

stop-app:
	- docker stop movieflixapp

stop-db:
	- docker stop postgres

rm-app:	stop-app
	- docker rm movieflixapp

rm-db: stop-db
	- docker rm postgres

k-setup:
	minikube -p lambdasys.movieflix start --cpus 2 --memory=4096; \
	minikube -p lambdasys.movieflix addons enable ingress; \
	minikube -p lambdasys.movieflix addons enable metrics-server; \
	kubectl create namespace lambdasys-movieflix

k-deploy-db:
	kubectl apply -f k8s/postgres/;

k-build-app:
	./mvnw clean install; \
	docker build --force-rm -t movieflix-k8s .

k-build-image:
	eval $$(minikube -p dev.to docker-env) && docker build --force-rm -t movieflix-k8s .;

k-cache-image:
	minikube cache add movieflix-k8s;

k-deploy-app:
	kubectl apply -f k8s/app/;

k-delete-app:
	kubectl delete -f k8s/app/;

k-delete-db:
	kubectl delete -f k8s/postgres/;

k-start:
	minikube -p lambdasys.movieflix start;

k-all: k-setup k-deploy-db k-build-app k-build-image k-deploy-app

k-stop:
	minikube -p lambdasys.movieflix stop;

k-delete:
	minikube -p lambdasys.movieflix stop && minikube -p lambdasys.movieflix delete

check:
	echo "make version " && make --version && echo
	minikube version && echo
	echo "kubectl version" && kubectl version --short --client && echo

