package com.cinema.movie.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "t_hall")
public class Hall {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String name;
    
    @Column(name = "row_count")
    private Integer rows;
    
    @Column(name = "col_count")
    private Integer columns;
    
    private String type;
    
    private LocalDateTime createTime;
}
