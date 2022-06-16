//
//  AppFonts.swift
//
//  Created by Nicolae Rogojan on 25.10.2021.
//

import UIKit

public protocol AppFonts {
    /// 16 - Regular
    var body1: UIFont { get }
    
    /// 14 - Regular
    var body2: UIFont { get }
    
    /// 12 - Regular
    var body3: UIFont { get }
    
    /// 16 - Bold
    var body1Bold: UIFont { get }
    
    /// 14 - Bold
    var body2Bold: UIFont { get }
    
    /// 12 - Bold
    var body3Bold: UIFont { get }
    
    func defaultFont(ofSize size: CGFloat) -> UIFont
    func defaultFont(ofSize size: CGFloat, weight: UIFont.Weight?) -> UIFont
}

struct DefaultFont: AppFonts {
    
    public func defaultFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name:"HelveticaNeue", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    public func defaultFont(ofSize size: CGFloat, weight: UIFont.Weight? = nil) -> UIFont {
        if let weight = weight {
            return UIFont(name:"HelveticaNeue-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        } else {
            return defaultFont(ofSize: size)
        }
    }
    
    /// 16 - Regular
    var body1: UIFont { defaultFont(ofSize: 16) }
    
    /// 14 - Regular
    var body2: UIFont { defaultFont(ofSize: 14) }
    
    /// 12 - Regular
    var body3: UIFont { defaultFont(ofSize: 12) }
    
    /// 16 - Bold
    var body1Bold: UIFont { defaultFont(ofSize: 16, weight: .bold) }
    
    /// 14 - Bold
    var body2Bold: UIFont { defaultFont(ofSize: 14, weight: .bold) }
    
    /// 12 - Bold
    var body3Bold: UIFont { defaultFont(ofSize: 12, weight: .bold) }
}
