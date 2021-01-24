FROM adoptopenjdk/openjdk11:alpine-jre

RUN apk add --no-cache curl

ADD target/hello-k8s-0.0.1-SNAPSHOT.jar app.jar

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-Xmx512m", "-jar", "/app.jar"]
