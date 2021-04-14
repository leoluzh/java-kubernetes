package com.lambdasys.java.kubernetes.persistence;

import com.lambdasys.java.kubernetes.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {

}

