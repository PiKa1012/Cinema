package com.cinema.movie.service;

import com.cinema.movie.entity.Session;
import com.cinema.movie.repository.SessionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class SessionService {
    private final SessionRepository sessionRepository;
    
    public List<Session> getAllSessions() {
        return sessionRepository.findAll();
    }
    
    public Session getSessionById(Long id) {
        return sessionRepository.findById(id).orElse(null);
    }
    
    public List<Session> getSessionsByMovie(Long movieId) {
        return sessionRepository.findByMovieId(movieId);
    }
    
    public List<Session> getSessionsByHall(Long hallId) {
        return sessionRepository.findByHallId(hallId);
    }
    
    public List<Session> getSessionsByTimeRange(LocalDateTime start, LocalDateTime end) {
        return sessionRepository.findByStartTimeBetween(start, end);
    }
    
    public Session saveSession(Session session) {
        return sessionRepository.save(session);
    }
    
    public void deleteSession(Long id) {
        sessionRepository.deleteById(id);
    }
}
