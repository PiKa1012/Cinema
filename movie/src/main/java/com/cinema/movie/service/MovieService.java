package com.cinema.movie.service;

import com.cinema.movie.entity.Movie;
import com.cinema.movie.repository.MovieRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MovieService {
    private final MovieRepository movieRepository;
    
    public List<Movie> getAllMovies() {
        List<Movie> list = movieRepository.findAll();
        return list == null ? new ArrayList<>() : list;
    }
    
    public Movie getMovieById(Long id) {
        return movieRepository.findById(id).orElse(null);
    }
    
    public List<Movie> getShowingMovies() {
        return movieRepository.findByStatus("showing");
    }
    
    public Movie saveMovie(Movie movie) {
        return movieRepository.save(movie);
    }
    
    public void deleteMovie(Long id) {
        movieRepository.deleteById(id);
    }
    
    public List<Movie> searchMovies(String keyword) {
        return movieRepository.findByTitleContaining(keyword);
    }
}
