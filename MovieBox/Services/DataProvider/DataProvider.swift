//
//  DataProvider.swift
//
//  Created by Nicolae Rogojan on 24.10.2021.
//

import Foundation
import Combine

final class DataProvider {
    private var movieService: MovieService
    private var posterService: PosterService
    
    lazy var movieDetails: MovieDetailsServiceType = MovieDetails(movieService: movieService, posterService: posterService)
    lazy var movieList: MovieListServiceType = MovieList(movieService: movieService, posterService: posterService)
    
    init(movieService: MovieService = MovieService(), posterService: PosterService = PosterService()) {
        self.movieService = movieService
        self.posterService = posterService
    }
}

private struct MovieDetails: MovieDetailsServiceType {
    var movieService: MovieService
    var posterService: PosterService
    
    func fetchDetail(with movieid: Int) -> AnyPublisher<Movie, Error> {
        movieService.fetchDetail(with: movieid)
    }
    
    func fetchPoster(poster: String?, size: PosterSize) -> PosterPublisher {
        posterService.fetchPoster(poster: poster, size: size)
    }
}

private struct MovieList: MovieListServiceType {
    var movieService: MovieService
    var posterService: PosterService
    
    func playingMovies() -> AnyPublisher<Result<Movies, Error>, Never> {
        movieService.playingMovies()
    }
    
    func popularMovies(page: Int) -> AnyPublisher<Result<Movies, Error>, Never> {
        movieService.popularMovies(page: page)
    }
    
    func fetchPoster(poster: String?, size: PosterSize) -> PosterPublisher {
        posterService.fetchPoster(poster: poster, size: size)
    }
}
