//
//  MovieListCoordinator.swift
//
//  Created by Nicolae Rogojan on 21.10.2021.
//

import UIKit

// MARK: - MovieListViewControllerDelegate

protocol MovieListViewControllerDelegate: AnyObject {
    func movieListViewController(didSelect movieId: Int)
}

// MARK: - MovieListCoordinator

class MovieListCoordinator: Coordinator {
    
    private var presenter: UINavigationController
    private var movieDetailCoordinator: MovieDetailCoordinator?
    private var movieListViewController: MovieListViewController?
    private var dataProvider: DataProvider
    
    init(presenter: UINavigationController, dataProvider: DataProvider) {
        self.presenter = presenter
        self.dataProvider = dataProvider
    }
    
    func start() {
        let viewModel = MovieListViewModel(service: dataProvider.movieList)
        let movieListViewController = MovieListViewController.instantiate()
        movieListViewController.viewModel = viewModel
        movieListViewController.delegate = self
        
        self.movieListViewController = movieListViewController
        presenter.pushViewController(movieListViewController, animated: true)
    }
}

// MARK: - Delegate

extension MovieListCoordinator: MovieListViewControllerDelegate {
    func movieListViewController(didSelect movieId: Int) {
        let movieDetailCoordinator = MovieDetailCoordinator(presenter: presenter, movieId: movieId, dataProvider: dataProvider)
        self.movieDetailCoordinator = movieDetailCoordinator
        movieDetailCoordinator.start()
    }
}
