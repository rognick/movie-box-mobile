//
//  ModelsTests.swift
//
//  Created by Nicolae Rogojan on 24.10.2021.
//

import XCTest
import Combine

@testable import MovieBox

class ModelsTests: XCTestCase {
    let movie = Movie(id: 1, title: "Mock", overview: "", poster: "/local.jpg", voteAverage: 1, releaseDate: "2021-09-30", runtime: 90, genres: nil)
    
    private var cancellables: Set<AnyCancellable> = []
    
    func test_movie_model_hashable() {
        let movies = Set([movie, movie, movie, movie])
        XCTAssertEqual(movies.count, 1)
    }
    
    func test_detail_model() {
        let model = MovieDetailModel(movie: movie, poster: .just(nil))
        XCTAssertEqual(model.title, movie.title)
        
        let subtitle = "September 30, 2021 - 1h 30m"
        XCTAssertEqual(model.subtitle, subtitle)
        test_model_poster(model.poster)
    }
    
    func test_list_model() {
        let model = MovieListModel(movie: movie, poster: .just(nil))
        XCTAssertEqual(model.title, movie.title)
        
        let subtitle = "September 30, 2021\n1h 30m"
        XCTAssertEqual(model.subtitle, subtitle)
        
        test_model_poster(model.posterPublisher)
    }
    
    func test_list_model_subtitle() {
        let movie = Movie(id: 1, title: "Mock", overview: "", poster: "/local.jpg", voteAverage: 1, releaseDate: "2021-09-30", runtime: nil, genres: nil)
        let model = MovieListModel(movie: movie, poster: .just(nil))
        
        let subtitle = "September 30, 2021\n-"
        XCTAssertEqual(model.subtitle, subtitle)
    }
    
    func test_model_poster(_ posterPublisher: AnyPublisher<UIImage?, Error>) {
        var image: UIImage?
        var error: Subscribers.Completion<Error>?
        let expectation = self.expectation(description: "Poster Publisher")
        
        posterPublisher
            .sink { value in
                error = value
            } receiveValue: { value in
                image = value
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        XCTAssertNil(image)
    }
}
