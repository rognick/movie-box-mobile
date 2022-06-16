//
//  RatingView.swift
//

import UIKit

class RatingView: UIView {
    
    private var info: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ThemeSettings.theme.fonts.body1Bold
        label.textColor = ThemeSettings.theme.colors.label
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private var budgetView = BadgeView()
    private var percentageString: NSAttributedString? {
        percentageAttributedString(arc?.percentage)
    }
    
    var arc: BadgeArc? {
        didSet {
            budgetView.arc = arc
            info.attributedText = percentageString
        }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        initSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    private func initSubviews() {
        backgroundColor = .clear
        addSubview(budgetView)
        addSubview(info)

        budgetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            budgetView.topAnchor.constraint(equalTo: topAnchor),
            budgetView.bottomAnchor.constraint(equalTo: bottomAnchor),
            budgetView.leadingAnchor.constraint(equalTo: leadingAnchor),
            budgetView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        info.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            info.centerYAnchor.constraint(equalTo: centerYAnchor),
            info.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func percentageAttributedString(_ value: Double?) -> NSAttributedString? {
        guard let value = value else { return nil }
        
        let percentage = String(format: "%3.0f", (value))
        let percentSign = "%"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let font = ThemeSettings.theme.fonts.defaultFont(ofSize: 16, weight: .bold)
        let superscriptFontSize = (font.pointSize / 2)
        let superscriptFont = ThemeSettings.theme.fonts.defaultFont(ofSize: superscriptFontSize, weight: .bold)
        let baselineOffset = (font.pointSize - superscriptFontSize) - (font.pointSize * 0.15)
        
        let attributedString = NSMutableAttributedString(string: percentage,
                                                         attributes: [
                                                            .paragraphStyle: paragraphStyle,
                                                            .font : font,
                                                            .foregroundColor: UIColor.white
                                                         ])
        
        let boldString = NSMutableAttributedString(string: percentSign,
                                                   attributes:[
                                                    .font : superscriptFont,
                                                    .foregroundColor: UIColor.white,
                                                    .baselineOffset: baselineOffset
                                                   ])
        attributedString.append(boldString)
        return attributedString
    }
}
