package com.francisco.profileProject.repositories;

import org.hibernate.query.Page;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;

import com.francisco.profileProject.models.UserProfile;

import java.lang.StackWalker.Option;
import java.util.List;
import java.util.Optional;


public interface UserProfileRepository extends CrudRepository<UserProfile, Long> {

    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
    UserProfile findByUsername(String username);
    List<UserProfile> findAll();
    Long getIdByUsername(String username);
}
