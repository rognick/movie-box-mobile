//
//  DefaultTheme.swift
//
//  Created by Nicolae Rogojan on 24.10.2021.
//

import UIKit

struct DefaultTheme: ThemeContract {
    
    var colors: AppColors = DefaultColor()
    var fonts: AppFonts = DefaultFont()
    
    var navigationBarButtonColor: UIColor { UIColor.create(hex: "fcd052") }
    var navigationBarColor: UIColor { colors.primary }
    var indicatorColor: UIColor { .white }
    
    var ratingViewBackround: UIColor { UIColor.create(hex: "071B22") }
    var ratingViewYellow: UIColor { .yellow }
    var ratingViewGreen: UIColor { .green }
}
