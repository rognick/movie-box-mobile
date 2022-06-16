//
//  MovieCollectionViewCell.swift
//
//  Created by Nicolae Rogojan on 23.10.2021.
//

import UIKit
import Combine

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var poster: UIImageView!
    static let identifier: String = "\(MovieCollectionViewCell.self)"
    
    private var cancellable: AnyCancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        poster.activityIndicator.startAnimating()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        poster.activityIndicator.startAnimating()
        poster.image = nil
        cancellable?.cancel()
    }
    
    func render(_ model: MovieListModel) {
        cancellable = model.posterPublisher
            .replaceError(with: UIImage(systemName: "film"))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                self?.poster.image = image
                self?.poster.activityIndicator.stopAnimating()
            })
    }
}
