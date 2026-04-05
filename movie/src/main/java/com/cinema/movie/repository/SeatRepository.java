package com.cinema.movie.repository;

import com.cinema.movie.entity.Seat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface SeatRepository extends JpaRepository<Seat, Long> {
    List<Seat> findByHallId(Long hallId);
    List<Seat> findByHallIdAndAvailable(Long hallId, Boolean available);
    List<Seat> findBySessionId(Long sessionId);
    List<Seat> findByHallIdAndSessionIsNull(Long hallId);
    
    @Query("SELECT s FROM Seat s WHERE s.hall.id = :hallId AND s.rowNum >= 1 AND s.rowNum <= :maxRows AND s.colNum >= 1 AND s.colNum <= :maxCols")
    List<Seat> findByHallIdWithLimits(@Param("hallId") Long hallId, @Param("maxRows") Integer maxRows, @Param("maxCols") Integer maxCols);
    
    void deleteByHallId(Long hallId);
}
