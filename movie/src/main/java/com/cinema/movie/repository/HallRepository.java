package com.cinema.movie.repository;

import com.cinema.movie.entity.Hall;
import org.springframework.data.jpa.repository.JpaRepository;

public interface HallRepository extends JpaRepository<Hall, Long> {
    Hall findByName(String name);
}
