//
//  MovieService.swift
//
//  Created by Nicolae Rogojan on 21.10.2021.
//

import Foundation
import Combine

class MovieService: BaseClient {

    let clientPath: ClientPath

    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    private var errorMessage = ""
    private let defaultParameters: [String : CustomStringConvertible] = [
        "api_key": ApiConstants.apiKey,
        "language": Locale.preferredLanguages[0]
    ]

    private enum Path {
        case nowPlaying
        case popular
        case details(Int)

        var value: String {
            switch self {
            case .nowPlaying:
                return "/now_playing"
            case .popular:
                return "/popular"
            case .details(let id):
                return "/\(id)"
            }
        }
    }

    init() {
        self.clientPath = ClientPath(baseURI: "https://api.themoviedb.org",
                                     baseURIVersion: "3",
                                     serviceName: "movie")

    }

    required init(clientPath: ClientPath) {
        self.clientPath = clientPath
    }

    func popularMovies(page: Int) -> AnyPublisher<Result<Movies, Error>, Never> {

        let forPath = Path.popular.value
        var parameters = defaultParameters
        parameters["page"] = page

        guard let request = request(forPath: forPath, params: parameters) else {
            return .just(.failure(URLError(.badURL)))
        }

        return publisher(request: request)
    }

    func playingMovies() -> AnyPublisher<Result<Movies, Error>, Never> {

        let forPath = Path.nowPlaying.value
        var parameters = defaultParameters
        parameters["page"] = "undefined"

        guard let request = request(forPath: forPath, params: parameters) else {
            return .just(.failure(URLError(.badURL)))
        }

        return publisher(request: request)
    }

    func fetchDetail(with movieid: Int) -> AnyPublisher<Movie, Error> {

        let forPath = Path.details(movieid).value
        let parameters = defaultParameters

        guard let request = request(forPath: forPath, params: parameters) else {
            return .fail(URLError(.badURL))
        }

        let publisher = publisher(request: request) as AnyPublisher<Result<Movie, Error>, Never>

        return publisher
            .flatMap({ result -> AnyPublisher<Movie, Error> in
                switch result {
                case.success(let value): return .just(value)
                case .failure(let error): return .fail(error)
                }
            })
            .eraseToAnyPublisher()
    }
}
