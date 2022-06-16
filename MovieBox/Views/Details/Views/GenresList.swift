//
//  GenresList.swift
//
//  Created by Nicolae Rogojan on 21.10.2021.
//

import UIKit
import Combine

// MARK: - Protocol GenreType

protocol GenreType {
    var name: String { get }
}

// MARK: - GenresList

class GenresList: BaseView {
    
    private var rows = 0
    private let tagHeight: CGFloat = 22
    private let insets = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        defer { rearrangeViews() }
        super.layoutSubviews()
    }
    
    override var intrinsicContentSize: CGSize {
        var height = CGFloat(rows) * (tagHeight + insets.top)
        if rows > 0 {
            height -= insets.top
        }
        return CGSize(width: frame.width, height: height)
    }
    
    // MARK: - Public Methods render
    
    func render(_ genres: [GenreType]?) -> Void {
        guard let genres = genres else { return }
        subviews.forEach { $0.removeFromSuperview() }
        genres.map(createLabel(with:)).forEach(addSubview(_:))
    }
    
    // MARK: - Setups
    
    private func createLabel(with value: GenreType) -> UILabel {
        let label = UILabel()
        label.font = ThemeSettings.theme.fonts.body2
        label.textColor = UIColor.black
        label.text = value.name
        label.textAlignment = .center
        label.backgroundColor = UIColor.white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.frame.size.width = label.intrinsicContentSize.width + insets.left + insets.right
        label.frame.size.height = tagHeight
        return label
    }
    
    private func rearrangeViews() -> Void {
        
        let frameWidth = frame.size.width
        var currentOriginX: CGFloat = 0
        var currentOriginY: CGFloat = 0
        var currentRow = subviews.isEmpty ? 0 : 1
        
        subviews.forEach { item in
            // if current X + item width will be greater than self width -> move to next row
            if currentOriginX + item.frame.width > frameWidth {
                currentRow += 1
                currentOriginX = 0
                currentOriginY += tagHeight + insets.top
            }
            
            item.frame.origin.x = currentOriginX
            item.frame.origin.y = currentOriginY
            currentOriginX += item.frame.width + insets.right
        }
        
        rows = currentRow
        invalidateIntrinsicContentSize()
    }
}

// MARK: - Protocol Conformance

extension Genre: GenreType {}
