FROM openjdk:16-alpine

RUN mkdir /usr/movieflixapp

COPY target/movieflix-kubernetes.jar /usr/movieflixapp/app.jar
WORKDIR /usr/movieflixapp

EXPOSE 8080

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar app.jar" ]
