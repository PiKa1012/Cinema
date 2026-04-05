package com.cinema.movie.service;

import com.cinema.movie.entity.Hall;
import com.cinema.movie.entity.Seat;
import com.cinema.movie.entity.Session;
import com.cinema.movie.entity.Order;
import com.cinema.movie.repository.SeatRepository;
import com.cinema.movie.repository.OrderRepository;
import com.cinema.movie.repository.HallRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.ArrayList;

@Service
@RequiredArgsConstructor
public class SeatService {
    private final SeatRepository seatRepository;
    private final OrderRepository orderRepository;
    private final HallRepository hallRepository;
    
    public List<Seat> getSeatsByHall(Long hallId) {
        return seatRepository.findByHallId(hallId);
    }
    
    public List<Seat> getAvailableSeats(Long sessionId, Long hallId) {
        List<Seat> seats = seatRepository.findBySessionId(sessionId);
        
        if (seats.isEmpty()) {
            Hall hall = hallRepository.findById(hallId).orElse(null);
            if (hall == null) {
                return seatRepository.findByHallId(hallId);
            }
            int maxRows = hall.getRows() != null ? hall.getRows() : 8;
            int maxCols = hall.getColumns() != null ? hall.getColumns() : 10;
            seats = seatRepository.findByHallIdWithLimits(hallId, maxRows, maxCols);
        }
        
        List<Order> orders = orderRepository.findBySessionId(sessionId);
        List<Long> bookedSeatIds = new ArrayList<>();
        for (Order order : orders) {
            if ("confirmed".equals(order.getStatus())) {
                for (Seat seat : order.getSeats()) {
                    bookedSeatIds.add(seat.getId());
                }
            }
        }
        
        for (Seat seat : seats) {
            seat.setAvailable(!bookedSeatIds.contains(seat.getId()));
        }
        
        return seats;
    }
    
    @Transactional
    public Seat saveSeat(Seat seat) {
        return seatRepository.save(seat);
    }
    
    @Transactional
    public void initHallSeats(Hall hall) {
        for (int row = 1; row <= hall.getRows(); row++) {
            for (int col = 1; col <= hall.getColumns(); col++) {
                Seat seat = new Seat();
                seat.setHall(hall);
                seat.setRowNum(row);
                seat.setColNum(col);
                seat.setSeatNo((char)('A' + row - 1) + String.valueOf(col));
                seat.setAvailable(true);
                seatRepository.save(seat);
            }
        }
    }
}
