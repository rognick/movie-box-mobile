//
//  MovieCell.swift
//
//  Created by Nicolae Rogojan on 23.10.2021.
//

import UIKit
import Combine

//
// MARK: - Movie Cell
//
class MovieCell: UITableViewCell {

    //
    // MARK: - Class Constants
    //
    static let identifier = "MovieCell"

    //
    // MARK: - IBOutlets
    //
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rating: RatingView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var poster: UIImageView!
    private var cancellable: AnyCancellable?
    private var theme = ThemeSettings.theme

    override func prepareForReuse() {
        super.prepareForReuse()
        poster.activityIndicator.startAnimating()
        poster.image = nil
        cancellable?.cancel()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        addTopBorder(with: theme.colors.secondary, andWidth: 3)
        addBottomBorder(with: theme.colors.secondary, andWidth: 3)
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        title.font = ThemeSettings.theme.fonts.body2Bold
        title.textColor = ThemeSettings.theme.colors.label
        releaseDate.font = ThemeSettings.theme.fonts.body3
        releaseDate.textColor = ThemeSettings.theme.colors.label
        releaseDate.numberOfLines = 2
        poster.activityIndicator.startAnimating()
    }

    func render(_ model: MovieListModel) {
        title.text = model.title
        releaseDate.text = model.subtitle
        let percentage = model.votePercentage
        rating.arc = BadgeArc(percentage: percentage)

        // Using RunLoop.main would block images from loading as long as the table view was scrolling.
        // But switching to DispatchQueue.main allowed the images to load while it was scrolling.
        cancellable = model.posterPublisher
            .replaceError(with: UIImage(systemName: "film"))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                self?.poster.image = image
                self?.poster.activityIndicator.stopAnimating()
            })
    }
}

private extension MovieCell {
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
}
