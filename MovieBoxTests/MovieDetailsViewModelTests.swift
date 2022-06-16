//
//  MovieDetailsViewModelTests.swift
//
//  Created by Nicolae Rogojan on 24.10.2021.
//

import XCTest
import Combine

@testable import MovieBox

class MovieDetailsViewModelTests: XCTestCase {
    
    var viewModel: MovieDetailsViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        viewModel = MovieDetailsViewModel(movieId: 558216, service: MovieDetailsServiceMock())
    }
    
    func test_model() {
        let input = PassthroughSubject<Void, Never>()
        var model: MovieDetailModel?
        var error: Subscribers.Completion<Error>?
        let expectation = self.expectation(description: "Movie")
        
        viewModel.modelPublisher(input: input.eraseToAnyPublisher())
            .sink { eror in
                error = eror
                expectation.fulfill()
            } receiveValue: { item in
                model = item
                expectation.fulfill()
            }.store(in: &cancellables)
        
        input.send()
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error)
        XCTAssertNotNil(model)
        XCTAssertEqual(model?.title, "Venom")
    }
    
}
