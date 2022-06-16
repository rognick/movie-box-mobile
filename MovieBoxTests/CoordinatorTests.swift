//
//  CoordinatorTests.swift
//
//  Created by Nicolae Rogojan on 24.10.2021.
//

import XCTest
@testable import MovieBox

class CoordinatorTests: XCTestCase {
    private lazy var flowCoordinator = ApplicationCoordinator(window: window, dataProvider: DataProvider())
    private let window =  UIWindow()
    
    func test_startsApplicationsFlow() {

        flowCoordinator.start()
        
        let rootViewController = window.rootViewController
        XCTAssert(rootViewController is UINavigationController)
        XCTAssert(rootViewController?.children.first is MovieListViewController)
    }
    
    func test_startsApplicationsFlow2() {

        flowCoordinator.start()
        
        let rootViewController = window.rootViewController
        XCTAssert(rootViewController is UINavigationController)
        XCTAssert(rootViewController?.children.first is MovieListViewController)
    }
}
