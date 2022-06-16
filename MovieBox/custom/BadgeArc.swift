//
//  BudgetArc.swift
//
//  Created by Nicolae Rogojan on 22.10.2021.
//

import UIKit

struct BadgeArc {
    let percentage: Double

    var percentageColor: UIColor {
        let yellow = ThemeSettings.theme.ratingViewYellow
        let green = ThemeSettings.theme.ratingViewGreen

//        Use Yellow tint for movie ratings less than 50% and Green for 50% and above.
        return percentage < 50 ? yellow : green
    }

    var backgroundColor: UIColor {
        return percentageColor.withAlphaComponent(0.40)
    }
}
