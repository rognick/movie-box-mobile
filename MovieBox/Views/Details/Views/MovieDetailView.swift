//
//  MovieDetailView.swift
//
//  Created by Nicolae Rogojan on 21.10.2021.
//

import UIKit
import Combine

class MovieDetailView: BaseView {
    
    var didTapClose: (() -> Void)?
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = ThemeSettings.theme.colors.label
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    lazy var poster: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = ThemeSettings.theme.colors.label
        return imageView
    }()

    private var header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ThemeSettings.theme.fonts.body1Bold
        label.textColor = ThemeSettings.theme.colors.label
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private var subtitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ThemeSettings.theme.fonts.body3
        label.textColor = ThemeSettings.theme.colors.label
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private var overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ThemeSettings.theme.fonts.body1Bold
        label.textColor = ThemeSettings.theme.colors.label
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private var overview: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ThemeSettings.theme.fonts.body2
        label.textColor = ThemeSettings.theme.colors.label
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let genresView: GenresList = {
        let view = GenresList()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
        
    func render(_ model: MovieDetailModel?) {
        header.text = model?.title
        overviewLabel.text = "Overview".localized
        subtitle.text = model?.subtitle
        overview.text = model?.overview
        genresView.render(model?.genres)
        model?.poster
            .receive(on: DispatchQueue.main)
            .replaceError(with: UIImage(systemName: "film"))
            .assign(to: \.poster.image, on: self)
            .store(in: &cancellables)
    }
    
    override func setupView() {
        super.setupView()
        let subviews = [closeButton, poster, header, subtitle, overviewLabel, overview, genresView]
        subviews.forEach(addSubview(_:))
        setupContraints()
    }
    
    private func setupContraints() {
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 18),
            closeButton.heightAnchor.constraint(equalToConstant: 18),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 31),
            trailingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            poster.widthAnchor.constraint(equalToConstant: 135),
            poster.heightAnchor.constraint(equalToConstant: 201),
            poster.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 26),
            poster.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 6),
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26),
            trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            subtitle.topAnchor.constraint(equalTo: header.bottomAnchor),
            subtitle.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            subtitle.trailingAnchor.constraint(equalTo: header.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 41),
            trailingAnchor.constraint(equalTo: overviewLabel.trailingAnchor, constant: 41)
        ])
        
        NSLayoutConstraint.activate([
            overview.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            overview.leadingAnchor.constraint(equalTo: overviewLabel.leadingAnchor),
            overview.trailingAnchor.constraint(equalTo: overviewLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            genresView.topAnchor.constraint(equalTo: overview.bottomAnchor, constant: 20),
            genresView.leadingAnchor.constraint(equalTo: overviewLabel.leadingAnchor),
            genresView.trailingAnchor.constraint(equalTo: overviewLabel.trailingAnchor)
        ])
    }
    
    @objc private func didTapCloseButton() {
        didTapClose?()
    }
}
