package com.cinema.movie.service;

import com.cinema.movie.entity.Hall;
import com.cinema.movie.repository.HallRepository;
import com.cinema.movie.repository.SessionRepository;
import com.cinema.movie.repository.SeatRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
public class HallService {
    private final HallRepository hallRepository;
    private final SessionRepository sessionRepository;
    private final SeatRepository seatRepository;
    
    public List<Hall> getAllHalls() {
        return hallRepository.findAll();
    }
    
    public Hall getHallById(Long id) {
        return hallRepository.findById(id).orElse(null);
    }
    
    public Hall saveHall(Hall hall) {
        return hallRepository.save(hall);
    }
    
    @Transactional
    public void deleteHall(Long id) {
        sessionRepository.deleteByHallId(id);
        seatRepository.deleteByHallId(id);
        hallRepository.deleteById(id);
    }
}
