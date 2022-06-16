//
//  MovieListViewModel.swift
//
//  Created by Nicolae Rogojan on 23.10.2021.
//

import UIKit
import Combine

protocol MovieListService {
    func playingMovies() -> AnyPublisher<Result<Movies, Error>, Never>
    func popularMovies(page: Int) -> AnyPublisher<Result<Movies, Error>, Never>
}

protocol MovieListPosteService {
    func fetchPoster(poster: String?, size: PosterSize) -> PosterPublisher
}

typealias MovieListServiceType = MovieListService & MovieListPosteService

class MovieListViewModel: NSObject {
    
    enum State {
        case loading
        case failure(Error)
        case popularMovies([MovieListModel])
        case nowPlayingMovies([MovieListModel])
    }
    
    private let service: MovieListServiceType
    private var totalPages = 1
    
    
    init(service: MovieListServiceType) {
        self.service = service
    }
    
    func modelPublisher(playing: PassthroughSubject<Void, Never>,
                        popular: PassthroughSubject<Int, Never>) -> AnyPublisher<State, Never> {
        
        let loading: AnyPublisher<State, Never> = .just(.loading)
        let playingPublisher = playingPublisher(playing)
        let popularPublisher = popularPublisher(popular)
        let servicePublishers = Publishers.Merge(playingPublisher, popularPublisher).eraseToAnyPublisher()
        
        return Publishers.Merge(loading.eraseToAnyPublisher(), servicePublishers).eraseToAnyPublisher()
    }
    
    private func playingPublisher(_ playing: PassthroughSubject<Void, Never>) -> AnyPublisher<State, Never> {
        let publisher = playing
            .flatMap { [unowned self] _ in self.service.playingMovies()}
            .map({ result -> State in
                switch result {
                case .success(let movies): return .nowPlayingMovies(self.viewModels(from: movies.items))
                case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    private func popularPublisher(_ popular: PassthroughSubject<Int, Never>) -> AnyPublisher<State, Never> {
        let publisher = popular
            .filter({ [unowned self] in $0 <= self.totalPages })
            .flatMap({ [unowned self] page in self.service.popularMovies(page: page) })
            .map({ [unowned self] result -> State in
                switch result {
                case .success(let movies):
                    self.totalPages = movies.totalPages
                    return .popularMovies(self.viewModels(from: movies.items))
                case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    private func viewModels(from movies: [Movie]) -> [MovieListModel] {
        return movies.map(model(_:))
    }
    
    private func model(_ movie: Movie) -> MovieListModel {
        return MovieListModel(movie: movie, poster: poster(movie))
    }
    
    private func poster(_ movie: Movie) -> AnyPublisher<UIImage?, Error> {
        return service.fetchPoster(poster: movie.poster, size: .medium)
    }
}
