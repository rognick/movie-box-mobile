//
//  UtilsTests.swift
//
//  Created by Nicolae Rogojan on 24.10.2021.
//

import XCTest
import Combine

@testable import MovieBox

class UtilsTests: XCTestCase {
    func test_removeHexPrefixes() {
        let input = "#0X123456789"
        let expect = "123456789"
        XCTAssertEqual(input.removeHexPrefixes(), expect)
    }
    
    func test_localized() {
        XCTAssertEqual("shared_error_title".localized, "Loading error")
        XCTAssertEqual("Test Localized".localized, "Test Localized")
    }
    
    func test_Color() {
        XCTAssertEqual(UIColor.create(hex: "#0000"), UIColor(red: 0, green: 0, blue: 0, alpha: 0))
        XCTAssertEqual(UIColor.create(hex: "#000000"), UIColor(red: 0, green: 0, blue: 0, alpha: 1))
        XCTAssertEqual(UIColor.create(hex: "#00000066"), UIColor(red: 0, green: 0, blue: 0, alpha: 0.4))
    }
}
