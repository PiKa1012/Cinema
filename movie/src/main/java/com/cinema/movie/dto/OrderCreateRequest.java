package com.cinema.movie.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

@Data
public class OrderCreateRequest {
    private Long userId;
    private Long sessionId;
    private List<Long> seatIds;
    private BigDecimal totalPrice;
}
