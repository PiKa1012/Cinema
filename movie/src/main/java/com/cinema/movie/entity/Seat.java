package com.cinema.movie.entity;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "t_seat")
public class Seat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "hall_id", nullable = false)
    private Hall hall;
    
    @ManyToOne
    @JoinColumn(name = "session_id")
    private Session session;
    
    @Column(nullable = false)
    private Integer rowNum;
    
    @Column(nullable = false)
    private Integer colNum;
    
    @Column(nullable = false)
    private String seatNo;
    
    private String type;
    
    private Boolean available;
}
