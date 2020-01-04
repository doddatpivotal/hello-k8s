package io.pivotal.hellok8s;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class HelloK8sApplication {

    public static void main(String[] args) {
        SpringApplication.run(HelloK8sApplication.class, args);
    }

}

@RestController
class HelloController {

    @Value("${HOSTNAME:no host}")
    String podname;

    String version = "v1";

    @GetMapping("/")
    public String hello() {
        return "Hello! You are running on pod " + podname + " and version is " + version + "." ;
    }

}

