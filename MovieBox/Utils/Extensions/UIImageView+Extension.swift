//
//  UIImageView+Extension.swift
//
//  Created by Nicolae Rogojan on 24.10.2021.
//

import UIKit

extension UIImageView {

    static let loadingViewTag = 1938123987
    
    //// Returns activity indicator view centrally aligned inside the UIImageView
    var activityIndicator: UIActivityIndicatorView {
        if let indicator = self.viewWithTag(UIImageView.loadingViewTag) as? UIActivityIndicatorView {
            return indicator
        }
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.white
        activityIndicator.tag = UIImageView.loadingViewTag
        self.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        let centerX = NSLayoutConstraint(item: self,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        let centerY = NSLayoutConstraint(item: self,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)
        self.addConstraints([centerX, centerY])
        return activityIndicator
    }
}
