//
//  MovieDetailsViewModel.swift
//
//  Created by Nicolae Rogojan on 21.10.2021.
//

import Foundation
import Combine

import UIKit

protocol MovieDetailsService {
    func fetchDetail(with movieid: Int) -> AnyPublisher<Movie, Error>
}

protocol MovieDetailsPoster {
    func fetchPoster(poster: String?, size: PosterSize) -> PosterPublisher
}

typealias MovieDetailsServiceType = MovieDetailsService & MovieDetailsPoster

class MovieDetailsViewModel: NSObject {
    
    private let movieId: Int
    private let service: MovieDetailsServiceType
    
    init(movieId: Int, service: MovieDetailsServiceType) {
        self.movieId = movieId
        self.service = service
    }
    
    func modelPublisher(input: AnyPublisher<Void, Never>) -> AnyPublisher<MovieDetailModel, Error> {
        let movieDetails = input
            .flatMap({[unowned self] _ in self.service.fetchDetail(with: self.movieId) })
            .tryMap(self.model(_:))
            .eraseToAnyPublisher()
        
        return movieDetails
    }
    
    private func model(_ movie: Movie) throws -> MovieDetailModel {
        let poster = service.fetchPoster(poster: movie.poster, size: .medium)
        return MovieDetailModel(movie: movie, poster: poster)
    }
}
