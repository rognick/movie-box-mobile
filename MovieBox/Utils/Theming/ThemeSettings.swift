//
//  ThemeSettings.swift
//
//  Created by Nicolae Rogojan on 24.10.2021.
//

import UIKit

protocol ThemeContract {
    var colors: AppColors { get }
    var fonts: AppFonts { get }
    
    var navigationBarColor: UIColor { get }
    var indicatorColor: UIColor { get }
    var navigationBarButtonColor: UIColor { get }
    
    /// RatingView
    var ratingViewBackround: UIColor { get }
    var ratingViewYellow: UIColor { get }
    var ratingViewGreen: UIColor { get }
}

class ThemeSettings {
    static var theme: ThemeContract = DefaultTheme()
        
    static func apply(theme: ThemeContract = DefaultTheme()) {
        let navAppearance = UINavigationBar.appearance()
        navAppearance.prefersLargeTitles = false
        navAppearance.isTranslucent = false
        navAppearance.barTintColor = theme.navigationBarColor
        
        UIActivityIndicatorView.appearance().color = theme.indicatorColor
        UIBarButtonItem.appearance().tintColor = theme.navigationBarButtonColor
        UISegmentedControl.appearance().tintColor = theme.navigationBarButtonColor
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = theme.navigationBarButtonColor
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).overrideUserInterfaceStyle = .dark
    }
}
