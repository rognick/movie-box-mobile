//
//  UIColor.swift
//
//  Created by Nicolae Rogojan on 21.10.2021.
//

import UIKit

extension UIColor {
    /// Create `UIColor` from hexadecimal string.
    ///
    /// - Parameter hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    static func create(hex: String) -> UIColor {
        let hexString = hex.removeHexPrefixes()
        let scanner = Scanner(string: hexString)
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else { return .clear } // Make sure the strinng is a hex code.
        switch hexString.count {
        case 3, 4: // Color is in short hex format
            var updatedHexString = ""
            hexString.forEach { updatedHexString.append(String(repeating: String($0), count: 2)) }
            return create(hex: updatedHexString)

        case 6: // Color is in hex format without alpha.
            return UIColor(red: CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0,
                        green: CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0,
                        blue: CGFloat(hexNumber & 0x0000FF) / 255.0,
                        alpha: 1.0)

        case 8: // Color is in hex format with alpha.
            return UIColor(red: CGFloat((hexNumber & 0xFF000000) >> 24) / 255.0,
                        green: CGFloat((hexNumber & 0x00FF0000) >> 16) / 255.0,
                        blue: CGFloat((hexNumber & 0x0000FF00) >> 8) / 255.0,
                        alpha: CGFloat(hexNumber & 0x000000FF) / 255.0)

        default: return .clear // Invalid format.
        }
    }
}
