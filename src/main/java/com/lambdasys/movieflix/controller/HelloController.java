package com.lambdasys.movieflix.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.net.InetAddress;
import java.net.UnknownHostException;

@RestController
@RequestMapping("/api/v1/hello")
public class HelloController {

    @GetMapping
    public ResponseEntity<String> sayHello() throws UnknownHostException {
        InetAddress ip = InetAddress.getLocalHost();
        System.out.println("Your current host/IP address : " + ip);
        return ResponseEntity.ok().body("Hello " + ip);
    }

}
