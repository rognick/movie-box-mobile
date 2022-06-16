//
//  MovieDetailCoordinator.swift
//
//  Created by Nicolae Rogojan on 21.10.2021.
//

import UIKit

protocol MovieDetailCoordinatorDelegate: AnyObject {
    func didTapClose()
}

class MovieDetailCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private var movieDetailViewController: MovieDetailViewController?
    private let movieId: Int
    private var dataProvider: DataProvider
    
    init(presenter: UINavigationController, movieId: Int, dataProvider: DataProvider) {
        self.presenter = presenter
        self.movieId = movieId
        self.dataProvider = dataProvider
    }

    func start() {
        let viewModel = MovieDetailsViewModel(movieId: movieId, service: dataProvider.movieDetails)
        let viewController = MovieDetailViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.coordinator = self
        
        self.movieDetailViewController = viewController
        
        presenter.present(viewController, animated: true, completion: nil)
    }
}

extension MovieDetailCoordinator: MovieDetailCoordinatorDelegate {
    func didTapClose() {
        movieDetailViewController?.dismiss(animated: true, completion: nil)
    }
}
