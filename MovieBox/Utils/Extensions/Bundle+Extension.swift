//
//  Bundle+Extension.swift
//
//  Created by Nicolae Rogojan on 22.10.2021.
//

import Foundation

extension Bundle {
    var localizationFramework: Bundle {
        guard
            let bundlePath = path(forResource: currentLanguage(of: self), ofType: "lproj"),
            let bundle = Bundle(path: bundlePath)
        else {
            return .main
        }

        return bundle
    }

    private func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
    
    private func currentLanguage(of bundle: Bundle) -> String {
        return String(getPreferredLocale().identifier.prefix(2))
    }
}
