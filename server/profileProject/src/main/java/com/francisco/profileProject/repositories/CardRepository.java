package com.francisco.profileProject.repositories;

import java.util.Optional;

import org.springframework.data.repository.CrudRepository;

import com.francisco.profileProject.models.Card;

public interface CardRepository extends CrudRepository<Card, Long> {

    Optional<Card> findById(Long id);
}