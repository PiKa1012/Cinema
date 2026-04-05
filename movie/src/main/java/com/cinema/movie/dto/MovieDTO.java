package com.cinema.movie.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class MovieDTO {
    private Long id;
    private String title;
    private String poster;
    private String description;
    private Integer duration;
    private String director;
    private String actors;
    private String genre;
    private BigDecimal rating;
    private String releaseDate;
    private String status;
}
