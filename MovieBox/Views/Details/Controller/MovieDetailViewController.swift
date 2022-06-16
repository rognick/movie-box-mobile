//
//  MovieDetailViewController.swift
//
//  Created by Nicolae Rogojan on 21.10.2021.
//

import UIKit
import Combine

class MovieDetailViewController: UIViewController {
    
    weak var coordinator: MovieDetailCoordinatorDelegate?
    
    private var viewModel: MovieDetailsViewModel
    private let currentView = MovieDetailView()
    private let appear = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.center = view.center
        return indicator
    }()
    
    // MARK: - Initializers
    
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        self.view = currentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appear.send(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        binding(to: viewModel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.center = view.center
    }
    
    // MARK: - Private
    // MARK: Setups
    
    private func setupView() {
        title = "Movie Detail"
        view.backgroundColor = UIColor.black.withAlphaComponent(0.82)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func binding(to viewModel: MovieDetailsViewModel) {
        currentView.didTapClose = { [weak coordinator] in
            coordinator?.didTapClose()
        }
        
        let publisher = viewModel.modelPublisher(input: appear.eraseToAnyPublisher())
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] error in
                self.activityIndicator.stopAnimating()
                self.showErrorAlert { [weak coordinator] _ in
                    coordinator?.didTapClose()
                }
            } receiveValue: { [unowned self] model in
                self.activityIndicator.stopAnimating()
                self.currentView.render(model)
            }.store(in: &cancellables)
    }
}
