//
//  AppColors.swift
//
//  Created by Nicolae Rogojan on 25.10.2021.
//

import UIKit

public protocol AppColors {
    var primary: UIColor { get }
    var secondary: UIColor { get }
    var label: UIColor { get }
}

struct DefaultColor: AppColors {
    var primary: UIColor = UIColor.create(hex: "212121")
    var secondary: UIColor = UIColor.create(hex: "404040")
    var label = UIColor.create(hex: "cdcdcd")
}
