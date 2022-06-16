//
//  ApplicationCoordinator.swift
//
//  Created by Nicolae Rogojan on 22.10.2021.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    
    private let window: UIWindow
    private let rootViewController: UINavigationController
    private var movieListCoordinator: MovieListCoordinator?
    private let dataProvider: DataProvider
    
    init(window: UIWindow, dataProvider: DataProvider) {
        self.window = window
        self.dataProvider = dataProvider
        rootViewController = UINavigationController()
        movieListCoordinator = MovieListCoordinator(presenter: rootViewController, dataProvider: dataProvider)
    }
    
    func start() {
        window.rootViewController = rootViewController
        movieListCoordinator?.start()
        window.makeKeyAndVisible()
    }
}
