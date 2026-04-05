package com.cinema.movie.repository;

import com.cinema.movie.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByUserId(Long userId);
    Optional<Order> findByOrderNo(String orderNo);
    List<Order> findByStatus(String status);
    List<Order> findBySessionId(Long sessionId);
    
    @Query("SELECT o FROM Order o JOIN FETCH o.user JOIN FETCH o.session s JOIN FETCH s.movie JOIN FETCH s.hall LEFT JOIN FETCH o.seats WHERE o.id = :id")
    Optional<Order> findByIdWithDetails(@Param("id") Long id);
}
