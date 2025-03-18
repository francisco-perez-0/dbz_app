package com.francisco.profileProject.repositories;

import org.springframework.data.repository.CrudRepository;

import com.francisco.profileProject.models.Card;
import com.francisco.profileProject.models.UserCard;
import java.util.List;


public interface UserCardRepository extends CrudRepository<UserCard, Long>{

    List<UserCard> findByUserId(Long userId);
    List<Card> findCardsByUserId(Long userId);
    List<Long> findCardIdsByUserId(Long userId);
}
