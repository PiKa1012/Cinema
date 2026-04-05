package com.cinema.movie.repository;

import com.cinema.movie.entity.Session;
import org.springframework.data.jpa.repository.JpaRepository;
import java.time.LocalDateTime;
import java.util.List;

public interface SessionRepository extends JpaRepository<Session, Long> {
    List<Session> findByMovieId(Long movieId);
    List<Session> findByHallId(Long hallId);
    List<Session> findByStartTimeBetween(LocalDateTime start, LocalDateTime end);
    void deleteByHallId(Long hallId);
}
