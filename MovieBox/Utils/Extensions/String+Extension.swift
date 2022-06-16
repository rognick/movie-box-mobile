//
//  String+Extension.swift
//
//  Created by Nicolae Rogojan on 22.10.2021.
//

import Foundation

extension String {
    var localized: String {
        if let value = localized(for: .main) { return value }
        return self
    }
    
    internal func localized(for bundle: Bundle) -> String? {
        let value = bundle.localizationFramework.localizedString(forKey: self, value: self, table: nil)
        return value == self ? nil : value
    }
    
    func removeHexPrefixes() -> String {
        var hexString = self

        if hexString.hasPrefix("#") { // Remove the '#' prefix if added.
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            hexString = String(hexString[start...])
        }

        if hexString.lowercased().hasPrefix("0x") { // Remove the '0x' prefix if added.
            let start = hexString.index(hexString.startIndex, offsetBy: 2)
            hexString = String(hexString[start...])
        }

        return hexString
    }
}
