package com.cinema.movie.dto;

import lombok.Data;

@Data
public class SeatDTO {
    private Long id;
    private Long hallId;
    private Integer rowNum;
    private Integer colNum;
    private String seatNo;
    private String type;
    private Boolean available;
}
