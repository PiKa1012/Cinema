package com.cinema.movie.dto;

import lombok.Data;

@Data
public class OrderCreateDTO {
    private Long userId;
    private Long sessionId;
    private java.util.List<Long> seatIds;
}
