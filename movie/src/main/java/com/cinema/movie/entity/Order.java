package com.cinema.movie.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Entity
@Table(name = "t_order")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String orderNo;
    
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @ManyToOne
    @JoinColumn(name = "session_id", nullable = false)
    private Session session;
    
    @ManyToMany
    @JoinTable(name = "t_order_seat", 
        joinColumns = @JoinColumn(name = "order_id"),
        inverseJoinColumns = @JoinColumn(name = "seat_id"))
    private List<Seat> seats;
    
    @Column(nullable = false)
    private BigDecimal totalPrice;
    
    private String status;
    
    private LocalDateTime createTime;
}
