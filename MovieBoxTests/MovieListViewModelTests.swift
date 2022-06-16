//
//  MovieListViewModelTests.swift
//
//  Created by Nicolae Rogojan on 24.10.2021.
//

import XCTest
import Combine

@testable import MovieBox

class MovieListViewModelTests: XCTestCase {
    
    var viewModel: MovieListViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        viewModel = MovieListViewModel(service: MovieListServiceMock())
    }
    
    func test_loadData() {
        let playing = PassthroughSubject<Void, Never>()
        let popular = PassthroughSubject<Int, Never>()
        var state: MovieListViewModel.State?
        let expectation = self.expectation(description: "movies")
        
        viewModel.modelPublisher(playing: playing, popular: popular).sink { value in
            guard case .popularMovies(_) = value else { return }
            state = value
            expectation.fulfill()
        }.store(in: &cancellables)
        
        popular.send(1)

        waitForExpectations(timeout: 1)
        
        guard case .popularMovies(let movies) = state else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(movies.count, 20)
    }
    
    func test_hasErrorState() {
        let playing = PassthroughSubject<Void, Never>()
        let popular = PassthroughSubject<Int, Never>()
        var state: MovieListViewModel.State?
        let expectation = self.expectation(description: "movies")
        
        viewModel.modelPublisher(playing: playing, popular: popular).sink { value in
            guard case .failure = value else { return }
            state = value
            expectation.fulfill()
        }.store(in: &cancellables)
        
        playing.send()

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(state)
    }
    
    func test_loading() {
        let model = MovieListViewModel(service: MovieListServiceMock())
        let playing = PassthroughSubject<Void, Never>()
        let popular = PassthroughSubject<Int, Never>()
        
        model.modelPublisher(playing: playing, popular: popular).sink { status in
            guard case .loading = status
            else {
                XCTFail("Expected introduction, but was \(status)")
                return
            }
        }.store(in: &cancellables)
    }
}
