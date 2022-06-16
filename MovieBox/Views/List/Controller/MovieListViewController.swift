//
//  ViewController.swift
//
//  Created by Nicolae Rogojan on 21.10.2021.
//

import UIKit
import Combine

class MovieListViewController: UIViewController, Storyboarded {

    weak var delegate: MovieListViewControllerDelegate?
    var viewModel: MovieListViewModel!

    private let popular = PassthroughSubject<Int, Never>()
    private let playing = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
    private var currentPage = 1
    private var popularMoviesItems: [MovieListModel] = []

    private lazy var dataSource = makeDataSource()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nowPlayingView: MovieNowPlayingView!

    @IBOutlet weak var moviesTableView: UITableView! {
        didSet {
            moviesTableView.delegate = self
            moviesTableView.backgroundColor = .clear
            moviesTableView.tableHeaderView?.backgroundColor = ThemeSettings.theme.colors.secondary
            moviesTableView.dataSource = dataSource
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        binding(to: viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        popular.send(currentPage)
        playing.send()
    }

    // MARK: - Private
    // MARK: Setups

    private func setupView() {
        view.backgroundColor = ThemeSettings.theme.colors.primary

        let logo = UIImage(named: "small_moviebox")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        self.navigationItem.title = nil
    }

    private func binding(to viewModel: MovieListViewModel) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let modelPublisher = viewModel.modelPublisher(playing: playing, popular: popular)

        // receive on RunLoop.main for smoother animation
        modelPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] state in
                self.render(state)
            })
            .store(in: &cancellables)
    }

    private func render(_ state: MovieListViewModel.State) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()

        case .failure(_):
            activityIndicator.stopAnimating()
            showErrorAlert()

        case .popularMovies(let newMovies):
            activityIndicator.stopAnimating()
            let movies = append(newMovies: newMovies)
            update(with: movies)

        case .nowPlayingMovies(let item):
            activityIndicator.stopAnimating()
            nowPlayingView.render(item)
        }
    }
}

// MARK: - UITableViewDelegate

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.movieListViewController(didSelect: popularMoviesItems[indexPath.row].id)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 5 == popularMoviesItems.count {
            currentPage += 1
            popular.send(currentPage)
        }
    }
}

extension MovieListViewController {
    enum Section: CaseIterable {
        case movies
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, MovieListModel> {
        return UITableViewDiffableDataSource(
            tableView: moviesTableView,
            cellProvider: {  tableView, indexPath, movieViewModel in
                let cell: MovieCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell",
                                                                    for: indexPath) as! MovieCell

                cell.render(movieViewModel)
                return cell
            }
        )
    }

    func append(newMovies: [MovieListModel]) -> [MovieListModel] {
        // check for duplicates
        for unique in newMovies {
            if self.popularMoviesItems.first(where: { $0 == unique }) == nil {
                self.popularMoviesItems.append(unique)
            }
        }
        return popularMoviesItems
    }

    func update(with movies: [MovieListModel], animate: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieListModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(movies, toSection: .movies)
        self.dataSource.apply(snapshot, animatingDifferences: animate)
    }
}
