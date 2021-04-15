package com.lambdasys.java.kubernetes.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/mem")
public class MemoryController {

    @GetMapping
    public ResponseEntity<String> stressMemory() throws InterruptedException {
        List<String> list = new ArrayList<>();
        byte[] b = new byte[1000000];
        for (int i = 1; i <= 200; i++) {
            Thread.sleep(500);
            list.add(new String(b));
            System.out.println("cont = " + i);
        }
        return ResponseEntity.ok("OK");
    }

}
