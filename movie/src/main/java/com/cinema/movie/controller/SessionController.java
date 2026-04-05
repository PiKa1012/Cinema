package com.cinema.movie.controller;

import com.cinema.movie.entity.Session;
import com.cinema.movie.service.SessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/sessions")
@RequiredArgsConstructor
public class SessionController {
    private final SessionService sessionService;
    
    @GetMapping
    public ResponseEntity<List<Session>> getAllSessions() {
        return ResponseEntity.ok(sessionService.getAllSessions());
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Session> getSessionById(@PathVariable Long id) {
        Session session = sessionService.getSessionById(id);
        if (session != null) {
            return ResponseEntity.ok(session);
        }
        return ResponseEntity.notFound().build();
    }
    
    @GetMapping("/movie/{movieId}")
    public ResponseEntity<List<Session>> getSessionsByMovie(@PathVariable Long movieId) {
        return ResponseEntity.ok(sessionService.getSessionsByMovie(movieId));
    }
    
    @GetMapping("/hall/{hallId}")
    public ResponseEntity<List<Session>> getSessionsByHall(@PathVariable Long hallId) {
        return ResponseEntity.ok(sessionService.getSessionsByHall(hallId));
    }
    
    @PostMapping
    public ResponseEntity<Session> createSession(@RequestBody Session session) {
        return ResponseEntity.ok(sessionService.saveSession(session));
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<Session> updateSession(@PathVariable Long id, @RequestBody Session session) {
        session.setId(id);
        return ResponseEntity.ok(sessionService.saveSession(session));
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSession(@PathVariable Long id) {
        sessionService.deleteSession(id);
        return ResponseEntity.ok().build();
    }
}
