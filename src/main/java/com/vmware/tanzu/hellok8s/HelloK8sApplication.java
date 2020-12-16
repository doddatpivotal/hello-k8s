package com.vmware.tanzu.hellok8s;

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
    String hostname;

    @Value("${hello-k8s.name:Dodd}")
    String name;

    @Value("${hello-k8s.version:v1}")
    String version;

    @GetMapping("/")
    public String hello() {
        return "Hello " + name + "! You are running on pod " + hostname + " and version is " + version + "." ;
    }

}

