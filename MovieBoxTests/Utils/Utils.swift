//
//  Utils.swift
//
//  Created by Nicolae Rogojan on 24.10.2021.
//

import Foundation
import Combine

@testable import MovieBox

class MovieListServiceMock: MovieListServiceType {
    
    func fetchPoster(poster: String?, size: PosterSize) -> PosterPublisher {
        .just(nil)
    }
    
    func playingMovies() -> AnyPublisher<Result<Movies, Error>, Never> {
        return .just(.failure(URLError(.badServerResponse)))
    }
    
    func popularMovies(page: Int) -> AnyPublisher<Result<Movies, Error>, Never> {
        if page == 1 {
            let movies = Movies.loadFromFile("Movies.json")
            return .just(.success(movies))
        }
        return .just(.failure(URLError(.badServerResponse)))
    }
}

class MovieDetailsServiceMock: MovieDetailsServiceType {
    
    func fetchPoster(poster: String?, size: PosterSize) -> PosterPublisher {
        .just(nil)
    }
    
    func fetchDetail(with movieid: Int) -> AnyPublisher<Movie, Error> {
        let movie = Movie.loadFromFile("Movie.json")
        if movieid == 558216 { return .just(movie) }
        return .fail(URLError(.badServerResponse))
    }
}

extension Decodable {
    static func loadFromFile(_ filename: String) -> Self {
        do {
            let path = Bundle(for: MovieBoxTests.self).path(forResource: filename, ofType: nil)!
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            fatalError("Error: \(error)")
        }
    }
}
