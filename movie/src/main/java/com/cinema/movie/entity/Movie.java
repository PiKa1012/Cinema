package com.cinema.movie.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Entity
@Table(name = "t_movie")
public class Movie {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String title;
    
    private String poster;
    
    @Column(length = 2000)
    private String description;
    
    private Integer duration;
    
    private String director;
    
    private String actors;
    
    private String genre;
    
    private BigDecimal rating;
    
    private LocalDate releaseDate;
    
    private String status;
    
    private LocalDateTime createTime;
}
