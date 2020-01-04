FROM openjdk:8-jre-alpine

COPY . /app

ENTRYPOINT ["/usr/bin/java", "-jar", "/app/target/hello-k8s-v1.jar"]