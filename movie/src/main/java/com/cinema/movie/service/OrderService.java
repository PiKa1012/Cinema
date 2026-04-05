package com.cinema.movie.service;

import com.cinema.movie.entity.Order;
import com.cinema.movie.entity.Seat;
import com.cinema.movie.entity.User;
import com.cinema.movie.entity.Session;
import com.cinema.movie.dto.OrderCreateRequest;
import com.cinema.movie.repository.OrderRepository;
import com.cinema.movie.repository.UserRepository;
import com.cinema.movie.repository.SessionRepository;
import com.cinema.movie.repository.SeatRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.UUID;
import java.util.ArrayList;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class OrderService {
    private final OrderRepository orderRepository;
    private final UserRepository userRepository;
    private final SessionRepository sessionRepository;
    private final SeatRepository seatRepository;
    
    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }
    
    public Order getOrderById(Long id) {
        return orderRepository.findById(id).orElse(null);
    }
    
    public Order getOrderByNo(String orderNo) {
        return orderRepository.findByOrderNo(orderNo).orElse(null);
    }
    
    public List<Order> getUserOrders(Long userId) {
        return orderRepository.findByUserId(userId);
    }
    
    @Transactional
    public Order createOrderFromRequest(OrderCreateRequest request) {
        User user = userRepository.findById(request.getUserId()).orElse(null);
        Session session = sessionRepository.findById(request.getSessionId()).orElse(null);
        
        List<Seat> seats = new ArrayList<>();
        if (request.getSeatIds() != null) {
            for (Long seatId : request.getSeatIds()) {
                seatRepository.findById(seatId).ifPresent(seats::add);
            }
        }
        
        Order order = new Order();
        order.setUser(user);
        order.setSession(session);
        order.setSeats(seats);
        order.setTotalPrice(request.getTotalPrice());
        order.setOrderNo(UUID.randomUUID().toString().replace("-", ""));
        order.setStatus("pending");
        order.setCreateTime(LocalDateTime.now());
        return orderRepository.save(order);
    }
    
    @Transactional
    public Order createOrder(Order order) {
        Long userId = order.getUser() != null ? order.getUser().getId() : null;
        Long sessionId = order.getSession() != null ? order.getSession().getId() : null;
        List<Long> seatIds = order.getSeats() != null ? order.getSeats().stream().map(s -> s.getId()).toList() : new ArrayList<>();
        
        User user = userId != null ? userRepository.findById(userId).orElse(null) : null;
        Session session = sessionId != null ? sessionRepository.findById(sessionId).orElse(null) : null;
        
        List<Seat> seats = new ArrayList<>();
        if (seatIds != null) {
            for (Long seatId : seatIds) {
                seatRepository.findById(seatId).ifPresent(seats::add);
            }
        }
        
        order.setUser(user);
        order.setSession(session);
        order.setSeats(seats);
        order.setOrderNo(UUID.randomUUID().toString().replace("-", ""));
        order.setStatus("pending");
        return orderRepository.save(order);
    }
    
    @Transactional
    public Order confirmOrder(Long orderId) {
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order != null) {
            order.setStatus("confirmed");
            return orderRepository.save(order);
        }
        return null;
    }
    
    @Transactional
    public Order cancelOrder(Long orderId) {
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order != null) {
            order.setStatus("cancelled");
            return orderRepository.save(order);
        }
        return null;
    }
}
