package com.cinema.movie.controller;

import com.cinema.movie.entity.Seat;
import com.cinema.movie.service.SeatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/seats")
@RequiredArgsConstructor
public class SeatController {
    private final SeatService seatService;
    
    @GetMapping("/hall/{hallId}")
    public ResponseEntity<List<Seat>> getSeatsByHall(@PathVariable Long hallId) {
        return ResponseEntity.ok(seatService.getSeatsByHall(hallId));
    }
    
    @GetMapping("/hall/{hallId}/session/{sessionId}")
    public ResponseEntity<List<Seat>> getAvailableSeats(
            @PathVariable Long hallId, 
            @PathVariable Long sessionId) {
        System.out.println(">>> SeatController.getAvailableSeats hallId=" + hallId + " sessionId=" + sessionId);
        List<Seat> seats = seatService.getAvailableSeats(sessionId, hallId);
        System.out.println(">>> Returning " + seats.size() + " seats");
        return ResponseEntity.ok(seats);
    }
    
    @PostMapping
    public ResponseEntity<Seat> createSeat(@RequestBody Seat seat) {
        return ResponseEntity.ok(seatService.saveSeat(seat));
    }
}
