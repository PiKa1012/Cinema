package com.cinema.movie.controller;

import com.cinema.movie.entity.*;
import com.cinema.movie.repository.*;
import com.cinema.movie.service.HallService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import org.springframework.web.multipart.MultipartFile;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminController {
    
    private final UserRepository userRepository;
    private final MovieRepository movieRepository;
    private final OrderRepository orderRepository;
    private final HallRepository hallRepository;
    private final SessionRepository sessionRepository;
    private final SeatRepository seatRepository;
    private final HallService hallService;
    private final PasswordEncoder passwordEncoder;
    
    @GetMapping("/users")
    public ResponseEntity<List<User>> getAllUsers() {
        return ResponseEntity.ok(userRepository.findAll());
    }
    
    @PostMapping("/users")
    public ResponseEntity<User> createUser(@RequestBody User user) {
        user.setCreateTime(LocalDateTime.now());
        return ResponseEntity.ok(userRepository.save(user));
    }
    
    @DeleteMapping("/users/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userRepository.deleteById(id);
        return ResponseEntity.ok().build();
    }
    
    @PutMapping("/users/{id}/password")
    public ResponseEntity<User> resetPassword(@PathVariable Long id, @RequestBody Map<String, String> body) {
        return userRepository.findById(id).map(user -> {
            user.setPassword(passwordEncoder.encode(body.get("password")));
            return ResponseEntity.ok(userRepository.save(user));
        }).orElse(ResponseEntity.notFound().build());
    }
    
    @PutMapping("/users/{id}/ban")
    public ResponseEntity<User> banUser(@PathVariable Long id) {
        return userRepository.findById(id).map(user -> {
            user.setRole("BANNED");
            return ResponseEntity.ok(userRepository.save(user));
        }).orElse(ResponseEntity.notFound().build());
    }
    
    @PutMapping("/users/{id}/unban")
    public ResponseEntity<User> unbanUser(@PathVariable Long id) {
        return userRepository.findById(id).map(user -> {
            user.setRole("USER");
            return ResponseEntity.ok(userRepository.save(user));
        }).orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/orders")
    public ResponseEntity<List<Order>> getAllOrders() {
        return ResponseEntity.ok(orderRepository.findAll());
    }
    
    @PutMapping("/orders/{id}/status")
    public ResponseEntity<Order> updateOrderStatus(@PathVariable Long id, @RequestParam String status) {
        return orderRepository.findById(id).map(order -> {
            order.setStatus(status);
            return ResponseEntity.ok(orderRepository.save(order));
        }).orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/orders/{id}")
    public ResponseEntity<Order> getOrderDetail(@PathVariable Long id) {
        return orderRepository.findByIdWithDetails(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/movies")
    public ResponseEntity<List<Movie>> getAllMovies() {
        return ResponseEntity.ok(movieRepository.findAll());
    }
    
    @PostMapping("/movies")
    public ResponseEntity<Movie> createMovie(@RequestBody Movie movie) {
        movie.setCreateTime(LocalDateTime.now());
        return ResponseEntity.ok(movieRepository.save(movie));
    }
    
    @PutMapping("/movies/{id}")
    public ResponseEntity<Movie> updateMovie(@PathVariable Long id, @RequestBody Movie movie) {
        Movie existingMovie = movieRepository.findById(id).orElse(null);
        if (existingMovie != null && movie.getPoster() != null) {
            String oldPoster = existingMovie.getPoster();
            String newPoster = movie.getPoster();
            if (oldPoster != null && !oldPoster.equals(newPoster)) {
                try {
                    String oldFilename = oldPoster.substring(oldPoster.lastIndexOf("/") + 1);
                    Path oldFilePath = Paths.get("uploads/" + oldFilename);
                    if (Files.exists(oldFilePath)) {
                        Files.delete(oldFilePath);
                        System.out.println("=== Deleted old poster: " + oldFilename + " ===");
                    }
                } catch (Exception e) {
                    System.out.println("=== Failed to delete old poster: " + e.getMessage() + " ===");
                }
            }
        }
        movie.setId(id);
        return ResponseEntity.ok(movieRepository.save(movie));
    }
    
    @PostMapping("/upload")
    public ResponseEntity<Map<String, String>> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            System.out.println("=== Upload request received ===");
            System.out.println("File name: " + (file != null ? file.getOriginalFilename() : "null"));
            System.out.println("File size: " + (file != null ? file.getSize() : 0));
            System.out.println("Content type: " + (file != null ? file.getContentType() : "null"));
            
            String uploadDir = "uploads/";
            Path uploadPath = Paths.get(uploadDir);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String newFilename = UUID.randomUUID().toString() + extension;
            
            Path filePath = uploadPath.resolve(newFilename);
            Files.copy(file.getInputStream(), filePath);
            
            String fileUrl = "/uploads/" + newFilename;
            Map<String, String> result = new HashMap<>();
            result.put("url", fileUrl);
            System.out.println("=== Upload success: " + fileUrl + " ===");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            System.out.println("=== Upload FAILED ===");
            System.out.println("Error: " + e.getMessage());
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.status(500).body(error);
        }
    }
    
    @GetMapping("/uploads/{filename}")
    public ResponseEntity<byte[]> getFile(@PathVariable String filename) {
        try {
            Path filePath = Paths.get("uploads/" + filename);
            if (Files.exists(filePath)) {
                byte[] bytes = Files.readAllBytes(filePath);
                String ext = filename.substring(filename.lastIndexOf(".") + 1).toLowerCase();
                String contentType = switch(ext) {
                    case "jpg", "jpeg" -> "image/jpeg";
                    case "png" -> "image/png";
                    case "gif" -> "image/gif";
                    default -> "application/octet-stream";
                };
                return ResponseEntity.ok()
                    .header("Content-Type", contentType)
                    .body(bytes);
            }
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @DeleteMapping("/movies/{id}")
    public ResponseEntity<Void> deleteMovie(@PathVariable Long id) {
        movieRepository.findById(id).ifPresent(movie -> {
            if (movie.getPoster() != null && !movie.getPoster().isEmpty()) {
                String posterUrl = movie.getPoster();
                if (posterUrl.contains("/uploads/")) {
                    String filename = posterUrl.substring(posterUrl.lastIndexOf("/uploads/") + 9);
                    try {
                        Path filePath = Paths.get("uploads/" + filename);
                        Files.deleteIfExists(filePath);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
            movieRepository.deleteById(id);
        });
        return ResponseEntity.ok().build();
    }
    
    @GetMapping("/halls")
    public ResponseEntity<List<Hall>> getAllHalls() {
        return ResponseEntity.ok(hallRepository.findAll());
    }
    
    @PostMapping("/halls")
    public ResponseEntity<Hall> createHall(@RequestBody Hall hall) {
        hall.setCreateTime(LocalDateTime.now());
        hall = hallRepository.save(hall);
        
        String defaultSeatType = hall.getType() != null ? hall.getType() : "普通";
        
        if (hall.getRows() != null && hall.getColumns() != null) {
            for (int row = 1; row <= hall.getRows(); row++) {
                for (int col = 1; col <= hall.getColumns(); col++) {
                    Seat seat = new Seat();
                    seat.setHall(hall);
                    seat.setRowNum(row);
                    seat.setColNum(col);
                    seat.setSeatNo((char)('A' + row - 1) + String.valueOf(col));
                    seat.setType(defaultSeatType);
                    seat.setAvailable(true);
                    seatRepository.save(seat);
                }
            }
        }
        
        return ResponseEntity.ok(hall);
    }
    
    @DeleteMapping("/halls/{id}")
    public ResponseEntity<Void> deleteHall(@PathVariable Long id) {
        hallService.deleteHall(id);
        return ResponseEntity.ok().build();
    }
    
    @GetMapping("/sessions")
    public ResponseEntity<List<Map<String, Object>>> getAllSessions() {
        List<Session> sessions = sessionRepository.findAll();
        List<Map<String, Object>> result = new java.util.ArrayList<>();
        for (Session s : sessions) {
            Map<String, Object> map = new java.util.HashMap<>();
            map.put("id", s.getId());
            map.put("movie", s.getMovie());
            map.put("hall", s.getHall());
            map.put("startTime", s.getStartTime());
            map.put("endTime", s.getEndTime());
            map.put("price", s.getPrice());
            map.put("status", s.getStatus());
            map.put("createTime", s.getCreateTime());
            
            long soldCount = orderRepository.findBySessionId(s.getId()).stream()
                .filter(o -> "confirmed".equals(o.getStatus()))
                .mapToLong(o -> o.getSeats() != null ? o.getSeats().size() : 0)
                .sum();
            map.put("sold", soldCount);
            result.add(map);
        }
        return ResponseEntity.ok(result);
    }
    
    @PostMapping("/sessions")
    public ResponseEntity<Session> createSession(@RequestBody Session session) {
        Movie movie = movieRepository.findById(session.getMovie().getId()).orElse(null);
        Hall hall = hallRepository.findById(session.getHall().getId()).orElse(null);
        if (movie == null || hall == null) {
            return ResponseEntity.badRequest().build();
        }
        session.setMovie(movie);
        session.setHall(hall);
        session.setCreateTime(LocalDateTime.now());
        session = sessionRepository.save(session);
        
        List<Seat> hallSeats = seatRepository.findByHallIdAndSessionIsNull(hall.getId());
        for (Seat hallSeat : hallSeats) {
            Seat newSeat = new Seat();
            newSeat.setHall(hall);
            newSeat.setSession(session);
            newSeat.setRowNum(hallSeat.getRowNum());
            newSeat.setColNum(hallSeat.getColNum());
            newSeat.setSeatNo(hallSeat.getSeatNo());
            newSeat.setType(hallSeat.getType());
            newSeat.setAvailable(true);
            seatRepository.save(newSeat);
        }
        
        return ResponseEntity.ok(session);
    }
    
    @PutMapping("/sessions/{id}")
    public ResponseEntity<Session> updateSession(@PathVariable Long id, @RequestBody Session session) {
        return sessionRepository.findById(id).map(s -> {
            Movie movie = movieRepository.findById(session.getMovie().getId()).orElse(null);
            Hall hall = hallRepository.findById(session.getHall().getId()).orElse(null);
            if (movie != null) s.setMovie(movie);
            if (hall != null) s.setHall(hall);
            s.setPrice(session.getPrice());
            s.setStartTime(session.getStartTime());
            s.setEndTime(session.getEndTime());
            s.setStatus(session.getStatus());
            return ResponseEntity.ok(sessionRepository.save(s));
        }).orElse(ResponseEntity.notFound().build());
    }
    
    @DeleteMapping("/sessions/{id}")
    public ResponseEntity<Void> deleteSession(@PathVariable Long id) {
        List<Seat> sessionSeats = seatRepository.findBySessionId(id);
        seatRepository.deleteAll(sessionSeats);
        sessionRepository.deleteById(id);
        return ResponseEntity.ok().build();
    }
    
    @GetMapping("/seats/hall/{hallId}")
    public ResponseEntity<List<Seat>> getSeatsByHall(@PathVariable Long hallId) {
        return ResponseEntity.ok(seatRepository.findByHallIdAndSessionIsNull(hallId));
    }
    
    @PutMapping("/seats/{id}")
    public ResponseEntity<Seat> updateSeat(@PathVariable Long id, @RequestBody Seat seat) {
        return seatRepository.findById(id).map(s -> {
            if (s.getSession() != null) {
                return ResponseEntity.status(403).body(s);
            }
            s.setType(seat.getType());
            return ResponseEntity.ok(seatRepository.save(s));
        }).orElse(ResponseEntity.notFound().build());
    }
    
    @DeleteMapping("/seats/{id}")
    public ResponseEntity<Void> deleteSeat(@PathVariable Long id) {
        seatRepository.deleteById(id);
        return ResponseEntity.ok().build();
    }
}
