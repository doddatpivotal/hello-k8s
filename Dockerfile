FROM openjdk:8-jre-alpine

RUN apk add --no-cache curl

ADD target/hello-k8s-v1.jar app.jar
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-Xmx512m", "-jar", "/app.jar"]
