package com.cinema.movie.controller;

import com.cinema.movie.dto.LoginRequest;
import com.cinema.movie.dto.LoginResponse;
import com.cinema.movie.entity.User;
import com.cinema.movie.repository.UserRepository;
import com.cinema.movie.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    
    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;
    private final PasswordEncoder passwordEncoder;
    
    @PostMapping("/register")
    public ResponseEntity<LoginResponse> register(@RequestBody LoginRequest request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            return ResponseEntity.badRequest().build();
        }
        
        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setNickname(request.getUsername());
        user.setRole("USER");
        user.setCreateTime(LocalDateTime.now());
        
        user = userRepository.save(user);
        
        String token = jwtUtil.generateToken(user.getUsername(), user.getId(), user.getRole());
        return ResponseEntity.ok(new LoginResponse(
            token, user.getId(), user.getUsername(), user.getNickname(), user.getRole()
        ));
    }
    
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        User user = userRepository.findByUsername(request.getUsername()).orElse(null);
        
        if (user == null || !passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            return ResponseEntity.status(401).build();
        }
        
        if ("BANNED".equals(user.getRole())) {
            return ResponseEntity.status(403).build();
        }
        
        String token = jwtUtil.generateToken(user.getUsername(), user.getId(), user.getRole());
        return ResponseEntity.ok(new LoginResponse(
            token, user.getId(), user.getUsername(), user.getNickname(), user.getRole()
        ));
    }
    
    @GetMapping("/user")
    public ResponseEntity<User> getCurrentUser(@RequestHeader("Authorization") String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return ResponseEntity.status(401).build();
        }
        
        String token = authHeader.substring(7);
        if (!jwtUtil.validateToken(token)) {
            return ResponseEntity.status(401).build();
        }
        
        String username = jwtUtil.getUsername(token);
        return userRepository.findByUsername(username)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @PutMapping("/user")
    public ResponseEntity<User> updateProfile(@RequestHeader("Authorization") String authHeader, @RequestBody User updateRequest) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return ResponseEntity.status(401).build();
        }
        
        String token = authHeader.substring(7);
        if (!jwtUtil.validateToken(token)) {
            return ResponseEntity.status(401).build();
        }
        
        String username = jwtUtil.getUsername(token);
        return userRepository.findByUsername(username)
                .map(user -> {
                    if (updateRequest.getNickname() != null) {
                        user.setNickname(updateRequest.getNickname());
                    }
                    if (updateRequest.getPassword() != null && !updateRequest.getPassword().isEmpty()) {
                        user.setPassword(passwordEncoder.encode(updateRequest.getPassword()));
                    }
                    return ResponseEntity.ok(userRepository.save(user));
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
